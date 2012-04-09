package vui.utils
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.BevelFilter;
    import flash.geom.Rectangle;
    import flash.text.TextField;

    
    /** * * * * * * * * *
     * Button utils
     * * * * * * * * * */
    public class ButtonUtils
    {
        public static const BUTTON_MOUSE_OVER_ALPHA : Number = 0.8;
        public static const BUTTON_MOUSE_OUT_ALPHA : Number = 0.7;
        public static const BUTTON_MOUSE_DOWN_ALPHA : Number = 1;

        
        public function ButtonUtils (chastity_belt:SingletonEnforcer)
        {
//            throw new Error('[GraphicsUtils] I am a singleton class, saving myself for marriage!');
        }
        
        /**
        * 
        * @param options    color:uint = Math.random() * 0xffffff, init:Boolean = true, text_color:uint = 0x000000, autosize:Boolean = false
        */
        public static function get_button (rect:Rectangle, text:String, options:Object = null, on_click_callback:Function = null) : Sprite
        {
            options ||= {};
            ConfigUtils.set_defaults(options, { color: Math.random() * 0xFFFFFF, init: true, text_color: 0x000000, autosize: true });
            
            var text_field:TextField = TextUtils.get_text_field({ multiline: false, word_wrap: false });
            text_field.text = text;
            text_field.textColor = options.text_color;
            text_field.width = text_field.textWidth + 10;

            if (options.autosize) {
                rect.width = text_field.textWidth + 20;
                rect.height = text_field.textHeight + 20;
            }
            // TODO: maybe add SimpleButton to this, else write another utility that just wraps the donuts.
            var button:Sprite = ButtonUtils.get_simple_button(rect, !isNaN(options.color) ? options.color : Math.random() * 0xFFFFFF);
            
            text_field.x = 0.5 * (button.width - text_field.textWidth);
            text_field.y = 0.5 * (button.height - text_field.textHeight);
            text_field.mouseEnabled = false;
            button.addChild(text_field);

            if (options.init) {
                // [ new BevelFilter() ]; //2, 45, 0xFFFFFF, 0.5, 0x000000, 0.5)];
                ButtonUtils.init_button(button, [ new BevelFilter()], on_click_callback);
            }
            
            return button;
        }
        
        // TODO: May want to extend this with more callback options; or just make use of the SimpleButton class
        // rather than "monkey patching", as they say.  This does work, however, for this simplified use case.
        public static function init_button (button:Sprite, filters:Array, on_click_callback:Function = null) : void
        {
            button.filters = filters;
            button.buttonMode = true;
            button.alpha = BUTTON_MOUSE_OUT_ALPHA;
            
            button.addEventListener(MouseEvent.ROLL_OVER, function(e:MouseEvent):void { button.alpha = BUTTON_MOUSE_OVER_ALPHA; });
            button.addEventListener(MouseEvent.ROLL_OUT, function(e:MouseEvent):void { button.alpha = BUTTON_MOUSE_OUT_ALPHA; });
            button.addEventListener(MouseEvent.MOUSE_DOWN, function(e:MouseEvent):void { button.alpha = BUTTON_MOUSE_DOWN_ALPHA; });
            button.addEventListener(MouseEvent.MOUSE_UP, function(e:MouseEvent):void { button.alpha = BUTTON_MOUSE_OVER_ALPHA; });
            
            if (on_click_callback != null) {
                button.addEventListener(MouseEvent.CLICK, on_click_callback);
            }

        }
        
        public static function get_simple_button (rect:Rectangle, color:uint) : Sprite
        {
            var button:Sprite = GraphicsUtils.get_sprite_rect(rect.width, rect.height, color, 1);
            button.x = rect.x;
            button.y = rect.y;
            return button;
        }


    }
}

class SingletonEnforcer { }