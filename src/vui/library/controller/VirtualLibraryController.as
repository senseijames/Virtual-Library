package vui.library.controller
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;
    
    import vui.library.mapper.FileSystemMapper;
    import vui.library.mapper.VirtualFolderMapper;
    import vui.library.model.FileDirectory;
    import vui.library.model.VirtualFolder;
    import vui.library.model.VirtualFolderEvent;
    import vui.library.view.console.ConsoleOutput;
    import vui.library.view.ui.Chrome;
    import vui.library.view.ui.menu.Menu;
    
    /**
     * I don't think it should subclass Sprite; a controller should have no visual representation.
     */ 
    public class VirtualLibraryController
    {
        // TODO: Consider moving these to a "Config" class (encapsulation, and if you make vars you can change dynamically)
        public static var CHROME_HEIGHT : uint = 30;
        public static const MENU_BG_COLOR : uint = 0xCDCDCD;
        public static const MENU_BG_ALPHA : Number = 0.7;
        public static const MENU_WIDTH : uint = 400;
        public static const MENU_HEIGHT : uint = 400;
        
        // State.
        protected var _directory_trees : Vector.<FileDirectory>;
        protected var _virtual_folders : Vector.<VirtualFolder>;
        // TODO: Replace this, either by pulling off of the Chrome input field directly (okay) or by sending with the event (better).
        protected var _depth : uint;
        protected var _show_hidden : Boolean;
        protected var _is_loose_pack : Boolean;
        // Delegates.
        protected var _file_browser : File;
        // UI Elements
        protected var _container : DisplayObjectContainer;
        protected var _view : ConsoleOutput;
        protected var _chrome : Chrome;
        protected var _menu : Menu;
        
        // Convoluted to have a constructor, init and run that could all be just in the constructor?  Or good decomposition?  Time will tell?
        public function VirtualLibraryController()
        {
            _view = new ConsoleOutput();
            _chrome = new Chrome();
            _directory_trees = new Vector.<FileDirectory>();
        }
        
        
        /* * * * * * * * * * * * * * * * *
        * Public Interface
        * * * * * * * * * * * * * * * * */
        
        /**
         *  @param options  depth:uint              depth for recursive directory search
         *  @param options  show_hidden:Boolean     whether to show hidden files
         *  @param options  is_loose_pack:Boolean   whether to place files (books) tightly on the shelves (false), or to make a folder = a shelf (minimum) (true)
         */ 
        public function init(container:DisplayObjectContainer, options:Object):void
        {
            _container = container;
            _depth = (options.depth != undefined) ? options.depth : 3;
            _show_hidden = options.show_hidden;
            _is_loose_pack = options.is_loose_pack;
            
            _chrome.init({ height: CHROME_HEIGHT, width: container.stage.stageWidth, color: 0x00FF00, alpha: 0.5 });
            _chrome.addEventListener(Chrome.OPEN_FILE_BROWSER_EVENT, file_browser_OPEN);
//            _chrome.addEventListener(TextEvent.TEXT_INPUT, search_text_CHANGE);
            _chrome.addEventListener(Event.CHANGE, search_text_CHANGE);
            _chrome.addEventListener(Chrome.CLEAR_LIBRARY_EVENT, library_CLEAR);
            _chrome.addEventListener(Chrome.TOGGLE_MENU_EVENT, toggle_menu_CLICK);
            
            // TODO: Move to layout method, so can separate add_content() from layout_content() so that window resize events are handled gracefully.
            _chrome.y = container.stage.stageHeight - _chrome.height;
//            _chrome.x = -20;
            container.addChild(_chrome);
            
            _view.init({ is_loose_pack: _is_loose_pack, depth: _depth });

            init_virtual_folders();

//            open_file_browser();
        }

        
        /* * * * * * * * * * * * * * * * * * *
        * Initialization
        * * * * * * * * * * * * * * * * * * */

        protected function init_menu():void
        {
            _menu = new Menu();
            _menu.init({ width: MENU_WIDTH, height: MENU_HEIGHT, bgColor: MENU_BG_COLOR, bgAlpha: MENU_BG_ALPHA, folders: _virtual_folders });
            // folders: array_of_virtual_folders
            _menu.x = 0.5 * (_container.stage.stageWidth - MENU_WIDTH);
            _menu.y = 0.5 * (_container.stage.stageHeight - MENU_HEIGHT);
            
            _menu.addEventListener(VirtualFolderEvent.CREATE_FOLDER, virtual_folder_CREATE);
            _menu.addEventListener(VirtualFolderEvent.DELETE_FOLDER, virtual_folder_DELETE);
            _menu.addEventListener(VirtualFolderEvent.ADD_FILE, virtual_folder_file_ADD);
            _menu.addEventListener(VirtualFolderEvent.REMOVE_FILE, virtual_folder_file_REMOVE);

            _container.addChild(_menu);
        }

        protected function init_virtual_folders():void
        {
            _virtual_folders = VirtualFolderMapper.init();
        }

        
        /* * * * * * * * * * * * * * * * * * *
        * Helpers - file aggregators 
        *           (arrays -> bookshelves)
        * * * * * * * * * * * * * * * * * * */
        
        /**
         * @param   options.is_append:Boolean   whether the add() operation appends to the existing library or replaces it
         * 
         */
        // Eligible for public I/F, should one be needed.
        protected function add_directories_to_view(file_directory:FileDirectory, depth:int):void //, options:Object):void
        {
            if (!file_directory.directory.isDirectory) {
                return;
            }
            
            add_directory_to_view(file_directory, depth);
            
            if (!file_directory.files || depth >= _depth) {
                return;
            }
            
            for (var i:uint = 0; i < file_directory.files.length; i++)
            {
                add_directories_to_view(file_directory.files[i], depth + 1);
            }
        }
        
        protected function add_directory_to_view(file_directory:FileDirectory, depth:uint):void
        {
            _view.add_directory(file_directory, depth);
//trace('Adding to view at depth', depth, ':', file_directory.directory.name);            
        }

        
        /* * * * * * * * * * * * * * * * *
        * Live search
        * * * * * * * * * * * * * * * * */
        
        protected function search_text_CHANGE(event:Event):void
        {
            // Note that the event is dispatched BEFORE the TextField contents change, hence
            // the need to append the new text.            
            var query:String = event.target.text;
            trace('[Virtual Library Controller] Search text change event caught:', query);
            filename_search(query);
        }

        public function filename_search(query:String):void
        {
            trace('\nPerforming file search for query:', query);
            if (_directory_trees.length == 0) {
                return;
            }

            _view.live_search(query);
            /*
            TODO - this class should have a Vector of FileDirectory, rather than just one.  Similarly,
            the View should probably also have that state.  What you are trying to preclude is too much encapsulation
            because it will hurt performance - in the current decomposition, you will crawl the FileDirectory for search
            hits and pass them to the view, one by one, but then the View will have to crawl its directory of files as well
            (note that the View currently does not store that state), meaning order O(N ^ 2).
            */
            
//            for (var i:uint = 0; i < _directory_trees.length; i++)
//            {
//                
//                if (_directory_trees[i].directory.name.indexOf(query) != -1) {
//    //                high
//                }
//            }
        }
        

        /* * * * * * * * * * * * * * * * *
         * File Browser Event Handlers
         * * * * * * * * * * * * * * * * */

        /*
            On Android devices, browseForDirectory() is not supported. The File object dispatches a cancel event immediately.
            On iOS devices, file and browse dialogs are not supported. This method cannot be used.
                Solution: Use native extensions.  On iOS could parse a text field for the path.  On Android, could use open() and filter for folders.
        */
        protected function file_browser_OPEN(e:Event):void
        {
            if (!_file_browser) 
            {
                _file_browser = new File();
                
                _file_browser.addEventListener(Event.SELECT, file_browser_SELECT);
                _file_browser.addEventListener(Event.CANCEL, file_browser_CANCEL);
                _file_browser.addEventListener(IOErrorEvent.IO_ERROR, file_browser_IO_ERROR);
            }
            else 
            {
                _file_browser.cancel();  
            }
            
            try {
                _file_browser.browseForDirectory('Please select a directory to render in the Virtual Library');
            }
            catch (e:Error) {
                /*
                    IllegalOperationError — A browse operation (browseForOpen(), browseForOpenMultiple(), browseForSave(), browseForDirectory()) is currently running.
                    SecurityError — The application does not have the necessary permissions.
                */
                trace('File browser browseForDirectory error:', e); 
            }
        }
        
        protected function file_browser_SELECT(event:Event):void
        {
            // TODO: Ammend duplication in run.  Best I/F for this?
            _directory_trees.push(FileSystemMapper.get_directory_tree(File(event.target), _depth, { show_hidden: _show_hidden }));
            add_directories_to_view(_directory_trees[_directory_trees.length - 1], 0);
            _view.render();
        }
        protected function file_browser_CANCEL(event:Event):void
        {
            trace('\nFile browser Cancel!  File browser possibly closed by user:', event.toString());
        }
        protected function file_browser_IO_ERROR(event:Event):void
        {
            trace('\nFile browser IO Error!  File Browser may be unsupported on this platform:', event.toString());
        }


        /* * * * * * * * * * * * * * * * *
        * Menu event handling
        * * * * * * * * * * * * * * * * */
        
        protected function toggle_menu_CLICK(event:Event):void
        {
            if (!_menu) {
                init_menu();
            }
            else {
                _menu.visible = !_menu.visible;
            }
        }

        /* * * * * * * * * * * * * * * * * * * * * * *
        * Menu - virtual folder CRUD event handling
        * * * * * * * * * * * * * * * * * * * * * * */

        protected function virtual_folder_CREATE(event:VirtualFolderEvent):void
        {
            trace('[Controller] Virtual folder create event caught!', event.type);
            
            VirtualFolderMapper.create_folder(event.target_folder);
            
            synch_virtual_folders();
        }
        protected function virtual_folder_DELETE(event:VirtualFolderEvent):void
        {
            trace('[Controller] Virtual folder delete event caught!', event.type);
            
            VirtualFolderMapper.delete_folder(event.target_folder);
            
            synch_virtual_folders();
        }
        protected function virtual_folder_file_ADD(event:VirtualFolderEvent):void
        {
            trace('[Controller] Virtual folder file add event caught!', event.type);
            
            VirtualFolderMapper.add_files_to_folder(event.target_folder, event.target_files);
            
            synch_virtual_folders();
        }
        protected function virtual_folder_file_REMOVE(event:VirtualFolderEvent):void
        {
            trace('[Controller] Virtual folder file remove event caught!', event.type);
            
            VirtualFolderMapper.remove_files_from_folder(event.target_folder, event.target_files);
            
            synch_virtual_folders();
        }

        protected function synch_virtual_folders():void
        {
            _menu.virtual_folders = _virtual_folders = VirtualFolderMapper.folders;
        }

        
        /* * * * * * * * * * * * * * * * *
        * Other event handling
        * * * * * * * * * * * * * * * * */
        
        protected function library_CLEAR(event:Event):void
        {
            _view.clear();
        }
        
        
        /* * * * * * * * * * * * * * * * *
        * Deprecated
        * * * * * * * * * * * * * * * * */
        
//        protected function add_directory_children_to_view(file_directory:FileDirectory, depth:uint):void
//        {
//            for (var i:uint = 0; i < file_directory.files.length; i++)
//            {
//                _view.add_book(file_directory.files[i].directory, depth);
//            }
//        }
        
    }
}