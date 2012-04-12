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
    import flash.geom.Vector3D;

    
//    [SWF(backgroundColor = "0x909090", width = "800", height = "600")]
    public class AlternativaEngine extends Sprite
    {
        // Core members
        protected var _stage3D : Stage3D;
        protected var _camera : Camera3D;
        protected var _root_container : Object3D;   // Persistent content.
        protected var _camera_controller : SimpleObjectController;
        // Delegates
        protected var _content_container : Object3D; // Temporary content (can be 'cleared')
        protected var _content_container_buffer : Object3D; // Optimized upload of content to GPU
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
        
        /**
        * @param options    width : uint, height : uint
        */
        public function AlternativaEngine (options:Object) 
        {
            // ...

            _rectangle = new Rectangle(0, 0, options.width, options.height);
            
            (stage) ? init() : addEventListener(Event.ADDED_TO_STAGE, init);
        }
        
        /** * * * * * * * * * * *
         * Public I/F
         * * * * * * * * * * * */

        public function render () : void
        {
            upload_buffer_to_GPU();
        }

        public function set camera_position (point : Vector3D) : void
        {
            _camera.x = point.x;
            _camera.y = point.y;
            _camera.z = point.z;
        }
        
        public function set camera_sight (point : Vector3D) : void
        {
            _camera_controller.lookAt(point);
        }
        
        public function clear () : void
        {
            for (var i:int = _content_container.numChildren - 1; i >= 0; i--) {
                _content_container.removeChildAt(i);
            }
        }
        
        /** * * * * * * * * * *
        * Initialization
        * * * * * * * * * * * */
        
        protected function init (event:Event = null) : void
        {
            if (event) {
                removeEventListener(event.type, init);
            }
         
            init_engine();
            init_lights();
        }
        
        protected function init_engine () : void
        {
            init_camera();
            init_camera_controller();
            init_stage_3d();
        }

        protected function init_lights () : void
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
        
        protected function init_camera () : void
        {
            _camera = new Camera3D(0.01, 10000000000);
            // TODO: Make the initial camera position configurable.
            camera_position = new Vector3D(-50, -420, 100);
            // Add a view to the camera.
            _camera.view = new View(_rectangle.width, _rectangle.height, false, 0x404040, 0, 4);
            addChild(_camera.view);
            // Add the camera to the root container.
            _root_container = new Object3D;
            _root_container.addChild(_camera);
            // Add a content container to facilitate 'clearing' that content.
            _content_container = new Object3D;
            _root_container.addChild(_content_container);
            // Add a container buffer to optimize uploading new resources to the GPU.
            _content_container_buffer = new Object3D;
        }
        
        protected function init_camera_controller () : void
        {
            // NOTE: The controller controls the speed & sensitivity of navigation!
            _camera_controller = new SimpleObjectController(stage, _camera, 200);
            // TODO: What do these do?
            // _camera_controller.mouseSensitivity = 0;
            // _camera_controller.unbindAll();
            _camera_controller.lookAtXYZ(0,0,0);
        }
        
        protected function init_stage_3d () : void
        {
            _stage3D = stage.stage3Ds[0];
            _stage3D.addEventListener(Event.CONTEXT3D_CREATE, init_resource_upload);
            _stage3D.requestContext3D();
        }
        
        protected function init_resource_upload (event:Event) : void 
        {
            upload_resources_to_GPU(_root_container);
            addEventListener(Event.ENTER_FRAME, on_ENTER_FRAME)
        }

        
        /** * * * * * * * * * *
         * Helpers
         * * * * * * * * * * * */

        protected function upload_buffer_to_GPU () : void
        {
            upload_resources_to_GPU(_content_container_buffer);
            
            for (var i:int = _content_container_buffer.numChildren - 1; i >= 0; i--) {
                _content_container.addChild(_content_container_buffer.getChildAt(i));
            } 
        }

        protected function upload_resources_to_GPU (container:Object3D = null) : void
        {
            container ||= _content_container;
            trace(AlternativaEngine, 'doing resource upload for', container);
            for each (var resource:Resource in container.getResources(true)) {
                resource.upload(_stage3D.context3D);
            }
        }
        
        
        /** * * * * * * * * * *
         * On Enter Frame
         * * * * * * * * * * * */

        protected function on_ENTER_FRAME(event:Event) : void 
        {
            _camera_controller.update();
            _camera.render(_stage3D);
        }
        
    }
}