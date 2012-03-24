package vui.engine
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
    
    import vui.utils.GraphicsUtils;
    
//    [SWF(backgroundColor = "0x909090", width = "800", height = "600")]
    public class AlternativaEngine extends Sprite
    {
        // Core members.
        private var stage3D:Stage3D;
        private var camera:Camera3D;
        private var root_container:Object3D;
        private var controller:SimpleObjectController;
        // Test objects.
        private var box:Box;
        private var sphere:GeoSphere;
        private var plane:Plane;
        // Test lights.
        private var directional_light:DirectionalLight;
        private var ambient_light:AmbientLight;
        
        protected var _rectangle:Rectangle;
        
        /*
            TODO: This class needs a heavy refactor; do as you learn more about the engine.
        */
        public function AlternativaEngine(options:Object) 
        {
            // ...

            _rectangle = new Rectangle(0, 0, options.width, options.height);
            
            (stage) ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        protected function init(event:Event = null):void
        {
            if (event) {
                removeEventListener(event.type, init);
            }
         
            init_engine();
            test();
            
            init_lights();
            test_lights();
        }
        
        protected function init_lights():void
        {
            directional_light = new DirectionalLight(0xFF0000);
            directional_light.intensity = 10;
            directional_light.y = -500;
            directional_light.z = 500;
            directional_light.lookAt(0, 0, 0);
            root_container.addChild(directional_light);
            
            ambient_light = new AmbientLight(0x00FF00);
            //            ambient_light.intensity = 1000;
            //            root_container.addChild(ambient_light);
        }
        protected function test_lights():void
        {
            
        }
        
        protected function init_engine():void
        {
            init_camera();
            init_controller();
            init_stage_3d();
        }
        
        /*
        NOTE: Content added to the Flash display list, even if added before content added through
        the 3d engine, will appear ABOVE the 3d engine content; likely any content written to
        screen through the 3d engine is bottom-most so as to be written to the GPU directly.
        */
        protected function test():void
        {
            add_test_rect(50, 50, 100, 100, 0xFF0000);
            add_test_rect(200, 200, 200, 200, 0x0000FF, 0.2);
            
            add_test_box();
            add_test_sphere();
            add_test_plane();
            
            sphere.x = 50;
            
            confirm_player_11_install();
        }
        
        protected function init_camera():void
        {
            camera = new Camera3D(0.01, 10000000000);
            camera.x = -50;
            camera.y = -300;
            camera.z = 100;
            // Add a view to the camera.
            camera.view = new View(_rectangle.width, _rectangle.height, false, 0x404040, 0, 4);
            addChild(camera.view);
            // Add the camera to the root container.
            root_container = new Object3D();
            root_container.addChild(camera);
        }
        
        protected function init_controller():void
        {
            // NOTE: The controller controls the speed & sensitivity of navigation!
            controller = new SimpleObjectController(stage, camera, 200);
            controller.lookAtXYZ(0,0,0);
        }
        
        protected function init_stage_3d():void
        {
            stage3D = stage.stage3Ds[0];
            stage3D.addEventListener(Event.CONTEXT3D_CREATE, init_resource_upload);
            stage3D.requestContext3D();
        }
        
        protected function init_resource_upload(event:Event):void 
        {
            for each (var resource:Resource in root_container.getResources(true)) {
                resource.upload(stage3D.context3D);
            }
            addEventListener(Event.ENTER_FRAME, on_ENTER_FRAME)
        }
        
        protected function on_ENTER_FRAME(event:Event):void 
        {
            rotate(box, 0.02, 0.02, 0.02);
            rotate(sphere, 0.03, 0.03, 0.03);
            
            controller.update();
            camera.render(stage3D);
        }
        
        
        /** * * * * * * * * * * * * * * *
         * Debugging and testing... - move to test class - AlternativaEngineTest, that extends this
         * * * * * * * * * * * * * * * */
        
        private function add_test_box():void
        {
            box = new Box();
            var box_color:Number = 0x804080;
            box.setMaterialToAllSurfaces(new FillMaterial(box_color, 0.9));
            
            root_container.addChild(box);
        }
        
        private function add_test_sphere():void
        {
            sphere = new GeoSphere(50, 2);
            var sphere_color:Number = 0xFF0000;
            sphere.setMaterialToAllSurfaces(new FillMaterial(sphere_color, 0.9));
            
            root_container.addChild(sphere);
        }
        
        private function add_test_plane():void
        {
            plane = new Plane(600, 600, 5, 5, true, false, new FillMaterial(0x0000FF), new FillMaterial(0x00FFFF));
            
            root_container.addChild(plane);
        }
        
        private function rotate(object:Object3D, x:Number, y:Number, z:Number):void
        {
            object.rotationX += x;
            object.rotationY += y;
            object.rotationZ += z;
        }
        
        private function confirm_player_11_install():Boolean
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
        
        private function add_test_rect(x:Number, y:Number, width:Number, height:Number, color:Number, alpha:Number = 1):void
        {
            var test_rect:Sprite = GraphicsUtils.get_shape_rect(width, height, color, alpha);
            addChild(test_rect);
        }
    }
}