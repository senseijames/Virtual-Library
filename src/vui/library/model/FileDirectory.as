package vui.library.model
{
    import flash.filesystem.File;

    public class FileDirectory
    {
        protected var _directory:File;
        protected var _files:Vector.<FileDirectory>;
        // TODO: This will not be accurate, as it does not reflect size added at greater than 1 depth of nesting (i.e. it only
        // reflects the size of the current members - the directory and the vector of files, but not their children (and their children's children, and so on). 
        protected var _size:Number;
        
        public function FileDirectory(file:File)
        {
            _directory = file;
            try {
                _size = _directory.size;
            } catch (e:Error) { trace('[FileDirectory] File.size threw an error:', e); trace(e.getStackTrace()); }
        }
        
        public function push(file_directory:FileDirectory):void
        {
            if (!_files) _files = new Vector.<FileDirectory>();
            
            _files.push(file_directory);
            // Interesting that this here compiles; client of class can access private/protected members so long as it is
            // the same type as that class.  Funky.
            _size += file_directory._size;
        }
        
        public function get size():Number
        {
            return _size;
        }
        
        public function get directory():File 
        {
            return _directory;
        }
        
        public function get files():Vector.<FileDirectory>
        {
            return _files;
        }
    }
}