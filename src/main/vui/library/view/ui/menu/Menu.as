package vui.library.view.ui.menu
{
    import flash.display.DisplayObject;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import flash.filters.DropShadowFilter;
    import flash.filters.GlowFilter;
    import flash.geom.Rectangle;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;
    
    import vui.library.model.VirtualFolder;
    import vui.library.model.VirtualFolderEvent;
    import vui.ui.InteractiveTextField;
    import vui.utils.ButtonUtils;
    import vui.utils.GraphicsUtils;
    import vui.utils.TextUtils;

    
    public class Menu extends Sprite
    {
        public static const CLOSE_MENU_EVENT : String = "close_menu";
        public static const ITEM_SELECTED_GLOW_FILTER : GlowFilter = new GlowFilter();
        public static const ERROR_TEXT_DISPLAY_TIME : uint = 5000;

        // UI.
        protected var _bg : Shape;
        protected var _create_virtual_folder_button : Sprite;
        protected var _delete_virtual_folder_button : Sprite;
        protected var _add_file_to_virtual_folder_button : Sprite;
        protected var _remove_file_from_virtual_folder_button : Sprite;
        protected var _open_virtual_folder_button : Sprite;
        protected var _close_menu_button : Sprite;
        protected var _error_text_field : TextField;
        // UI State.
        protected var _selected_virtual_folder_text_field : InteractiveTextField;
        protected var _virtual_folder_sprites : Vector.<Sprite>;
        // Delegates.
        protected var _file_browser : File;
        protected var _timeout_descriptor : Number;
        // State.
        protected var _selected_virtual_folder : VirtualFolder;
        protected var _selected_files : Vector.<File>;
        protected var _virtual_folders : Vector.<VirtualFolder>;
        
        public function Menu()
        {
            _selected_files = new Vector.<File>;
        }
        
        /**
        *   @param options.bgColor, bgAlpha
        *   @param options.width, height
        *   @param options.folders      Array of VirtualFolders
        */
        public function init (options:Object) : void
        {
            // Add the bg.
            _bg = GraphicsUtils.get_shape_rect(options.width, options.height, options.bgColor, options.bgAlpha);
            addChild(_bg);
            
            // Create the buttons.
            _open_virtual_folder_button = ButtonUtils.get_button(new Rectangle(10, 10, 50, 50), 'OPEN', { color: 0xFFFF00, init: true }, open_virtual_folder_CLICK);
            _create_virtual_folder_button = ButtonUtils.get_button(new Rectangle(_open_virtual_folder_button.x + _open_virtual_folder_button.width + 10, 10, 50, 50), 'CREATE', { color: 0x00FF00, init: true }, create_virtual_folder_CLICK);
            _delete_virtual_folder_button = ButtonUtils.get_button(new Rectangle(_create_virtual_folder_button.x + _create_virtual_folder_button.width + 10, 10, 50, 50), 'DELETE', { color: 0xFF0000, init: true }, delete_virtual_folder_CLICK);
            _add_file_to_virtual_folder_button = ButtonUtils.get_button(new Rectangle(10, 60, 50, 50), 'ADD FILE', { color: 0x00FF00, init: true }, add_file_to_folder_CLICK);
            _remove_file_from_virtual_folder_button = ButtonUtils.get_button(new Rectangle(_add_file_to_virtual_folder_button.x + _add_file_to_virtual_folder_button.width + 10, 60, 50, 50), 'REMOVE FILE', { color: 0xFF0000, init: true }, remove_file_from_folder_CLICK);
            _close_menu_button = ButtonUtils.get_button(new Rectangle(0, 0, 50, 50), 'X', { color: 0xFF0000, init: true }, close_menu_CLICK);
            _close_menu_button.x = width - _close_menu_button.width;
            // Create the error text.
            _error_text_field = TextUtils.get_text_field();
            _error_text_field.defaultTextFormat = new TextFormat(null, 11, 0xFF0000);
            _error_text_field.x = 5;
            _error_text_field.width = _bg.width - 10;
            _error_text_field.visible = false;

            addChild(_open_virtual_folder_button);
            addChild(_create_virtual_folder_button);
            addChild(_delete_virtual_folder_button);
            addChild(_add_file_to_virtual_folder_button);
            addChild(_remove_file_from_virtual_folder_button);
            addChild(_close_menu_button);
            addChild(_error_text_field);
            
            virtual_folders = options.folders;
        }

        public function set virtual_folders (folders:Vector.<VirtualFolder>) : void
        {
            _virtual_folders = folders;
            
            display_virtual_folders();
        }
        
        public function display_virtual_folders () : void
        {
            if (_virtual_folder_sprites) 
            {
                _virtual_folder_sprites.forEach(function(object:Sprite, index:int, vector:Vector.<Sprite>) : void { removeChild(object); });
                _virtual_folder_sprites.length = 0;
                _selected_virtual_folder = null;
                _selected_files.length = 0;
            }
            else
            {
                _virtual_folder_sprites = new Vector.<Sprite>();
            }
            
            // If there are virtual folders, display them.
            if (!_virtual_folders) {
                return;
            }
            
            var virtual_folder_text_sprite:Sprite;
            var x_value:uint = 0;
            for (var i:uint = 0; i < _virtual_folders.length; i++) 
            {
                if (virtual_folder_text_sprite) {
                    x_value += virtual_folder_text_sprite.width;
                }
                virtual_folder_text_sprite = get_virtual_folder_sprite(_virtual_folders[i]);
                virtual_folder_text_sprite.y = 100;
                virtual_folder_text_sprite.x = x_value;
                
                _virtual_folder_sprites.push(virtual_folder_text_sprite);
                addChild(virtual_folder_text_sprite);
            }
        }
        
        protected function get_virtual_folder_sprite (folder:VirtualFolder) : Sprite
        {
            var folder_sprite:Sprite = new Sprite();
            
            var title_text_field:InteractiveTextField = new InteractiveTextField();
            title_text_field.content = folder;
            title_text_field.text = folder.title;
            title_text_field.addEventListener(MouseEvent.CLICK, virtual_folder_CLICK);
            folder_sprite.addChild(title_text_field);

            var virtual_folder_file:InteractiveTextField;
            var current_y:uint = title_text_field.textHeight;
            for (var i:uint = 0; i < folder.contents.length; i++)
            {
                virtual_folder_file = new InteractiveTextField();
                virtual_folder_file.content = folder.contents[i];
                virtual_folder_file.text = folder.contents[i].name;
                virtual_folder_file.y = current_y;
                
                virtual_folder_file.addEventListener(MouseEvent.CLICK, virtual_folder_file_CLICK);
                
                folder_sprite.addChild(virtual_folder_file);
                
                current_y = virtual_folder_file.y + virtual_folder_file.textHeight;
            }
            
            return folder_sprite;
        }

        public function show_error (error_text:String) : void
        {
            if (_error_text_field.visible) {
                _error_text_field.appendText('\n' + error_text);
            }
            else {
                _error_text_field.text = error_text;   
            }
            
            if (!isNaN(_timeout_descriptor)) {
                clearTimeout(_timeout_descriptor);
            }
            
            _timeout_descriptor = setTimeout(function() : void { _timeout_descriptor = NaN; _error_text_field.visible = false; }, ERROR_TEXT_DISPLAY_TIME);
            
            _error_text_field.y = _bg.height - _error_text_field.textHeight - 10;
            _error_text_field.visible = true;
        }
        
        
        /* * * * * * * * * * * * * * * * * * *
        * Folder/file select event handlers
        * * * * * * * * * * * * * * * * * * */
        
        protected function virtual_folder_CLICK (event:MouseEvent) : void
        {
            trace('[Menu] Virtual folder clicked and current folder is', event.currentTarget.content.title);
            if (_selected_virtual_folder == event.currentTarget.content)
            {
                _selected_virtual_folder = null;
                event.currentTarget.filters = null;
            }
            else
            {
                if (_selected_virtual_folder_text_field) {
                    _selected_virtual_folder_text_field.filters = null;
                }
                _selected_virtual_folder = event.currentTarget.content;
                _selected_virtual_folder_text_field = InteractiveTextField(event.currentTarget);
                _selected_virtual_folder_text_field.filters = [ ITEM_SELECTED_GLOW_FILTER ];
            }
            trace('Virtual folder now', _selected_virtual_folder);
        }
        
        protected function virtual_folder_file_CLICK (event:MouseEvent) : void
        {
            trace('[Menu] Virtual file clicked and current file is', event.currentTarget.content.name);
            var file_index:int = _selected_files.indexOf(event.currentTarget.content);
            if (file_index != -1)
            {
                _selected_files.splice(file_index, 1);
                event.currentTarget.filters = null;
            }
            else 
            {
                _selected_files.push(event.currentTarget.content);
                event.currentTarget.filters = [ ITEM_SELECTED_GLOW_FILTER ];
            }
            trace('Virtual file now', _selected_files);
        }
        
        
        /* * * * * * * * * * * * * * * * * * * * * * *
        * Virtual Folder CRUD button event handlers
        * * * * * * * * * * * * * * * * * * * * * * */
        
        protected function open_virtual_folder_CLICK (event:MouseEvent) : void
        {
            if (!_selected_virtual_folder) {
                return;
            }
            
            trace('\n[Menu] Open virtual folder clicked!!\n');
            
            dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.OPEN_FOLDER, { target_folder: _selected_virtual_folder.title }));            
        }
        
        protected function create_virtual_folder_CLICK (event:MouseEvent) : void
        {
            trace('\n[Menu] Create virtual folder clicked!!\n');
            // Show an input text field and a 'submit' button, and dispatch the event on save.
            var input_text_field:TextField = TextUtils.get_input_text_field();
            input_text_field.width = 100;
            input_text_field.height = 20;
            input_text_field.y = height - input_text_field.height;
            var submit_button:Sprite = ButtonUtils.get_button(new Rectangle(input_text_field.x + input_text_field.width + 10, input_text_field.y, 50, 50), 'CREATE', { color: 0xFF0000, init: true }, submit_virtual_folder_CLICK);
            
            addChild(input_text_field);
            addChild(submit_button);
            
            function submit_virtual_folder_CLICK(event:MouseEvent) : void
            {
                trace('[Menu] Attempting to create virtual folder!');
                
                removeChild(input_text_field);
                removeChild(submit_button);

                dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.CREATE_FOLDER, { target_folder: input_text_field.text }));
            }
        }
        
        protected function delete_virtual_folder_CLICK (event:MouseEvent) : void
        {
            if (!_selected_virtual_folder) {
                return;
            }
            
            trace('\n[Menu] Delete virtual folder clicked!!\n');
            
            dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.DELETE_FOLDER, { target_folder: _selected_virtual_folder.title }));
        }
        
        protected function add_file_to_folder_CLICK (event:MouseEvent) : void
        {
            if (!_selected_virtual_folder) {
                return;
            }

            trace('\n[Menu] Add file to folder clicked!!\n');
            
            dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.ADD_FILE, { target_folder: _selected_virtual_folder.title, target_files: _selected_files }));
        }
        
        // TODO: Bug - should not have to select the folder in order to remove files from it.
        protected function remove_file_from_folder_CLICK (event:MouseEvent) : void
        {
            if (!_selected_virtual_folder) {
                return;
            }

            trace('\n[Menu] Remove file from folder clicked!!\n');
            
            dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.REMOVE_FILE, { target_folder: _selected_virtual_folder.title, target_files: _selected_files }));
        }

        
        /* * * * * * * * * *
        * Helpers
        * * * * * * * * * */

        protected function open_file_browser (file_browser_SELECT:Function, file_browser_title:String) : void
        {
            if (!_file_browser) {
                _file_browser = new File();
            }
            else {
                _file_browser.cancel();
            }
            
            _file_browser.addEventListener(Event.SELECT, file_browser_SELECT);
            _file_browser.addEventListener(Event.CANCEL, trace);
            _file_browser.addEventListener(IOErrorEvent.IO_ERROR, trace);
            
            try {
                // TODO: Upgrade to browseForOpenMultiple
                _file_browser.browseForOpen(file_browser_title);
            }
            catch (e:Error) {
                /*
                IllegalOperationError — A browse operation (browseForOpen(), browseForOpenMultiple(), browseForSave(), browseForDirectory()) is currently running.
                SecurityError — The application does not have the necessary permissions.
                */
                trace('File browser browseForOpen:', e); 
            }
        }
 
        
        /* * * * * * * * * *
        * Event Handlers
        * * * * * * * * * */

        protected function close_menu_CLICK (event:MouseEvent) : void
        {
            trace('\n[Menu] Closing menu!\n');

            this.visible = false;
//            dispatchEvent(new Event
        }
    }
}