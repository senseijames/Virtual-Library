package vui.library.utils
{
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;

    public class DisplayListUtils
    {
        public function DisplayListUtils(chastity_belt:SingletonEnforcer)
        {
        }
        
        public static function clear_children(target:DisplayObjectContainer, clazz:Class = null):void
        {
            var current_child:DisplayObject;
            for (var i:int = target.numChildren - 1; i >= 0; i--)
            {
                current_child = target.getChildAt(i);
                
                if (!clazz ||   current_child is clazz) {
                    target.removeChild(current_child);
                }
            }
        }
    }
}


class SingletonEnforcer { }