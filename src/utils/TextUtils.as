package utils
{
    import flash.text.TextField;

    public class TextUtils
    {
        public function TextUtils(chastity_belt:SingletonEnforcer)
        {
        }
        
        public static function getTextField():TextField
        {
            var text_field:TextField = new TextField();
            return text_field;
        }
    }
}

class SingletonEnforcer { }