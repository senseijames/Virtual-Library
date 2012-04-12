package vui.utils
{
    public class MathUtils
    {
        public static const POWERS_OF_TWO : Vector.<uint> = new <uint>[2, 4, 8, 16, 32, 64, 128, 256];

        public function MathUtils (chastity_belt:SingletonEnforcer)
        {
        }
        
        public static function get_power_of_two (value:uint, is_max_value:Boolean = true) : uint
        {
            for (var i:uint = 1; i < POWERS_OF_TWO.length; i++) {
                if (POWERS_OF_TWO[i] > value) {
                    return POWERS_OF_TWO[is_max_value ? i - 1 : i];
                }
            }
            
            return POWERS_OF_TWO[POWERS_OF_TWO.length - 1];
        }

        public static function is_power_of_two (value:uint) : Boolean
        {
            for (var i:uint = 1; i < POWERS_OF_TWO.length; i++) {
                if (POWERS_OF_TWO[i] == value) {
                    return true;   
                }
            }

            return false;
        }
    }
}

class SingletonEnforcer { }