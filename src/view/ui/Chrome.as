package view.ui
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.text.TextField;
    
    import utils.TextUtils;
    
    public class Chrome extends Sprite
    {
        public static const OPEN_FILE_BROWSER_EVENT:String = "open_file_browser";
        public static const CLEAR_LIBRARY_EVENT:String = "clear_library";
        
        protected var _open_file_browser_button:Sprite;
        protected var _live_search_text_field:TextField;
        protected var _clear_button:Sprite;
        
        public function Chrome()
        {
            _open_file_browser_button = get_button(60, 30, { color: 0xFF0000});
            _clear_button = get_button(30, 30, { color: 0x0000FF });
            _live_search_text_field = TextUtils.get_input_text_field();
        }
        
        
        /* * * * * * * * * * * * * * * * *
        * Initialization
        * * * * * * * * * * * * * * * * */

        /**
         *  @params options     width:uint, height:uint, color:uint, alpha:Number
         */ 
        public function init(options:Object):void
        {
            graphics.clear();
            graphics.beginFill(options.color, options.alpha);
            graphics.drawRect(0, 0, options.width, options.height);
            graphics.endFill();
            
//            _open_file_browser_button.x = 
            addChild(_open_file_browser_button);
            
            _clear_button.x = width - _clear_button.width;
            addChild(_clear_button);
            
            _live_search_text_field.text = "Search";
            _live_search_text_field.height = _live_search_text_field.textHeight + 5;
            _live_search_text_field.width = Math.max(0.25 * width, 100);
            _live_search_text_field.x = width - _live_search_text_field.width - 10;
            _live_search_text_field.y = 0.5 * (height - _live_search_text_field.height);
            
            addChild(_live_search_text_field);
            
            addEventListeners();
        }
        
        protected function addEventListeners():void
        {
            _open_file_browser_button.addEventListener(MouseEvent.CLICK, open_file_browser);
            _open_file_browser_button.buttonMode = true;
            
            _clear_button.addEventListener(MouseEvent.CLICK, clear_library);
            _clear_button.buttonMode = true;
            
            _live_search_text_field.addEventListener(TextEvent.TEXT_INPUT, do_live_search);
            _live_search_text_field.addEventListener(MouseEvent.CLICK, function(e:Event):void { TextField(e.target).text = ''; e.target.removeEventListener(e.type, arguments.callee); });
            
            addEventListener(MouseEvent.ROLL_OVER, show);
            addEventListener(MouseEvent.ROLL_OUT, hide);
        }


        
        /* * * * * * * * * * * * * * * * *
        * Event handling
        * * * * * * * * * * * * * * * * */

        // This method is just to satisfy the compiler; the event will propagate to the Controller through
        // the event flow anyway.
        protected function do_live_search(event:TextEvent):void
        {
//            dispatchEvent(event);
        }
        
        protected function open_file_browser(e:MouseEvent):void
        {
            dispatchEvent(new Event(OPEN_FILE_BROWSER_EVENT, true));
        }
        
        protected function clear_library(e:MouseEvent):void
        {
            dispatchEvent(new Event(CLEAR_LIBRARY_EVENT));
        }

        // protected function removeEventListeners():void
        
        /* * * * * * * * * * * * * * * * *
        * Helpers
        * * * * * * * * * * * * * * * * */

        protected function show(e:Event):void
        {
            this.alpha = 1;
        }
        protected function hide(e:Event):void
        {
            this.alpha = 0;
        }
        
        protected function get_button(width:uint, height:uint, options:Object):Sprite
        {
            var button:Sprite = new Sprite();
            button.graphics.beginFill(options.color);
            button.graphics.drawRect(0, 0, width, height);
            button.graphics.endFill();
            
            button.buttonMode = true;
            
            return button;
        }
        
        
        /* * * * * * * * * * * * * * * * * * *
        * TODO: Implement for mobile devices.
        * * * * * * * * * * * * * * * * * * */
        public function resize(options:Object):void
        {
            
        }

    }
}