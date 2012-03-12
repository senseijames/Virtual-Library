package vui.library.view.ui.menu
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.text.TextField;
    
    import vui.library.utils.GraphicsUtils;
    import vui.library.utils.TextUtils;
    import vui.library.model.VirtualFolder;

    
    public class Menu extends Sprite
    {
        public static const CREATE_VIRTUAL_FOLDER_EVENT : String = "create_virtual_folder";
        public static const DELETE_VIRTUAL_FOLDER_EVENT : String = "delete_virtual_folder";
        public static const ADD_FILE_TO_VIRTUAL_FOLDER_EVENT : String = "add_file";
        public static const REMOVE_FILE_FROM_VIRTUAL_FOLDER_EVENT : String = "remove_file";
        public static const CLOSE_MENU_EVENT : String = "close_menu";
        
        protected var _bg : Shape;
        protected var _create_virtual_folder_button : Sprite;
        protected var _delete_virtual_folder_button : Sprite;
        protected var _add_file_to_virtual_folder_button : Sprite;
        protected var _remove_file_from_virtual_folder_button : Sprite;
        protected var _close_menu_button : Sprite;
        
        public function Menu()
        {
        }
        
        /**
        *   @param options.bgColor, bgAlpha
        *   @param options.width, height
        *   @param options.folders      Array of VirtualFolders
        */
        public function init(options:Object):void
        {
            // Add the bg.
            _bg = GraphicsUtils.get_shape_rect(options.width, options.height, options.bgColor, options.bgAlpha);
            addChild(_bg);
            
            // Create the buttons
            _create_virtual_folder_button = GraphicsUtils.get_button(10, 10, 50, 50, 0x00FF00, 1, create_virtual_folder_CLICK);
            _delete_virtual_folder_button = GraphicsUtils.get_button(60, 10, 50, 50, 0xFF0000, 1, delete_virtual_folder_CLICK);
            _add_file_to_virtual_folder_button = GraphicsUtils.get_button(110, 10, 50, 50, 0x00FF00, 0.5, add_file_to_folder_CLICK);
            _remove_file_from_virtual_folder_button = GraphicsUtils.get_button(160, 10, 50, 50, 0xFF0000, 0.5, remove_file_from_folder_CLICK);
            _close_menu_button = GraphicsUtils.get_button(width - 50, 0, 50, 50, 0xFF0000, 0.3, close_menu_CLICK);
            
            addChild(_create_virtual_folder_button);
            addChild(_delete_virtual_folder_button);
            addChild(_add_file_to_virtual_folder_button);
            addChild(_remove_file_from_virtual_folder_button);
            addChild(_close_menu_button);
            
            // If there are virtual folders, display them.
            if (options.folders) 
            {
                var text_field:TextField;
                for (var i:uint = 0; i < options.folders.length; i++) 
                {
                    text_field = get_virtual_folder_text_field(options.folders[i]);
                    text_field.y = 100;
                    text_field.x = i * (text_field.width + 5);
                    addChild(text_field);
                }
            }
        }
        
        
        /* * * * * * * * * *
        * Helpers
        * * * * * * * * * */

        protected function get_virtual_folder_text_field(folder:VirtualFolder):TextField
        {
            var text_field:TextField = TextUtils.get_text_field();
            trace(text_field, folder);
            text_field.text = folder.title + '\n' + '* * * * * * * * * *\n';
            text_field.width = 100;
            for (var i:uint = 0; i < folder.contents.length; i++)
            {
                text_field.appendText(folder.contents[i].name + '\n');
            }
            
            return text_field;
        }
        
        
        /* * * * * * * * * *
        * Event handlers
        * * * * * * * * * */

        protected function create_virtual_folder_CLICK(event:MouseEvent):void
        {
            trace('\n[Menu] Create virtual folder clicked!!\n');
            
            // ...
            dispatchEvent(new Event(CREATE_VIRTUAL_FOLDER_EVENT));
        }
        protected function delete_virtual_folder_CLICK(event:MouseEvent):void
        {
            trace('\n[Menu] Delete virtual folder clicked!!\n');
            
            // ...
            dispatchEvent(new Event(DELETE_VIRTUAL_FOLDER_EVENT));
        }
        protected function add_file_to_folder_CLICK(event:MouseEvent):void
        {
            trace('\n[Menu] Add file to folder clicked!!\n');
            
            // ...
            dispatchEvent(new Event(ADD_FILE_TO_VIRTUAL_FOLDER_EVENT));
        }
        protected function remove_file_from_folder_CLICK(event:MouseEvent):void
        {
            trace('\n[Menu] Remove file from folder clicked!!\n');
            
            // ...
            dispatchEvent(new Event(REMOVE_FILE_FROM_VIRTUAL_FOLDER_EVENT));
        }
        
        protected function close_menu_CLICK(event:MouseEvent):void
        {
            trace('\n[Menu] Closing menu!\n');

            this.visible = false;
//            dispatchEvent(new Event
        }
    }
}