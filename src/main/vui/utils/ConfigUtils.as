package vui.utils
{
    public class ConfigUtils
    {
        public function ConfigUtils (chastity_belt:SingletonEnforcer)
        {
        }
        
        public static function set_defaults (config:Object, defaults:Object) : void
        {
            var defaults_key:Object;
            for (defaults_key in defaults) {
                if (config[defaults_key] === undefined) {
                    config[defaults_key] = defaults[defaults_key];
                }
            } 
        }
    }
}

class SingletonEnforcer { }