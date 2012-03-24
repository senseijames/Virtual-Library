package test
{    
    import alternativa.engine3d.controllers.SimpleObjectController;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Resource;
    import alternativa.engine3d.core.View;
    import alternativa.engine3d.lights.AmbientLight;
    import alternativa.engine3d.lights.DirectionalLight;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.primitives.Box;
    import alternativa.engine3d.primitives.GeoSphere;
    import alternativa.engine3d.primitives.Plane;
    
    import flash.display.Sprite;
    import flash.display.Stage3D;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    
    import test.Stage3DTest;
    
    import vui.engine.AlternativaEngine;
    import vui.utils.GraphicsUtils;
    
    // TODO: Left off here - make this extend AlternativaEngine, and remove test code from that class, placing it in here.  Then
    // move to the test folder.
    // Get webcam activity events caught well in controller
    // Get bash script working to build well, else give up and push on that for the time being (ask in StackOverflow?)
    
//    [SWF(backgroundColor = "0x909090", width = "800", height = "600")]
    public class AlternativaEngineTest extends AlternativaEngine
    {
        // Test objects.
        private var box:Box;
        private var sphere:GeoSphere;
        private var plane:Plane;
        

        public function AlternativaEngineTest(options:Object) 
        {
            super(options);
        }
        
        override protected function init(event:Event = null) : void
        {
            super.init(event);

            test();
            test_lights();
        }
        
        override protected function on_ENTER_FRAME(event:Event) : void 
        {
            rotate(box, 0.02, 0.02, 0.02);
            rotate(sphere, 0.03, 0.03, 0.03);
            
            super.on_ENTER_FRAME(event);
        }

        
        /** * * * * * * * * *
        * Main test code
        * * * * * * * * * * */
        protected function test() : void
        {
            add_test_rect(50, 50, 100, 100, 0xFF0000);
            add_test_rect(200, 200, 200, 200, 0x0000FF, 0.2);
            
            add_test_box();
            add_test_sphere();
            add_test_plane();
            
            sphere.x = 50;
            
            confirm_player_11_install();
        }
        
        protected function test_lights() : void
        {
            
        }
        
        
        private function add_test_box() : void
        {
            box = new Box();
            var box_color:Number = 0x804080;
            box.setMaterialToAllSurfaces(new FillMaterial(box_color, 0.9));
            
            root_container.addChild(box);
        }
        
        private function add_test_sphere() : void
        {
            sphere = new GeoSphere(50, 2);
            var sphere_color:Number = 0xFF0000;
            sphere.setMaterialToAllSurfaces(new FillMaterial(sphere_color, 0.9));
            
            root_container.addChild(sphere);
        }
        
        private function add_test_plane() : void
        {
            plane = new Plane(600, 600, 5, 5, true, false, new FillMaterial(0x0000FF), new FillMaterial(0x00FFFF));
            
            root_container.addChild(plane);
        }
        
        private function rotate(object:Object3D, x:Number, y:Number, z:Number) : void
        {
            object.rotationX += x;
            object.rotationY += y;
            object.rotationZ += z;
        }
        
        private function confirm_player_11_install() : Boolean
        {
            if (Stage3DTest.confirm_player_11_install) {
                var tf:TextField = new TextField();
                with (tf)
                {
                    text = 'what it does now now big pimpin? ' + Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
                    width = textWidth + 10;
                }
                addChild(tf);
            }
        }            
        
        private function add_test_rect(x:Number, y:Number, width:Number, height:Number, color:Number, alpha:Number = 1) : void
        {
            var test_rect:Sprite = GraphicsUtils.get_shape_rect(width, height, color, alpha);
            addChild(test_rect);
        }
    }
}