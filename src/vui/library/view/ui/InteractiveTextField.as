package vui.library.view.ui
{
    import flash.display.Sprite;
    import flash.text.TextField;
    
    import vui.library.utils.GraphicsUtils;

    /**
    * Functionally extends TextField by adding interactivity (buttonMode, essentially) by way of a Sprite overlay.
    */
    public class InteractiveTextField extends Sprite
    {
        protected var _overlay:Sprite;
        protected var _text_field:TextField;
        
        public function InteractiveTextField()
        {
            _text_field = new TextField();
            addChild(_text_field);
        }
        
        public function set_overlay():void
        {
            _overlay = GraphicsUtils.get_button(0, 0, textWidth, textHeight, 0xFFFFFF, 0);
            addChild(_overlay);
        }
        
        public function get textField():TextField
        {
            return _text_field;
        }
        
//        override public function addEventListener(event_type:String, callback:Function, use_capture:Boolean = false):void
//        {
//            _overlay.addEventListener(event_type, callback, use_capture);
//        }
    }
}