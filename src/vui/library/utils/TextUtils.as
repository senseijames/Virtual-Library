package vui.library.utils
{
    import flash.text.TextField;
    import flash.text.TextFieldType;
    
    public class TextUtils
    {
        public function TextUtils(chastity_belt:SingletonEnforcer)
        {
        }
        
        public static function get_input_text_field():TextField
        {
            var text_field:TextField = get_text_field();
            with (text_field)
            {
                multiline = false;
                border = true;
                selectable = true;
                maxChars = 100;
                type = TextFieldType.INPUT
            }
            
            return text_field;
        }
        
        public static function get_text_field():TextField
        {
            var text_field:TextField = new TextField();
            text_field.wordWrap = true;
//            text_field.multiline = true;
            return text_field;
        }
    }
}

class SingletonEnforcer { }