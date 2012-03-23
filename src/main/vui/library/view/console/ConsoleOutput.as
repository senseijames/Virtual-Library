package vui.library.view.console
{
    import flash.filesystem.File;
    import flash.filesystem.FileStream;
    
    import vui.library.model.FileDirectory;
    
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
        protected static const MAX_BOOKS_PER_BOOKCASE : uint = 30;
        
        // State variables.
        protected var _file_directories : Vector.<FileDirectory>;
        protected var _total_books : uint;
        protected var _is_loose_pack : Boolean;
        protected var _depth : uint;

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

        public function render():void
        {
            trace(_total_books, 'rendered');
        }

        public function clear():void
        {
            trace('[Console Output] Clearing...\n');
            _file_directories.length = 0;
            _total_books = 0;
        }
        
        public function add_directory(file_directory:FileDirectory, depth:uint):void
        {
            _file_directories.push(file_directory);
            
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
        
        public function live_search(query:String):void
        {
            for (var i:uint = 0; i < _file_directories.length; i++)
            {
                search_directory(_file_directories[i], query);
            }
        }
        
        /*
            Searching almost working - showing double duplicates or what?
        */
        
        public function search_directory(directory:FileDirectory, query:String):void
        {
            if (directory.directory.name.toLowerCase().indexOf(query) != -1) {
                highlight_file(directory.directory, directory.files && directory.files.length != 0);
            }
            
            if (!directory.files || directory.files.length == 0) {
                return;
            }
            
            for (var i:uint = 0; i < directory.files.length; i++) 
            {
                if (directory.files[i].directory.name.toLowerCase().indexOf(query) != -1) {
                    highlight_file(directory.files[i].directory, false);
                }
            }
        }
        
        /* * * * * * * * * * * * * * *
        * Virtual folder management
        * * * * * * * * * * * * * * */
        // TODO: I imagine the I/F will change as you come to understand more about the requirements
        // and "how the system wants to be programmed".
        public function select_file(file:File):void
        {
        }
        
        protected function highlight_file(file:File, is_directory_with_children:Boolean):void
        {
            var string:String = ((is_directory_with_children) ? 'bookcase' : 'book') + ':';
            trace('[ConsoleOutput] Highlighting', string, file.nativePath);
        }

        // TODO: Move these to the Controller.
        protected var _app_storage_directory:File;
        protected var _app_storage_directory_file_stream:FileStream;
        // Need them to persist across runnings of the program.
        public function create_virtual_folder(name:String):void
        {
            if (!_app_storage_directory) {
                _app_storage_directory = File.applicationStorageDirectory;
            }
            if (!_app_storage_directory_file_stream) {
                _app_storage_directory_file_stream = new FileStream();
            }
//            var fileStream:FileStream = new FileStream();
//            fileStream.open(file, FileMode.WRITE);
//            fileStream.writeUTF(str);
//            fileStream.close();            
        }
        public function open_virtual_folder(name:String):void
        {
        }
        public function add_to_virtual_folder(file:File, virtual_folder_name:String):void
        {
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