package vui.library.mapper
{
    import flash.filesystem.File;
    
    import vui.library.model.FileDirectory;

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
//            throw new Error('[FileSystemMapper] I am a singleton class, saving myself for marriage!');
        }
        
        /*
            ? - how to add content over the Alternativa window such that they still receive/dispatch mouse events?  Might be for a future version.  For now,
                just make the SWF dimensions larger than the the Alternativa window, giving space for that chrome.
        */
        
        
        /**
         *  Returns multidimensional array of Files.
         * 
         *  @param reverse_depth:uint           How deep to search, and a running countdown of the current (reverse) depth of recursion.
         *  @param options.show_hidden:Boolean  Whether to show hidden files (default false)
         */ 
        public static function get_directory_tree(directory:File, reverse_depth:int, options:Object) : FileDirectory
        {
            var file_directory:FileDirectory = new FileDirectory(directory);
            var directory_files:Array = directory.getDirectoryListing();
            
            var current_file:File;
            for (var i:uint = 0; i < directory_files.length; i++)
            {
                current_file = directory_files[i];
                
                if (!options.show_hidden && current_file.isHidden) {
                    continue;
                }
                
                if (current_file.isDirectory && reverse_depth - 1 > 0) {
                    file_directory.push(get_directory_tree(current_file, reverse_depth - 1, options));    
                }
                else {
                    file_directory.push(new FileDirectory(current_file));
                }
            }
            
            return file_directory;
        }
        
        // May be needed on iOS or other platforms where file browser not supported.
        // TODO: Use native extensions instead.
//        protected static function get_file(filename:String) : File
//        {
//        }
    }
}

class SingletonEnforcer { }