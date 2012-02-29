package view.console
{
    import flash.filesystem.File;
    
    import model.FileDirectory;
    
    /**
     *  View responsibility - add files to shelves; aggregate shelves into bookcases.
     * 
     *  Perhaps a better way to move the responsibilty of aggregating files into shelves to the Controller, but for
     *  simplicity's sake I chose to give the View that responsibility; makes sense on some level that it should know
     *  how to render itself, and can take into account various screen-sizes.  View should be screen-universal, Controller 
     *  should be screen-ignorant.
     * 
     */ 
    public class ConsoleOutput
    {
        // Currently not used...
        protected static const MAX_BOOKS_PER_BOOKCASE:uint = 30;
        
        // State variables.
        protected var _file_directories:Vector.<FileDirectory>;
        protected var _total_books:uint;
        protected var _is_loose_pack:Boolean;
        protected var _depth:uint;

        public function ConsoleOutput()
        {
            _file_directories = new Vector.<FileDirectory>();
        }

        /* * * * * * * * * * * * * * * * *
        * Public interface
        * * * * * * * * * * * * * * * * */

        public function init(options:Object):void
        {
            _is_loose_pack = options.is_loose_pack;
            _depth = options.depth;
        }

        public function add_directory(file_directory:FileDirectory, depth:uint):void
        {
            print_file_data(file_directory.directory, depth, true);
            
            if (!file_directory.files) {
                return;
            }
            
            var current_file:File;
            for (var i:uint = 0; i < file_directory.files.length; i++) 
            {
                current_file = file_directory.files[i].directory;
                print_file_data(current_file, depth, false, current_file.isDirectory && depth != _depth);
            }
        }
        
        public function clear():void
        {
            trace('[Console Output] Clearing...\n');
            _file_directories.length = 0;
            _total_books = 0;
        }

        public function render():void
        {
            trace(_total_books, 'rendered');
        }

        //        public function add_bookcase(files:Array):void
        //        {
        //            _bookcases.push(files);      
        //        }
        //        public function add_bookshelf():void
        //        {
        //            
        //        }

        
        /* * * * * * * * * *
        * Helpers
        * * * * * * * * * */
        
        protected function print_file_data(file:File, depth:uint = 0, is_parent:Boolean = false, is_link:Boolean = false, delimeter:String = '--------------'):void
        {
            _total_books++;
            var depth_spacing:String = get_depth_indicator(depth);
            var type:String = (file.extension) ? file.extension : ((file.isDirectory) ? 'directory' : null);
            if (is_parent) trace(depth_spacing + '* * * * * * * * * * * * * * * * * * * * * * *');
            trace(depth_spacing + (is_parent ? '* ' : '') + file.name,'type:', type, 'size:', file.size, 'bytes','   ', (is_link ? '(link)' : ''));
            if (is_parent) trace(depth_spacing + '* * * * * * * * * * * * * * * * * * * * * * *');
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
        
//        protected function get_filename(file:File):String
//        {
//            var native_path:String = file.nativePath;
//            return native_path.substring(native_path.lastIndexOf(File.separator) + 1);
//        }
        
    }
}