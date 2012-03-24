package vui.ui
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.ActivityEvent;
    import flash.events.TimerEvent;
    import flash.geom.Rectangle;
    import flash.media.Camera;
    import flash.media.Video;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.utils.Timer;
    
    import vui.utils.TextUtils;

    public class WebCamera extends Sprite
    {
        // Entities
        protected var _camera : Camera;
        protected var _video : Video;
        // Delegates
        protected var _activity_reader_timer : Timer = new Timer(1000);
        // UI
        protected var _activity_text : TextField;
        protected var _activity_bar : Shape;

        
        public function WebCamera()
        {
            _camera = Camera.getCamera();
        }

        /**
        * @param    options.activity_level
        * @param    options.activity_time
        * @param    options.show_video
        * @param    options.video_width (unused)
        * @param    options.video_height (unused)
        */
        public function init(options:Object) : void
        {
            connect({ activity_level: options.activity_level, activity_time: options.activity_time }); 

            if (options.show_video) // options.show_activity_level) 
            {
                _activity_text = TextUtils.get_text_field({ selectable: false, auto_size: TextFieldAutoSize.LEFT });
                _activity_text.x = _camera.width + 10;
                
                _activity_bar =  new Shape();
                
                if (_camera) {
                    _activity_text.text = "Waiting to connect...";
                    
                    addChild(_activity_text);
                    
                    _activity_reader_timer.addEventListener(TimerEvent.TIMER, activity_reader_TICK);
                    _activity_bar.graphics.beginFill(0xFF0000, 1);
                    _activity_bar.graphics.drawRect(_camera.width, 0, _camera.width / 4, 1);
                }
                else {
                    _activity_text.text = "No camera is installed.";
                }
            }
        }
        
        public function get is_available() : Boolean
        {
            // return Camera.isSupported;
            return Boolean(_camera);
        }
        
        public function get activity_level() : uint
        {
            return _camera.activityLevel;
        }
        
        public function get video() : Video
        {
            if (!_camera) {
                return null;
            }
            
            _video = new Video(_camera.width, _camera.height);
            // Note that this pops up the dialog box!  Need to handle this better!!
            _video.attachCamera(_camera);
            
            return _video;
        }
        
        protected function connect(options:Object = null) : void 
        {
            options ||= { };
            _camera.setMotionLevel(options.activity_level, options.activity_time || 1000);
            _camera.addEventListener(ActivityEvent.ACTIVITY, activity_EVENT);
        }
        
        protected function activity_EVENT(event:ActivityEvent) : void 
        {
            if (event.activating == true) 
            {
                _activity_reader_timer.start();
                dispatchEvent(event);
            } 
            else 
            {
                _activity_text.text = "0";
                _activity_reader_timer.stop();
            }    
        }
        
        protected function activity_reader_TICK(event:TimerEvent) : void 
        {
            _activity_text.text = String(_camera.activityLevel);
            _activity_text.y = _camera.height - _activity_text.textHeight - 10;
            
            _activity_bar.height = _camera.height * _camera.activityLevel / 100;
            _activity_bar.y = _camera.height - _activity_bar.height;
        }
    }
}