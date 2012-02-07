package view.console
{
    import flash.filesystem.File;
    
    public class ConsoleOutput
    {
        protected var file_path:String = "";
        
        
        public function ConsoleOutput()
        {
        }
        
//        public function add_bookshelf():void
//        {
//            
//        }
        
        protected function clear_bookcases():void
        {
        }
        
        protected var _bookcases:Array = new Array();
        
        public function add_bookcase(files:Array):void
        {
            _bookcases.push(files);      
        }
        
        public function render():void
        {
//            var current_file:File;
            for (var i:uint = 0; i < _bookcases.length; i++)
            {
                var depth_indicator:String = get_depth_indicator(i);
                trace(depth_indicator, 'Rendering folder:', _bookcases[i][0].parent.nativePath);
                for (var j:uint = 0; j < _bookcases[i].length; j++)
                {
                    print_file_data(_bookcases[i][j]);
//                current_file = _bookcases[i];
                }
            }
        }
        
        public function filename_search(query:String):void
        {
            
        }
        
        
        protected function print_file_data(file:File, depth:uint = 0, delimeter:String = '--------------'):void
        {
            var depth_indicator:String = get_depth_indicator(depth);
            
            trace(depth_indicator, delimeter);
            trace(depth_indicator, 'Rendering',file.name);
            trace(depth_indicator, 'size:', file.size, 'bytes');
            // trace(depth_indicator, 'type:', file.type);
            //            trace(depth_indicator, 'extension:', file.extension);
            trace(depth_indicator, 'modification date:', file.modificationDate);
//            trace(depth_indicator, 'native path:',file.nativePath);
//            trace(depth_indicator, 'url:',file.url);
            trace(depth_indicator, 'is directory:', file.isDirectory);
            trace(depth_indicator, 'is hidden:', file.isHidden);
        }
        
        protected function get_depth_indicator(depth:uint):String
        {
            var depth_indicator:String = '';
            for (var i:uint = 0; i < depth; i++)
            {
                depth_indicator += '\t';
            }
            
            return depth_indicator;
        }
        
        protected function get_filename(file:File):String
        {
            var native_path:String = file.nativePath;
            return native_path.substring(native_path.lastIndexOf(File.separator) + 1);
        }
    }
}