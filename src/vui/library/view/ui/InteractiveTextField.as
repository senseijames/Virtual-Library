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
        public var content:Object;
        
        public function InteractiveTextField()
        {
            _text_field = new TextField();
            addChild(_text_field);
        }
        
        public function set text(text:String):void
        {
            _text_field.text = text;
            set_overlay();
        }
        
        public function get textHeight():Number
        {
            return _text_field.textHeight;
        }
        
        public function get textWidth():Number
        {
            return _text_field.textWidth;
        }
        
        public function set_overlay():void
        {
            _overlay = GraphicsUtils.get_button(0, 0, textWidth, textHeight, 0xFFFFFF, 0);
            _overlay.buttonMode = true;
            addChild(_overlay);
        }
        
        public function get text_field():TextField
        {
            return _text_field;
        }
        
//        override public function addEventListener(event_type:String, callback:Function, use_capture:Boolean = false):void
//        {
//            _overlay.addEventListener(event_type, callback, use_capture);
//        }
    }
}