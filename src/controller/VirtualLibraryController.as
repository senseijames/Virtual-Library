package controller
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;
    
    import mapper.FileSystemMapper;
    
    import view.console.ConsoleOutput;
    import view.ui.Chrome;
    
    /**
     * I don't think it should subclass Sprite; a controller should have no visual representation.
     */ 
    public class VirtualLibraryController
    {
        public static var CHROME_HEIGHT:uint = 30;
        
        protected var _container:DisplayObjectContainer;
        protected var _view:ConsoleOutput;
        protected var _chrome:Chrome;
        
        
        // Convoluted to have a constructor, init and run that could all be just in the constructor?  Or good decomposition?  Time will tell?
        public function VirtualLibraryController()
        {
            _view = new ConsoleOutput();
            _chrome = new Chrome();
        }
        
        /**
         *  @param options  depth:uint - depth for recursive directory search
         */ 
        public function init(container:DisplayObjectContainer, options:Object):void
        {
            _container = container;
            
            _chrome.init({ height: CHROME_HEIGHT, width: container.stage.stageWidth, color: 0x00FF00, alpha: 0.5 });
            _chrome.addEventListener(Chrome.OPEN_FILE_BROWSER_EVENT, open_file_browser);
            
            // TODO: Move to layout method, so can separate add_content() from layout_content() so that window resize events are handled gracefully.
            _chrome.y = container.stage.stageHeight - _chrome.height;
//            _chrome.x = -20;
            container.addChild(_chrome);
            
//            open_file_browser();
        }
        
        // TODO: Move to UI class (view.ui.UserInterface)
        /*
            On Android devices, browseForDirectory() is not supported. The File object dispatches a cancel event immediately.
            On iOS devices, file and browse dialogs are not supported. This method cannot be used.
                Solution: Use native extensions.  On iOS could parse a text field for the path.  On Android, could use open() and filter for folders.
        */
        protected var _file_browser:File;
        protected function open_file_browser(e:Event):void
        {
            if (!_file_browser) {
                _file_browser = new File();
            }
            else {
                _file_browser.cancel();  
            }
//            
            _file_browser.addEventListener(Event.SELECT, file_browser_SELECT);
            _file_browser.addEventListener(Event.CANCEL, file_browser_CANCEL);
            _file_browser.addEventListener(IOErrorEvent.IO_ERROR, file_browser_IO_ERROR);
            
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
        
        // Toggle (default false) allows user to add files to current library on browse, rather than
        // clearing out the current one; future implementation.
//        protected var _add_to_current_view:Boolean;
        protected function file_browser_SELECT(event:Event):void
        {
            trace('\nFile browser select event caught!!');
            var file:File = File(event.target);
            // TODO: Ammend duplication in run.  Best I/F for this?
            var directories:Array = FileSystemMapper.map_directory(file);
            _view.add_bookcase(directories);
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
        
        // TODO: Make better use of this (prune from file_browser_SELECT)
        public function run(file:File):void
        {
            var directories:Array = FileSystemMapper.map_directory(file);
            _view.add_bookcase(directories);
            _view.render();
        }
    }
}