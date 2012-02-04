package controller
{
    import flash.display.DisplayObjectContainer;

    /**
     * I don't think it should subclass Sprite; a controller should have no visual representation.
     */ 
    public class VirtualLibraryController
    {
        public function VirtualLibraryController(container:DisplayObjectContainer)
        {
        }
        
        public function init(container:DisplayObjectContainer, options:Object):void
        {
            
        }
    }
}