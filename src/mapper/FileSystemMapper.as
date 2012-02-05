package mapper
{
    import flash.filesystem.File;

    /**
     * Delegate for file system mapping; given a directory, returns a data structure (nested array, object, vector, dictionary?)
     * that representst that directory's contents.  Potentially makes use of the "model" packages file models, although FileReference
     * objects might be sufficient.
     */ 
    public class FileSystemMapper
    {
        public function FileSystemMapper(chastity_belt:SingletonEnforcer)
        {
        }
        
        /*
            Console Prototype Milestone II - Mapper Algorithm
            1. Implement recursive file search
            2. Choose an appropriate data structure for the files
            3. Console output showing the recursive structure (tabbed over well)
        */
        
        
        /**
         *  Returns multidimensional array of Files.
         */ 
        public static function get_directory(directory_filepath:String, depth:Number = 1):Array
        {
//            if (depth == 0) {
//                return [];
//            }
            
            var directory:Array = new Array;
            var directory_file:File = get_file(directory_filepath);
            var directory_files:Array = directory_file.getDirectoryListing();
            
            var current_file:File;
            for (var i:uint = 0; i < directory_files.length; i++)
            {
                current_file = directory_files[i];
//                if (current_file.isDirectory) {
//                    directory.push([ get_directory(current_file, depth - 1)]);    
//                }
//                else {
                    directory.push(current_file);
//                }
            }
            
            return directory;
        }
        
        protected static function get_file(filename:String):File
        {
            return File.desktopDirectory;
        }
    }
}

class SingletonEnforcer { }