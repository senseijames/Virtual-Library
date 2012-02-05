package controller
{
    import flash.display.DisplayObjectContainer;
    
    import mapper.FileSystemMapper;
    
    import view.console.ConsoleOutput;
    
    /**
     * I don't think it should subclass Sprite; a controller should have no visual representation.
     */ 
    public class VirtualLibraryController
    {
        protected var _container:DisplayObjectContainer;
        protected var _view:ConsoleOutput;
        
        // Convoluted to have a constructor, init and run that could all be just in the constructor?  Or good decomposition?  Time will tell?
        public function VirtualLibraryController()
        {
        }
        
        public function init(container:DisplayObjectContainer, options:Object):void
        {
            _container = container;
            _view = new ConsoleOutput();
        }
        
        public function run():void
        {
            var files:Array = FileSystemMapper.get_directory("");
            _view.add_bookcase(files);
            _view.render();
        }
    }
}