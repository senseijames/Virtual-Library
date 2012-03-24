package vui.utils
{
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    public class GraphicsUtils
    {
        public function GraphicsUtils(chastity_belt:SingletonEnforcer)
        {
//            throw new Error('[GraphicsUtils] I am a singleton class, saving myself for marriage!');
        }
        
        /* * * * * * * * * *
        * Button utils
        * * * * * * * * * */
        public static function get_button(x:uint, y:uint, width:uint, height:uint, color:uint, alpha:Number, on_click_callback:Function = null) : Sprite
        {
            var button:Sprite = GraphicsUtils.get_sprite_rect(width, height, color, alpha);
            button.x = x;
            button.y = y;
            
            GraphicsUtils.init_button(button, on_click_callback);
            
            return button;
        }
        
        // TODO: May want to extend this with more callback options; or just make use of the SimpleButton class
        // rather than "monkey patching", as they say.  This does work, however, for this simplified use case.
        public static function init_button(button:Sprite, on_click_callback:Function = null) : void
        {
            button.buttonMode = true;
            
            if (on_click_callback != null) {
                button.addEventListener(MouseEvent.CLICK, on_click_callback);
            }
        }

//        public static function init_button(button:Sprite, onClick:
        
        /* * * * * * * * * *
        * Vector graphics
        * * * * * * * * * */
        
        // getSpriteRect
        public static function get_sprite_rect(width:uint, height:uint, color:uint, alpha:Number = 1) : Sprite
        {
            var sprite:Sprite = new Sprite();
            draw_rect(sprite, width, height, color, alpha);
            return sprite;
        }
        
        public static function get_shape_rect(width:uint, height:uint, color:uint, alpha:Number = 1) : Shape
        {
            var shape:Shape = new Shape();
            draw_rect(shape, width, height, color, alpha);
            return shape;
        }
        
        protected static function draw_rect(shape_or_sprite:Object, width:uint, height:uint, color:uint, alpha:Number) : void
        {
            if (!shape_or_sprite.hasOwnProperty('graphics')) {
                return;
            }
            
            shape_or_sprite.graphics.beginFill(color, alpha);
            shape_or_sprite.graphics.drawRect(0, 0, width, height);
            shape_or_sprite.graphics.endFill();
        }
    }
}

class SingletonEnforcer { }