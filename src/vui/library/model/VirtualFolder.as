package vui.library.model
{
    import flash.filesystem.File;
    
    import vui.library.utils.TextUtils;
    
    public class VirtualFolder
    {
        protected var _title:String;
        protected var _contents:Vector.<File>;
        
        public function VirtualFolder(name:String, contents:Vector.<File>)
        {
            _title = name;
            _contents = (contents) ? contents : new Vector.<File>();
        }
        
        public function add_file(file:File):void
        {
        }
        public function remove_file(file:File):void
        {
        }
        
        public function render():void
        {
            // Create text fields from the Strings here...
        }
          
        
        public function get title():String
        {
            return _title;
        }
        
        public function get contents():Vector.<File>
        {
            return _contents;
        }
    }
}