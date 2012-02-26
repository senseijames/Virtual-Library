package view.ui
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.events.TextEvent;
    import flash.text.TextField;
    import flash.text.TextFieldType;
    
    import utils.TextUtils;
    
    public class Chrome extends Sprite
    {
        public static const OPEN_FILE_BROWSER_EVENT:String = "open_file_browser";
        
        protected var _open_file_browser_button:Sprite;
        protected var _live_search_text_field:TextField;
        
        public function Chrome()
        {
            _open_file_browser_button = get_button(60, 30, { color: 0xFF0000});
            
            _live_search_text_field = TextUtils.getTextField();
            _live_search_text_field.type = TextFieldType.INPUT;
//            _live_search_text_field.maxChars 
        }
        
        /**
         *  @params options     width:uint, height:uint, color:uint, alpha:Number
         */ 
        public function init(options:Object):void
        {
            graphics.beginFill(options.color, options.alpha);
            graphics.drawRect(0, 0, options.width, options.height);
            graphics.endFill();
            
            addChild(_open_file_browser_button);
            
            _live_search_text_field.width = Math.max(0.25 * width, 100);
            _live_search_text_field.x = width - _live_search_text_field.width - 10;
            _live_search_text_field.y = 0.5 * (height - _live_search_text_field.height);
//            addChild(_live_search_text_field);
            
            addEventListeners();
        }
        
        protected function addEventListeners():void
        {
            _open_file_browser_button.addEventListener(MouseEvent.CLICK, open_file_browser);
            _open_file_browser_button.buttonMode = true;
            
            _live_search_text_field.addEventListener(Event.CHANGE, do_live_search);
            
            addEventListener(MouseEvent.ROLL_OVER, show);
            addEventListener(MouseEvent.ROLL_OUT, hide);
        }
        
        // TODO: Implement for mobile devices.
        public function resize(options:Object):void
        {
            
        }
        
        protected function do_live_search(e:Event):void
        {
            var textInputEvent:TextEvent = new TextEvent(TextEvent.TEXT_INPUT, true);
            textInputEvent.text = _live_search_text_field.text;
            dispatchEvent(textInputEvent);
        }
        
        protected function open_file_browser(e:MouseEvent):void
        {
            dispatchEvent(new Event(OPEN_FILE_BROWSER_EVENT, true));
        }
        
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
    }
}