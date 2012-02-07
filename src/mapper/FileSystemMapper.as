package mapper
{
    import flash.filesystem.File;

    /**
     * Delegate for file system mapping; given a directory, returns a data structure (nested array, object, vector, dictionary?)
     * that representst that directory's contents.  Potentially makes use of the "model" packages file models, although FileReference
     * objects might be sufficient.
     * 
     * Future: will want to rewrite this with native extensions; file search is a potential performance bottleneck.
     */ 
    public class FileSystemMapper
    {
        public function FileSystemMapper(chastity_belt:SingletonEnforcer)
        {
        }
        
        /*
            ? - how to add content over the Alternativa window such that they still receive/dispatch mouse events?  Might be for a future version.  For now,
                just make the SWF dimensions larger than the the Alternativa window, giving space for that chrome.
        
            Console Prototype Milestone II - Mapper Algorithm
            1. Implement recursive file search
            2. Choose an appropriate data structure for the files
            3. Console output showing the recursive structure (tabbed over well)
        
            Thoughts: want to display one bookcase at a time?  Maybe a full on directory search is too taxing, too much of a wait for the user.
        */
        
        
        /**
         *  Returns multidimensional array of Files.
         */ 
        public static function map_directory(directory:File, depth:Number = 1):Array
        {
//            if (depth == 0) {
//                return [];
//            }
            
            var directory_map:Array = new Array;
            var directory_files:Array = directory.getDirectoryListing();
            
            var current_file:File;
            for (var i:uint = 0; i < directory_files.length; i++)
            {
                current_file = directory_files[i];
//                if (current_file.isDirectory) {
//                    directory.push([ get_directory(current_file, depth - 1)]);    
//                }
//                else {
                    directory_map.push(current_file);
//                }
            }
            
            return directory_map;
        }
        
        // May be needed on iOS or other platforms where file browser not supported.
        // TODO: Use native extensions instead.
//        protected static function get_file(filename:String):File
//        {
//        }
    }
}

class SingletonEnforcer { }