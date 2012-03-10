package vui.library.view.ui.menu
{
    import vui.library.utils.TextUtils;
    
    public class VirtualFolder
    {
        protected var _title:String;
        protected var _contents:Vector.<String>;
        
        public function VirtualFolder()
        {
        }
        
        public function createFolder(name:String, contents:Vector.<String>)
        {
            _contents = contents;
            _title = name;
            
            // Create  
        }
        
        public function render():void
        {
            // Create text fields from the Strings here...
        }
          
    }
}