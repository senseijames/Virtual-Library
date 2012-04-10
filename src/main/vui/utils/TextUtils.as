package vui.utils
{
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFieldType;
    
    public class TextUtils
    {
        public function TextUtils(chastity_belt:SingletonEnforcer)
        {
//            throw new Error('[TextUtils] I am a singleton class, saving myself for marriage!');
        }
        
        // TODO: add options parameter with "maxChars" defined.
        // TODO: write options utility that overwrites with default values
        public static function get_input_text_field(options:Object = null) : TextField
        {
            options ||= { };
            var text_field:TextField = get_text_field(options);
            
            with (text_field)
            {
                multiline = options.multiline; // || false;
                border = true;
                selectable = true;
                maxChars = options.max_chars || 100;
                type = TextFieldType.INPUT
            }
            
            return text_field;
        }
        
        // TODO: ConfigUtils support here.
        public static function get_text_field(options:Object = null) : TextField
        {
            options ||= { }
            var text_field:TextField = new TextField();

//            text_field.background = options.background || false;
            text_field.selectable = options.selectable || true;
            text_field.autoSize = options.auto_size || TextFieldAutoSize.LEFT;
            text_field.wordWrap = options.word_wrap || true;
            text_field.multiline = options.multiline || true;
            if (options.text_format) {
                text_field.defaultTextFormat = options.text_format;
                // One line execution?  Door # 3? 
                // text_field.defaultTextFormat && options.text_format = options.text_format;
                // text_field.defaultTextFormat && options.text_format && text_field.defaultTextFormat = options.text_format;
                // options.text_format && text_field.defaultTextFormat = options.text_format;
            }
            
            return text_field;
        }
    }
}

class SingletonEnforcer { }