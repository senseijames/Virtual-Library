package vui.library.model
{
    import flash.filesystem.File;
    
    import vui.utils.TextUtils;
    
    public class VirtualFolder
    {
        protected var _title : String;
        protected var _contents : Vector.<File>;
        
        public function VirtualFolder(name:String, contents:Vector.<File> = null)
        {
            _title = name;
            _contents = (contents) ? contents : new Vector.<File>();
        }
        
        public function add_file(file:File):void
        {
            contents.push(file);
        }
        public function remove_file(file:File):void
        {
            var index:int = _contents.indexOf(file);
            if (index != -1) {
                _contents.splice(index, 1);
            }
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