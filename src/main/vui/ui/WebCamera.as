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
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import flash.utils.setTimeout;
    
    import vui.utils.TextUtils;

    
    public class WebCamera extends Sprite
    {
        // Entities
        protected var _camera : Camera;
        protected var _video : Video;
        // Delegates
        protected var _activity_reader_timer : Timer;
        // UI
        protected var _activity_text : TextField;
        protected var _activity_bar : Shape;
        // State
//        protected var _is_init_activity_display_queued : Boolean;

        public static const DEFAULT_ACTIVITY_LEVEL : uint = 15;
        public static const DEFAULT_ACTIVITY_TIME : uint = 250;
        public static const ERROR_MESSAGE_DISPLAY_TIME : uint = 3500;
        public static const WEBCAM_NOT_SUPPORTED_MESSAGE : String = "Webcam not available on your system - apologies; gesture control disabled...";
        public static const SEARCHING_FOR_WEBCAM_MESSAGE : String = "E.T. phone your webcam...";
        public static const ACTIVITY_MESSAGE : String = "Got it!";
        public static const ACTIVITY_MESSAGE_DISPLAY_TIME : uint = 500;
        
        public function WebCamera()
        {
            _camera = Camera.getCamera();
            
            if (!Camera.isSupported) {
                show_error(WEBCAM_NOT_SUPPORTED_MESSAGE, ERROR_MESSAGE_DISPLAY_TIME);
            }
            else if (_camera) {
                show_error(SEARCHING_FOR_WEBCAM_MESSAGE, 0.5 * ERROR_MESSAGE_DISPLAY_TIME);
            }
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
            if (!_camera) {
                _camera = Camera.getCamera();
            }
            
            // TODO: Consider removing activity_time from I/F
            connect({ activity_level: options.activity_level, activity_time: options.activity_time }); 

            if (options.show_activity)
            {
                init_activity_display();
            }
        }
        
        public function get video() : Video
        {
            if (!_camera) {
                _camera = Camera.getCamera();
                if (!_camera) {
                    return null;
                }
            }
            
            _video = new Video(_camera.width, _camera.height);
            // Note that this pops up the dialog box.
            _video.attachCamera(_camera);
            
            return _video;
        }
        
        public function stop() : void
        {
            _camera.setMotionLevel(100, 0);
            stop_video();
        }
        
        public function stop_video() : void
        {
            _video.clear();
            removeChild(_video);
            _video = null;
        }
        
        public function get activity_level() : uint
        {
            return _camera.activityLevel;
        }

        public function get is_available() : Boolean
        {
            return _camera && Camera.isSupported;
        }


        /** * * * * * * * * * *
         * Helpers
         * * * * * * * * * * * */
        
        protected function connect(options:Object = null) : void 
        {
            options ||= { }
            _camera.setMotionLevel((options.activity_level != null) ? options.activity_level : DEFAULT_ACTIVITY_LEVEL, (options.activity_level != null) ? options.activity_time : DEFAULT_ACTIVITY_TIME);
            _camera.addEventListener(ActivityEvent.ACTIVITY, activity_EVENT);
        }

        protected function show_error(message:String, time:uint) : void
        {
            var error_message:TextField = TextUtils.get_text_field({ text_format: new TextFormat('courier', 18, 0xFF0000, true) });
            error_message.text = message;
            
            if (_camera)
            {
                error_message.width = _camera.width - 20;
                error_message.x = 0.5 * (_camera.width - error_message.textWidth);
                error_message.y = 0.5 * (_camera.height - error_message.textHeight);
            }
            
            addChild(error_message);
            setTimeout(function():void { removeChild(error_message); }, time);
        }

        
        /** * * * * * * * * * *
         * Event Handlers
         * * * * * * * * * * * */
        
        protected function activity_EVENT(event:ActivityEvent) : void 
        {
            if (event.activating == true) 
            {
                show_error(ACTIVITY_MESSAGE, ACTIVITY_MESSAGE_DISPLAY_TIME);
//                _activity_reader_timer.start();
                dispatchEvent(event);
            } 
//            else 
//            {
//                _activity_text.text = "NADA";
//                _activity_reader_timer.stop();
//            }    
        }
        
        
        /** * * * * * * * * * *
        * Activity Display
        * * * * * * * * * * * */
        
        protected function activity_reader_TICK(event:TimerEvent) : void 
        {
            _activity_text.text = String(_camera.activityLevel);
            _activity_bar.height = _camera.height * _camera.activityLevel / 100;
            _activity_bar.y = _camera.height - _activity_bar.height;
        }
        
        protected function init_activity_display() : void
        {
            if (!_camera) {
//                _is_init_activity_display_queued = true;
                show_error(WEBCAM_NOT_SUPPORTED_MESSAGE, ERROR_MESSAGE_DISPLAY_TIME);
                return;
            }
//            _is_init_activity_display_queued = false;

            _activity_bar =  new Shape();
            _activity_bar.graphics.beginFill(0x00FF00, 0.8);
            _activity_bar.graphics.drawRect(0, 0, _camera.width / 4, 1);
            _activity_bar.x = _camera.width + 2;
            _activity_bar.y = _camera.height;
            addChild(_activity_bar);

            _activity_text = TextUtils.get_text_field({ selectable: false, auto_size: TextFieldAutoSize.LEFT, text_format: new TextFormat('courier', 20) });
            _activity_text.text = "00";
            _activity_text.x = _activity_bar.x + 0.5 * (_activity_bar.width - _activity_text.textWidth);
            _activity_text.y = _activity_bar.y - _activity_text.textHeight - 5;
            addChild(_activity_text);

            _activity_reader_timer = new Timer(100);
            _activity_reader_timer.addEventListener(TimerEvent.TIMER, activity_reader_TICK);
            _activity_reader_timer.start();
        }
        
        protected function disable_activity_display() : void
        {
            removeChild(_activity_bar);
            _activity_bar = null;

            removeChild(_activity_text);
            _activity_text = null;
            
            _activity_reader_timer.stop();
            _activity_reader_timer.removeEventListener(TimerEvent.TIMER, activity_reader_TICK);
            _activity_reader_timer = null;
        }
        
    }
}