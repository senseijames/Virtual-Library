package vui.library.model
{
    import flash.events.Event;
    import flash.filesystem.File;

    
    // NOTE: If more types, consider moving to vui.library.events
    public class VirtualFolderEvent extends Event
    {
        // Event types.
        public static const OPEN_FOLDER : String = "open_virtual_folder";
//        public static const OPEN_FILE : String = "open_file";
        public static const CREATE_FOLDER : String = "create_virtual_folder";
        public static const DELETE_FOLDER : String = "delete_virtual_folder";
        public static const ADD_FILE : String = "add_file";
        public static const REMOVE_FILE : String = "remove_file";
        // Members.
//        protected var _target_folder : VirtualFolder;
        protected var _target_folder : String;
        protected var _target_files : Vector.<File>;
        protected var _options : Object;
        
        /**
        * @param    options.target_files : Vector.<File>
        * @param    options.target_folder : VirtualFolder
        */
        public function VirtualFolderEvent(type:String, options:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
        {
            super(type, bubbles, cancelable);
            
            _options = options;
            _target_folder = options.target_folder;
            _target_files = options.target_files;
        }
        
        public function get target_folder() : String
        {
            return _target_folder;
        }
        public function get target_files() : Vector.<File>
        {
            return _target_files;
        }

        
        /* * * * * * * * * * * *
        * Event class overrides
        * * * * * * * * * * * */
        
        public override function clone() : Event
        {
            return new VirtualFolderEvent(type, _options, bubbles, cancelable);
        }
        
        public override function toString() : String
        {
            return formatToString("VirtualFolderEvent", "params", "type", "bubbles", "cancelable");
        }
    }
}