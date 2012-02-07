package view.ui
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    
    public class Chrome extends Sprite
    {
        public static const OPEN_FILE_BROWSER_EVENT:String = "open_file_browser";
        
        protected var _open_file_browser_button:Sprite;
        
        public function Chrome()
        {
            _open_file_browser_button = get_button(60, 30, { color: 0xFF0000});
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
            
            addEventListeners();
        }
        
        protected function addEventListeners():void
        {
            _open_file_browser_button.addEventListener(MouseEvent.CLICK, open_file_browser);
            _open_file_browser_button.buttonMode = true;
            addEventListener(MouseEvent.ROLL_OVER, show);
            addEventListener(MouseEvent.ROLL_OUT, hide);
        }
        
        // TODO: Implement for mobile devices.
        public function resize(options:Object):void
        {
            
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