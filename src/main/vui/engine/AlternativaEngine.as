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

    
//    [SWF(backgroundColor = "0x909090", width = "800", height = "600")]
    public class AlternativaEngine extends Sprite
    {
        // Core members
        protected var _stage3D : Stage3D;
        protected var _camera : Camera3D;
        protected var _root_container : Object3D;
        protected var _controller : SimpleObjectController;
        // State
        protected var _rectangle : Rectangle;
        // Test lights
        private var _directional_light : DirectionalLight;
        private var _ambient_light : AmbientLight;

        /*
        NOTE: Content added to the Flash display list, even if added before content added through
        the 3d engine, will appear ABOVE the 3d engine content; likely any content written to
        screen through the 3d engine is bottom-most so as to be written to the GPU directly.
        */
        
        public function AlternativaEngine(options:Object) 
        {
            // ...

            _rectangle = new Rectangle(0, 0, options.width, options.height);
            
            (stage) ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        protected function init(event:Event = null) : void
        {
            if (event) {
                removeEventListener(event.type, init);
            }
         
            init_engine();
            init_lights();
        }
        
        protected function init_engine() : void
        {
            init_camera();
            init_controller();
            init_stage_3d();
        }

        protected function init_lights() : void
        {
            _directional_light = new DirectionalLight(0xFF0000);
            _directional_light.intensity = 10;
            _directional_light.y = -500;
            _directional_light.z = 500;
            _directional_light.lookAt(0, 0, 0);
            _root_container.addChild(_directional_light);
            
            _ambient_light = new AmbientLight(0x00FF00);
            //            ambient_light.intensity = 1000;
            //            root_container.addChild(ambient_light);
        }
        
        protected function init_camera() : void
        {
            _camera = new Camera3D(0.01, 10000000000);
            _camera.x = -50;
            _camera.y = -300;
            _camera.z = 100;
            // Add a view to the camera.
            _camera.view = new View(_rectangle.width, _rectangle.height, false, 0x404040, 0, 4);
            addChild(_camera.view);
            // Add the camera to the root container.
            _root_container = new Object3D();
            _root_container.addChild(_camera);
        }
        
        protected function init_controller() : void
        {
            // NOTE: The controller controls the speed & sensitivity of navigation!
            _controller = new SimpleObjectController(stage, _camera, 200);
            _controller.lookAtXYZ(0,0,0);
        }
        
        protected function init_stage_3d() : void
        {
            _stage3D = stage.stage3Ds[0];
            _stage3D.addEventListener(Event.CONTEXT3D_CREATE, init_resource_upload);
            _stage3D.requestContext3D();
        }
        
        protected function init_resource_upload(event:Event) : void 
        {
            for each (var resource:Resource in _root_container.getResources(true)) {
                resource.upload(_stage3D.context3D);
            }
            addEventListener(Event.ENTER_FRAME, on_ENTER_FRAME)
        }
        
        protected function on_ENTER_FRAME(event:Event) : void 
        {
//            rotate(box, 0.02, 0.02, 0.02);
//            rotate(sphere, 0.03, 0.03, 0.03);
            
            _controller.update();
            _camera.render(_stage3D);
        }
        
    }
}