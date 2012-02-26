package controller
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;
    
    import mapper.FileSystemMapper;
    
    import model.FileDirectory;
    
    import view.console.ConsoleOutput;
    import view.ui.Chrome;
    
    /**
     * I don't think it should subclass Sprite; a controller should have no visual representation.
     */ 
    public class VirtualLibraryController
    {
        public static var CHROME_HEIGHT:uint = 30;
        
        // State.
        protected var _directory_tree:FileDirectory;
        // TODO: Replace this, either by pulling off of the Chrome input field directly (okay) or by sending with the event (better).
        protected var _depth:uint;
        protected var _show_hidden:Boolean;
        protected var _is_loose_pack:Boolean;
        // Delegates.
        protected var _file_browser:File;
        // UI Elements
        protected var _container:DisplayObjectContainer;
        protected var _view:ConsoleOutput;
        protected var _chrome:Chrome;
        
        // Convoluted to have a constructor, init and run that could all be just in the constructor?  Or good decomposition?  Time will tell?
        public function VirtualLibraryController()
        {
            _view = new ConsoleOutput();
            _chrome = new Chrome();
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
            _chrome.addEventListener(Chrome.OPEN_FILE_BROWSER_EVENT, open_file_browser);
            
            // TODO: Move to layout method, so can separate add_content() from layout_content() so that window resize events are handled gracefully.
            _chrome.y = container.stage.stageHeight - _chrome.height;
//            _chrome.x = -20;
            container.addChild(_chrome);
            
            _view.init({ is_loose_pack: _is_loose_pack });
//            open_file_browser();
        }

        
        /* * * * * * * * * * * * * * * * * * *
        * Helpers - file aggregators 
        *           (arrays -> bookshelves)
        * * * * * * * * * * * * * * * * * * */
        
        /**
         * @param   options.is_append:Boolean   whether the add() operation appends to the existing library or replaces it
         */ 
        protected function add_directories_to_view(file_directory:FileDirectory):void //, options:Object):void
        {
            _directory_tree = file_directory;
            add_directory_to_view(file_directory, 0);
        }
        
        protected function add_directory_to_view(file_directory:FileDirectory, depth:uint):void
        {
trace('adding', file_directory.directory.name);            
            _view.add_book(file_directory.directory, depth);
            
            if (!file_directory.files || depth >= _depth) {
                return;
            }
//            if (depth >= _depth) {
//                add_directory_children_to_view(file_directory, depth + 1);
//                return;
//            }
            
            for (var i:uint = 0; i < file_directory.files.length; i++)
            {
                add_directory_to_view(file_directory.files[i], depth + 1);
            }
        }

        // TODO: Currently unused.
        protected function add_directory_children_to_view(file_directory:FileDirectory, depth:uint):void
        {
            for (var i:uint = 0; i < file_directory.files.length; i++)
            {
                _view.add_book(file_directory.files[i].directory, depth);
            }
        }
        
        
        /* * * * * * * * * * * * * * * * *
         * File Browser Event Handlers
         * * * * * * * * * * * * * * * * */

        /*
            On Android devices, browseForDirectory() is not supported. The File object dispatches a cancel event immediately.
            On iOS devices, file and browse dialogs are not supported. This method cannot be used.
                Solution: Use native extensions.  On iOS could parse a text field for the path.  On Android, could use open() and filter for folders.
        */
        protected function open_file_browser(e:Event):void
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
            var file:File = File(event.target);
            // TODO: Ammend duplication in run.  Best I/F for this?
            var directory_tree:FileDirectory = FileSystemMapper.get_directory_tree(file, _depth, { show_hidden: _show_hidden });
            add_directories_to_view(directory_tree);
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

    }
    
}