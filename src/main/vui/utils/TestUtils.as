package vui.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	

	public class TestUtils
	{
		public function TestUtils ()
		{
		}
		
		public static function run_shape_test (test_iterations:uint, container:DisplayObjectContainer) : void
		{
			for (var i:uint = 0; i < test_iterations; i++) {
				var shape:Shape = GraphicsUtils.get_shape_rect(50 + Math.random() * 250, 50 + Math.random() * 250, Math.random() * 0xffffff, 0.2 + Math.random() * 0.8);
				shape.x = Math.random() * 500;
				shape.y = Math.random() * 500;
				container.addChild(shape);			
			}			
		}
	}
}