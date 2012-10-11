package vui.utils
{
    import flash.display.Shape;
    import flash.display.Sprite;
    
    public class GraphicsUtils
    {
        /** * * * * * * * * *
        * Vector graphics
        * * * * * * * * * */
        public function GraphicsUtils() //chastity_belt:SingletonEnforcer)
        {
//            throw new Error('[GraphicsUtils] I am a singleton class, saving myself for marriage!');
        }
                
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

//class SingletonEnforcer { }