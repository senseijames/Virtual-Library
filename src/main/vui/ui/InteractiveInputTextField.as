package vui.ui
{
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    
    import vui.utils.TextUtils;

    public class InteractiveInputTextField extends InteractiveTextField
    {
        protected var _is_keyboard_commandeered : Boolean;
        
        public function InteractiveInputTextField (options:Object = null)
        {
            _text_field = TextUtils.get_input_text_field(options);
            commandeer_keyboard = true;
            
            addChild(_text_field);
        }
        
        public function set commandeer_keyboard (is_commandeered:Boolean) : void
        {
            _is_keyboard_commandeered = is_commandeered;
            
            if (_is_keyboard_commandeered) {
                addEventListener(KeyboardEvent.KEY_DOWN, steal_keyboard_input, true, 1000); //int.MAX_VALUE);
                addEventListener(KeyboardEvent.KEY_UP, steal_keyboard_input, true, 1000); //int.MAX_VALUE);
            }
            else {
                removeEventListener(KeyboardEvent.KEY_DOWN, steal_keyboard_input, true);
                removeEventListener(KeyboardEvent.KEY_UP, steal_keyboard_input, true);
            }
        }
        
        // TODO: Test this here - not sure if it will work.
        protected function steal_keyboard_input (event:KeyboardEvent) : void
        {
            event.stopImmediatePropagation();
        }
        
        override public function set_overlay () : void
        {
            super.set_overlay();
            
            _overlay.addEventListener(MouseEvent.CLICK, function(e:Event):void { trace('clicked!!!'); stage.focus = _text_field; _text_field.setSelection(0, _text_field.length); });
        }
        
        override public function get textHeight () : Number
        {
            return _text_field.height;
        }
        
        override public function get textWidth () : Number
        {
            return _text_field.width;
        }

    }
}