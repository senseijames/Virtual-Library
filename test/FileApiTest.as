package test
{
    import flash.filesystem.File;
    
    public class FileApiTest
    {
        protected var file_path:String = "";
        
        
        public function FileApiTest()
        {
            trace('zanzibar!');
            print_file_system_data();
        }
        
        /*
        Milestones:
        1. Recursion working, and being able to select a recursion depth limit.
        2. Drop - Selecting any folder from a file browser popup and having it print out the contents.
        */
        
        protected function print_single_folder(file:File, message:String):void
        {
            var files:Array = file.getDirectoryListing();
            //	var files:Array = file.getDirectoryListingAsync();
            print_file_data(file, message, 0, '************************************************');
            
            for (var i:uint = 0; i < files.length; i++)
            {
                print_file_data(files[i], get_filename(file) + ' file ' + i, 1);
            }
        }
        
        protected function get_filename(file:File):String
        {
            var native_path:String = file.nativePath;
            return native_path.substring(native_path.lastIndexOf(File.separator) + 1);
        }
        
        protected function print_file_data(file:File, message:String, depth:uint = 0, delimeter:String = '--------------'):void
        {
            var depth_indicator:String = get_depth_indicator(depth);
            
            trace(depth_indicator, delimeter);
            trace(depth_indicator, 'Printing file info for',message);
            trace(depth_indicator, 'name:',file.name);
            trace(depth_indicator, 'size:', file.size, 'bytes');
            // trace(depth_indicator, 'type:', file.type);
//            trace(depth_indicator, 'extension:', file.extension);
            trace(depth_indicator, 'modification date:', file.modificationDate);
            trace(depth_indicator, 'native path:',file.nativePath);
            trace(depth_indicator, 'url:',file.url);
            trace(depth_indicator, 'is directory:', file.isDirectory);
            trace(depth_indicator, 'is hidden:', file.isHidden);
            trace(depth_indicator, 'parent directory name:', get_filename(file.parent),'and native path is',file.parent.nativePath);
        }
        
        protected function print_file_system_data():void
        {
            print_single_folder(File.desktopDirectory, 'desktop directory');
return;
            print_single_folder(File.userDirectory, 'user directory');
            print_single_folder(File.documentsDirectory, 'documents directory');
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
    }
}