package test
{
    import flash.display.Sprite;
    
    public class TestShape extends Sprite
    {
        public function TestShape(color:uint, x:int, y:int, width:uint, height:uint, alpha:Number = 0.5)
        {
            super();
            
            with (graphics) {
                beginFill(color, alpha); drawRect(x, y, width, height); endFill();
            }
        }
    }
}