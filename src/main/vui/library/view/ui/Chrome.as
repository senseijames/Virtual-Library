package vui.library.view.ui
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.BevelFilter;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    
    import vui.library.model.VirtualFolderEvent;
    import vui.library.view.ui.menu.Menu;
    import vui.utils.ButtonUtils;
    import vui.utils.TextUtils;
    
    public class Chrome extends Sprite
    {
        // Event types
// TODO: Clean these up here - externalize?        
        public static const OPEN_FILE_BROWSER_EVENT : String = "open_file_browser";
        public static const VIEW_VIRTUAL_FOLDERS_EVENT : String = "view_virtual_folders";
        public static const CLEAR_LIBRARY_EVENT : String = "clear_library";
        public static const TOGGLE_MENU_EVENT : String = "toggle_menu";
        // UI
        protected var _open_file_browser_button : Sprite;
        protected var _view_virtual_folders_button : Sprite;
        protected var _live_search_text_field : TextField;
        protected var _clear_button : Sprite;
        protected var _toggle_menu_button : Sprite;
        // TODO: Revisit this here.
        protected var _create_and_add_button : Sprite;
        
        public function Chrome()
        {
            // color:uint = Math.random() * 0xffffff, init_button:Boolean = true, text_color:uint = 0x000000, autosize
            _open_file_browser_button = ButtonUtils.get_button(new Rectangle(0, 0, 60, 30), 'BROWSE', { color: 0xFF0000, init: false });
            _view_virtual_folders_button = ButtonUtils.get_button(new Rectangle(0, 0, 60, 30), 'VIEW', { color: 0x0000FF, init: false });
            _clear_button = ButtonUtils.get_button(new Rectangle(0, 0, 30, 30), 'CLEAR', { color: 0xFF0000, init: false });
            _toggle_menu_button = ButtonUtils.get_button(new Rectangle(0, 0, 30, 30), 'MENU', { color: 0x00FF00, init: false });
            _live_search_text_field = TextUtils.get_input_text_field();
            
            _create_and_add_button = ButtonUtils.get_button(new Rectangle(0, 0, 80, 30), 'CREATE & ADD', { color: 0xFFFF00, init: false });
        }
        
        
        /* * * * * * * * * * * * * * * * *
        * Initialization
        * * * * * * * * * * * * * * * * */

        /**
         *  @params options     width:uint, height:uint, color:uint, alpha:Number
         */ 
        public function init(options:Object) : void
        {
            // Draw the bg.
            graphics.clear();
            graphics.beginFill(options.color, options.alpha);
            graphics.drawRect(0, 0, options.width, options.height);
            graphics.endFill();

            // Init the buttons.
            var bevel_filter:BevelFilter = new BevelFilter();
            ButtonUtils.init_button(_open_file_browser_button, [ bevel_filter ], open_file_browser_CLICK);
            ButtonUtils.init_button(_view_virtual_folders_button, [ bevel_filter ], open_virtual_folders_CLICK);
            ButtonUtils.init_button(_clear_button, [ bevel_filter ], clear_library_CLICK);
            ButtonUtils.init_button(_toggle_menu_button, [ bevel_filter ], toggle_menu_CLICK);
            ButtonUtils.init_button(_create_and_add_button, [ bevel_filter ], create_and_add_CLICK);

            init_live_search_text_field();
            
            _clear_button.x = width - _clear_button.width;
            _view_virtual_folders_button.x = _open_file_browser_button.x + _open_file_browser_button.width + 10;
            _toggle_menu_button.x = _view_virtual_folders_button.x + _view_virtual_folders_button.width + 10;
            _toggle_menu_button.y = _view_virtual_folders_button.y = _open_file_browser_button.y;
            _create_and_add_button.x = _toggle_menu_button.x + _toggle_menu_button.width + 10; 

            addChild(_clear_button);
            addChild(_open_file_browser_button);
            addChild(_live_search_text_field);
            addChild(_view_virtual_folders_button);
            addChild(_toggle_menu_button);
            addChild(_create_and_add_button);
            
            addEventListeners();
        }
        
        protected function init_live_search_text_field() : void
        {
            _live_search_text_field.text = "Search";
            _live_search_text_field.height = _live_search_text_field.textHeight + 5;
            _live_search_text_field.width = Math.max(0.25 * width, 100);
            _live_search_text_field.x = width - _live_search_text_field.width - _clear_button.width - 10;
            _live_search_text_field.y = 0.5 * (height - _live_search_text_field.height);
            
            //            _live_search_text_field.addEventListener(TextEvent.TEXT_INPUT, do_live_search);
            _live_search_text_field.addEventListener(Event.CHANGE, do_live_search);
            _live_search_text_field.addEventListener(MouseEvent.CLICK, function(e:Event) : void { TextField(e.target).text = ''; e.target.removeEventListener(e.type, arguments.callee); });
        }

        protected function addEventListeners() : void
        {
            addEventListener(MouseEvent.ROLL_OVER, show);
            addEventListener(MouseEvent.ROLL_OUT, hide);
        }
        

        /* * * * * * * * * * * * * * * * *
        * Event handling
        * * * * * * * * * * * * * * * * */

        // This method is just to satisfy the compiler; the event will propagate to the Controller through
        // the event flow anyway.
        protected function do_live_search (event:Event) : void
        {
//            dispatchEvent(event);
        }
        
        protected function open_file_browser_CLICK (e:MouseEvent) : void
        {
            dispatchEvent(new Event(OPEN_FILE_BROWSER_EVENT, true));
        }
        protected function open_virtual_folders_CLICK (e:MouseEvent) : void
        {
            dispatchEvent(new Event(VIEW_VIRTUAL_FOLDERS_EVENT));
        }
        protected function clear_library_CLICK (e:MouseEvent) : void
        {
            dispatchEvent(new Event(CLEAR_LIBRARY_EVENT));
        }
        protected function toggle_menu_CLICK (e:MouseEvent) : void
        {
            dispatchEvent(new Event(TOGGLE_MENU_EVENT));
        }
        protected function create_and_add_CLICK (e:MouseEvent) : void
        {
            dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.CREATE_FOLDER_AND_ADD_FILES));
        }

        // protected function removeEventListeners() : void
        
        /* * * * * * * * * * * * * * * * *
        * Helpers
        * * * * * * * * * * * * * * * * */

        protected function show(e:Event) : void
        {
            this.alpha = 1;
        }
        protected function hide(e:Event) : void
        {
            this.alpha = 0;
        }

        
        /* * * * * * * * * * * * * * * * * * *
        * TODO: Implement for mobile devices.
        * * * * * * * * * * * * * * * * * * */
        public function resize(options:Object) : void
        {
            
        }

    }
}