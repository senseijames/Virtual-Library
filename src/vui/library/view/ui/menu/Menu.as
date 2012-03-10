package vui.library.view.ui.menu
{
    import flash.display.Shape;
    import flash.display.Sprite;
    
    import test.TestShape;
    
    public class Menu extends Sprite
    {
        protected var _bg:Shape;
        
        public function Menu()
        {
            _bg = new Shape();
        }
        
        /**
        *   @param options.bgColor
        *   @param options.bgAlpha  
        */
        public function init(options:Object)
        {
            // Add the bg.
            _bg.graphics.clear();
            _bg.graphics.beginFill(options.bgColor, options.bgAlpha);
            _bg.graphics.drawRect(0, 0, options.width, options.height);
            _bg.graphics.endFill();
            
            addChild(_bg);
            
            // Add the 'create virtual folder' button.
// test utils - get shape            
            _createVirtualFolderButton = new test.TestShape(0xFF0000, 0, 0, 50, 50); 
            
            
            // Add a virtual folder viewer.
            // ? - 'view virtual folders' ?
        }
        
    }
}