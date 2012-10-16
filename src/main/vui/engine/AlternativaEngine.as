package vui.engine
{    
    import flash.display.Sprite;
    import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.geom.Vector3D;
    
    import alternativa.engine3d.controllers.SimpleObjectController;
    import alternativa.engine3d.core.Camera3D;
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.Resource;
    import alternativa.engine3d.core.View;
    import alternativa.engine3d.lights.AmbientLight;
    import alternativa.engine3d.lights.DirectionalLight;
//    import flash.ui.Keyboard;

    
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
        protected var _is_mouse_look_enabled : Boolean;
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
			
			if (_camera_controller) {
				_camera_controller.setObjectPosXYZ(point.x, point.y, point.z);
			}
        }
        
        public function set camera_sight (point : Vector3D) : void
        {
            _camera_controller.lookAt(point);
        }
        
		public function set view_size ( dimensions : Rectangle) : void
		{
			_camera.view.width = _rectangle.width = dimensions.width;
			_camera.view.height = _rectangle.height = dimensions.height;
		}
		
        public function clear () : void
        {
            for (var i:int = _content_container.numChildren - 1; i >= 0; i--) {
                _content_container.removeChildAt(i);
            }
        }
        
        public function toggle_mouse_look () : void
        {
            _is_mouse_look_enabled ? _camera_controller.stopMouseLook() : _camera_controller.startMouseLook();
            _is_mouse_look_enabled = !_is_mouse_look_enabled;
            //            _camera_controller.unbindKey(Keyboard.X);
            // _camera_controller.bindKey(Keyboard.Q, SimpleObjectController.ACTION_MOUSE_LOOK);
        }
        
		
        
        /** * * * * * * * * * *  Initialization  * * * * * * * * * * * */
        
        protected function init (event:Event = null) : void
        {
            if (event) removeEventListener(event.type, init);
         
            init_engine();
            init_lights();
			init_content();
        }
        
        protected function init_engine () : void
        {
            init_camera();
            init_camera_controller();
			init_resource_containers();
//init_content();
            init_stage_3d();
        }
		
// TODO: This needs revision.
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
		
		protected function init_content () : void
		{
			// Override me please!!
		}
		
        protected function init_camera () : void
        {
			// Camera3D params are nearClipping and farClipping - they are the depth of space the camera
			// can observe, which is the effective range of values in the z-buffer.  The z-buffer, or depth buffer,
			// stores the depths (z-coordinates) of all rendered pixels (with respect to the camera);
            _camera = new Camera3D(0.01, 10000000000);
            camera_position = new Vector3D(-50, -420, 100);
			
            // Create a viewport for the camera, and add the viewport to the regular display list!
			// The viewport is the window through which you view the world. 
            _camera.view = new View(_rectangle.width, _rectangle.height, false, 0x404040, 0, 4);
            addChild(_camera.view);

            // Add the camera to the root container.
            _root_container = new Object3D;
            _root_container.addChild(_camera);

			stage.align = StageAlign .TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, stage_RESIZE);
        }
        
        protected function init_camera_controller () : void
        {
            // SimpleObjectController - allows the user to control the camera position with the keys and mouse,
			// provides the "lookAt" method, and sets the speed & sensitivity of (camera) navigation!
            _camera_controller = new SimpleObjectController(stage, _camera, 200);
             // Default is 1.
             _camera_controller.mouseSensitivity = 0.5;
            // _camera_controller.unbindAll();
            _camera_controller.lookAtXYZ(0,0,0);
        }
		
		protected function init_resource_containers () : void
		{
			// Add a content container to facilitate 'clearing' that content.
			_content_container = new Object3D;
			_root_container.addChild(_content_container);
			// Add a container buffer to optimize uploading new resources to the GPU.
			_content_container_buffer = new Object3D;
		}

        protected function init_stage_3d () : void
        {
            _stage3D = stage.stage3Ds[0];
// TODO: Graceful fallback here? Throw an error to the tune of "Stage3d not available"			
            _stage3D.addEventListener(Event.CONTEXT3D_CREATE, init_resource_upload);
            _stage3D.requestContext3D();
        }
        
        protected function init_resource_upload (event:Event) : void 
        {
			_stage3D.removeEventListener(event.type, arguments.callee);
			
            upload_resources_to_GPU(_root_container);
            addEventListener(Event.ENTER_FRAME, on_ENTER_FRAME)
        }

        
		
        /** * * * * * * * * * *  Helpers  * * * * * * * * * * * */

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

		
		
		/** * * * * * * * * * *  Event Handlers  * * * * * * * * * * * */
		
		private function stage_RESIZE (event:Event = null) : void
		{
			view_size = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
		}

        
		
        /** * * * * * * * * * *  On Enter Frame  * * * * * * * * * * * */

        protected function on_ENTER_FRAME(event:Event) : void 
        {
			// Update the camera controller whenever the camera position can change (in this case, on 
			// every frame, as it is controlled by the mouse).
            _camera_controller.update();
            _camera.render(_stage3D);
        }
        
    }
}