package vui.library.controller
{
    import flash.display.DisplayObjectContainer;
    import flash.events.ActivityEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.KeyboardEvent;
    import flash.filesystem.File;
    import flash.media.Video;
    import flash.ui.Keyboard;
    import flash.utils.setTimeout;
    
    import vui.library.mapper.FileSystemMapper;
    import vui.library.mapper.VirtualFolderMapper;
    import vui.library.model.FileDirectory;
    import vui.library.model.VirtualFolder;
    import vui.library.model.VirtualFolderEvent;
    import vui.library.view.console.ConsoleOutput;
    import vui.library.view.engine.VirtualLibraryEngine;
    import vui.library.view.ui.Chrome;
    import vui.library.view.ui.menu.Menu;
    import vui.ui.WebCamera;
    
    public class VirtualLibraryController
    {
        // TODO: Consider moving these to a "Config" class (encapsulation, and if you make vars you can change dynamically)
        public static const CHROME_HEIGHT : uint = 30;
        public static const MENU_BG_COLOR : uint = 0xCDCDCD;
        public static const MENU_BG_ALPHA : Number = 0.7;
        public static const MENU_WIDTH : uint = 400;
        public static const MENU_HEIGHT : uint = 400;
        
        // Entities
        protected var _engine : VirtualLibraryEngine;
//        protected var _engine : VirtualLibraryEngineTest;
        protected var _webcam : WebCamera;
        protected var _virtual_folders : Vector.<VirtualFolder>;
        protected var _directory_trees : Vector.<FileDirectory>;
        // Delegates
        protected var _file_browser : File;
        // State
        protected var _config : Object;
        protected var _depth : uint; // TODO: Replace this, either by pulling off of the Chrome input field directly (okay) or by sending with the event (better).
        protected var _show_hidden : Boolean;
        protected var _is_loose_pack : Boolean;
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
         *  @param options  use_webcam:Boolean      whether to use the webcam for 'gesture' navigation
         *  @param options  webcam_activity_level:uint
         *  @param options  webcam_activity_time:uint
         *  @param options  webcam_show_video:Boolean
         */ 
        public function init (container:DisplayObjectContainer, options:Object) : void
        {
            _container = container;
            _config = options;
            _depth = (options.depth != undefined) ? options.depth : 3;
            _show_hidden = options.show_hidden;
            _is_loose_pack = options.is_loose_pack;
            
            _chrome.init({ height: CHROME_HEIGHT, width: container.stage.stageWidth, color: 0x00FF00, alpha: 0.5 });
            _chrome.addEventListener(Chrome.OPEN_FILE_BROWSER_EVENT, file_browser_OPEN);
            _chrome.addEventListener(Chrome.VIEW_VIRTUAL_FOLDERS_EVENT, virtual_folders_VIEW);
//            _chrome.addEventListener(TextEvent.TEXT_INPUT, search_text_CHANGE);
            _chrome.addEventListener(Event.CHANGE, search_text_CHANGE);
            _chrome.addEventListener(Chrome.CLEAR_LIBRARY_EVENT, library_CLEAR);
            _chrome.addEventListener(Chrome.TOGGLE_MENU_EVENT, toggle_menu_CLICK);
            _chrome.addEventListener(VirtualFolderEvent.CREATE_FOLDER_AND_ADD_FILES, virtual_folder_CREATE_AND_ADD);
            
            // TODO: Move to layout method, so can separate add_content() from layout_content() so that window resize events are handled gracefully.
            _chrome.y = container.stage.stageHeight - _chrome.height;
//            _chrome.x = -20;
            container.addChild(_chrome);
            
            // TODOE:
            _view.init({ is_loose_pack: _is_loose_pack, depth: _depth });

            init_virtual_folders();

            init_engine();
            
            init_keyboard_controls();
//            open_file_browser();
            
            if (options.use_webcam) {
                init_webcam();
            }
            
// TODO: Remove!  For testing only.
//            synch_virtual_folders();
//setTimeout(synch_virtual_folders, 400);
        }

        
        /* * * * * * * * * * * * * * * * * * *
        * Initialization
        * * * * * * * * * * * * * * * * * * */

        protected function init_engine () : void
        {
            _engine = new VirtualLibraryEngine({ width: _container.stage.stageWidth, height: _container.stage.stageHeight - VirtualLibraryController.CHROME_HEIGHT });
//            _engine = new VirtualLibraryEngineTest({ width: _container.stage.stageWidth, height: _container.stage.stageHeight - VirtualLibraryController.CHROME_HEIGHT });
            
            _engine.addEventListener(VirtualFolderEvent.OPEN_FOLDER, virtual_folder_OPEN);
//            _engine.addEventListener(VirtualFolderEvent.CREATE_FOLDER, virtual_folder_CREATE);
            _engine.addEventListener(VirtualFolderEvent.DELETE_FOLDER, virtual_folder_DELETE);
//            _engine.addEventListener(VirtualFolderEvent.ADD_FILE, virtual_folder_file_ADD);
//            _engine.addEventListener(VirtualFolderEvent.REMOVE_FILE, virtual_folder_file_REMOVE);

            _container.addChildAt(_engine, 0);
        }

        protected function init_menu () : void
        {
            _menu = new Menu();
            _menu.init({ width: MENU_WIDTH, height: MENU_HEIGHT, bgColor: MENU_BG_COLOR, bgAlpha: MENU_BG_ALPHA, folders: _virtual_folders });
            // folders: array_of_virtual_folders
            _menu.x = 0.5 * (_container.stage.stageWidth - MENU_WIDTH);
            _menu.y = 0.5 * (_container.stage.stageHeight - MENU_HEIGHT);

            _menu.addEventListener(VirtualFolderEvent.OPEN_FOLDER, virtual_folder_OPEN);
            _menu.addEventListener(VirtualFolderEvent.CREATE_FOLDER, virtual_folder_CREATE);
            _menu.addEventListener(VirtualFolderEvent.DELETE_FOLDER, virtual_folder_DELETE);
            _menu.addEventListener(VirtualFolderEvent.ADD_FILE, virtual_folder_file_ADD);
            _menu.addEventListener(VirtualFolderEvent.REMOVE_FILE, virtual_folder_file_REMOVE);

            _container.addChild(_menu);
        }

        protected function init_virtual_folders () : void
        {
            _virtual_folders = VirtualFolderMapper.init();
        }

        
        /* * * * * * *
        * Webcam
        * * * * * * */

        protected function init_webcam () : void
        {
            _webcam = new WebCamera();
            _webcam.init({ activity_level: _config.webcam_activity_level, activity_time: _config.webcam_activity_time, 
                           show_video: _config.webcam_show_video, show_activity : _config.webcam_show_activity });
            _webcam.addEventListener(ActivityEvent.ACTIVITY, webcam_ACTIVITY);

            if (_config.webcam_show_video)
            {
                add_webcam_video();
            }
        }
        
        // Should instead be idempotent
        protected function add_webcam_video () : void
        {
            var video:Video = _webcam.video;
            if (video)
            {
                _container.addChild(video);
                _container.addChild(_webcam);
            }
        }
        
        protected function toggle_webcam () :void
        {
            if (!_webcam) {
                init_webcam();
            }
            else {
                _webcam.visible ? _webcam.disable() : _webcam.enable();
            }
        }

        protected function webcam_ACTIVITY (event:ActivityEvent) : void
        {
            trace('[VirtualLibraryController] Webcam Activity Event:', WebCamera(event.target).activity_level);
        }
        
        protected function init_keyboard_controls () : void
        {
            _container.stage.addEventListener(KeyboardEvent.KEY_DOWN, key_DOWN);
        }
        
        // TODO: Add list of keyboard controls to menu 'show keyboard controls' textfield.  Nice and simple.
        protected function key_DOWN (event:KeyboardEvent) : void
        {
            switch (event.keyCode)
            {
                case Keyboard.X:
                    _engine.toggle_mouse_look();
                    break;
                case Keyboard.Z:
                    toggle_webcam();
                    break;
                default:
                    break;
            }
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
        protected function add_directories_to_view (file_directory:FileDirectory, depth:int) : void //, options:Object) : void
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
        
        protected function add_directory_to_view (file_directory:FileDirectory, depth:uint) : void
        {
            _view.add_directory(file_directory, depth);
            _engine.add_directory(file_directory); //, depth);
        }

        
        /* * * * * * * * * * * * * * * * *
        * Live search
        * * * * * * * * * * * * * * * * */
        
        protected function search_text_CHANGE (event:Event) : void
        {
            // Note that the event is dispatched BEFORE the TextField contents change, hence
            // the need to append the new text.            
            var query:String = event.target.text;
            trace('[Virtual Library Controller] Search text change event caught:', query);
            filename_search(query);
        }

        public function filename_search (query:String) : void
        {
            trace('\nPerforming file search for query:', query);
            if (_directory_trees.length == 0 && _virtual_folders.length == 0) {
                return;
            }

            _view.live_search(query);
            _engine.live_search(query);
            /*
            NOTE:
            The View should probably also have a Vector of file directories.  What you are trying to preclude is too much encapsulation
            because it will hurt performance - in the current decomposition, you will crawl the FileDirectory for search
            hits and pass them to the view, one by one, but then the View will have to crawl its directory of files as well
            (note that the View currently does not store that state), meaning order O(N ^ 2).
            Probably okay for now - can optimize/complexify later.
            */
        }
        

        /* * * * * * * * * * * * * * * * *
         * File Browser Event Handlers
         * * * * * * * * * * * * * * * * */

        /*
            TODONE: (TODO Native Extensions)
            On Android devices, browseForDirectory() is not supported. The File object dispatches a cancel event immediately.
            On iOS devices, file and browse dialogs are not supported. This method cannot be used.
                Solution: Use native extensions.  On iOS could parse a text field for the path.  On Android, could use open() and filter for folders.
        */
        protected function file_browser_OPEN (e:Event) : void
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
        
        protected function file_browser_SELECT (event:Event) : void
        {
            _directory_trees.push(FileSystemMapper.get_directory_tree(File(event.target), _depth, { show_hidden: _show_hidden }));
            add_directories_to_view(_directory_trees[_directory_trees.length - 1], 0);
            _view.render();
            _engine.render();
        }
        protected function file_browser_CANCEL (event:Event) : void
        {
            trace('\nFile browser Cancel!  File browser possibly closed by user:', event.toString());
        }
        protected function file_browser_IO_ERROR (event:Event) : void
        {
            trace('\nFile browser IO Error!  File Browser may be unsupported on this platform:', event.toString());
        }


        /* * * * * * * * * * * * * * * * *
        * Menu event handling
        * * * * * * * * * * * * * * * * */
        
        protected function toggle_menu_CLICK (event:Event) : void
        {
            if (!_menu) {
                init_menu();
            }
            else {
                _menu.visible = !_menu.visible;
            }
        }

        protected function virtual_folder_CREATE_AND_ADD (event:VirtualFolderEvent) : void
        {
            // TODO: Ammend this - virtual folder names are assumed unique!
            var virtual_folder_name:String = 'Virtual Folder ' + String(Math.random()).substr(2, 3);
            VirtualFolderMapper.create_folder(virtual_folder_name);
            
            VirtualFolderMapper.add_files_to_folder(virtual_folder_name, _engine.selected_files);
            
            synch_virtual_folders();
        }

        /* * * * * * * * * * * * * * * * * * * * * * *
        * Menu - virtual folder CRUD event handling
        * * * * * * * * * * * * * * * * * * * * * * */

        protected function virtual_folders_VIEW (event:Event) : void
        {
            trace('view virtual folder event caught in controller!!');
            
            synch_virtual_folders();
            
            // xxx
            /*
                add_directories_to_view(_directory_trees[_directory_trees.length - 1], 0);
            */
        }
        protected function virtual_folder_OPEN (event:VirtualFolderEvent) : void
        {
            trace('[Controller] Virtual folder open event caught!', event.type);
            
            var virtual_folder:VirtualFolder = VirtualFolderMapper.get_folder(event.target_folder);
            for (var i:uint = 0; i < virtual_folder.contents.length; i++)
            {
                open_file(virtual_folder.contents[i]);
            }
        }
        // Basically just wraps File.openWithDefaultApplication so can continue on error nicely.
        protected function open_file (file:File) : Boolean
        {
            try {
                file.openWithDefaultApplication();
            } catch (e:Error) {
                _menu.show_error('Error opening file: ' + file.name + ' - ' + e.toString());
                return false;
            }
            
            return true;
        }
        
        protected function virtual_folder_CREATE (event:VirtualFolderEvent) : void
        {
            trace('[Controller] Virtual folder create event caught!', event.type);
            
            VirtualFolderMapper.create_folder(event.target_folder);
            
            synch_virtual_folders();
        }
        protected function virtual_folder_DELETE (event:VirtualFolderEvent) : void
        {
            trace('[Controller] Virtual folder delete event caught!', event.type);
            
            VirtualFolderMapper.delete_folder(event.target_folder);
            
            synch_virtual_folders();
        }
        protected function virtual_folder_file_ADD (event:VirtualFolderEvent) : void
        {
            trace('[Controller] Virtual folder file add event caught!', event.type);
            
            VirtualFolderMapper.add_files_to_folder(event.target_folder, event.target_files);
            
            synch_virtual_folders();
        }
        protected function virtual_folder_file_REMOVE (event:VirtualFolderEvent) : void
        {
            trace('[Controller] Virtual folder file remove event caught!', event.type);
            
            VirtualFolderMapper.remove_files_from_folder(event.target_folder, event.target_files);
            
            synch_virtual_folders();
        }
        
        protected function synch_virtual_folders () : void
        {
            _engine.virtual_folders = _virtual_folders = VirtualFolderMapper.folders;
            if (_menu) _menu.virtual_folders = _virtual_folders;
            
            _engine.render();
        }

        
        /* * * * * * * * * * * * * * * * *
        * Other event handling
        * * * * * * * * * * * * * * * * */
        
        protected function library_CLEAR (event:Event) : void
        {
            _view.clear();
            _engine.clear();
        }
        
        
        /* * * * * * * * * * * * * * * * *
        * Deprecated
        * * * * * * * * * * * * * * * * */
        
//        protected function add_directory_children_to_view(file_directory:FileDirectory, depth:uint) : void
//        {
//            for (var i:uint = 0; i < file_directory.files.length; i++)
//            {
//                _view.add_book(file_directory.files[i].directory, depth);
//            }
//        }
        
    }
}