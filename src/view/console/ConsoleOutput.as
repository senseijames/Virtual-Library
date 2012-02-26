package view.console
{
    import flash.filesystem.File;
    
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
        protected static const MAX_BOOKS_PER_BOOKCASE:uint = 30;
        
        // 2d arrays of bookcases.
        protected var _depth_0_bookcases:Array;
        protected var _depth_1_bookcases:Array;
        protected var _depth_2_bookcases:Array;
        protected var _depth_3_bookcases:Array;
        // State variables.
        protected var _total_books:uint;
        protected var _is_loose_pack:Boolean;

        public function ConsoleOutput()
        {
        }

        public function init(options:Object):void
        {
            _is_loose_pack = options.is_loose_pack;
        }
        
//        public function add_bookshelf():void
//        {
//            
//        }
        
        protected function clear_bookcases():void
        {
        }
        
        public function add_book(file:File, depth:uint):void
        {
            if (!this['_depth_' + String(depth) + '_bookcases']) {
                this['_depth_' + String(depth) + '_bookcases'] = new Array();
                this['_depth_' + String(depth) + '_bookcases'].push(new Array());
            }
            
            var aisle:Array = this['_depth_' + String(depth) + '_bookcases'];
        
/* TODO: Left off here - this logic is wrong, first of all; it's putting all books on their own bookshelf.  But furthermore,
         the way you're adding books is fundamentally wrong.  You're adding each book to ONE bookshelf, when in truth you need
         to add directories to TWO bookshelves - as a book on their parent bookshelf, and as a bookcase/bookshelf label/title
         on their own bookcase/shelf.  And you need to link the two somehow.  I think shoe-horning your FileDirectory structure
         into a series of 2d arrays just isn't working; need a better view representation of these for now.  Maybe just display
         raw; there is little in implementation that you will be able to transfer from ConsoleOutput to EngineOutput - only the I/F
         will likely be reusable.
            
*/
// TODO resolve this here now - should only start a new bookshelf if is_loose_pack == true            
            // Hold 30 books for now.
            if (aisle[aisle.length - 1].length >= MAX_BOOKS_PER_BOOKCASE || 
                _is_loose_pack && aisle[aisle.length - 1].length > 0 && file.parent != aisle[aisle.length - 1][0].parent) { // && depth != 3) {
                aisle.push(new Array());
            }

            aisle[aisle.length - 1].push(file);    
            _total_books++;
        }
        
//        public function add_bookcase(files:Array):void
//        {
//            _bookcases.push(files);      
//        }
        
        public function render():void
        {
            trace('Rendering', _total_books, 'books total...');
// TODO: Depth here is hard-coded.            
            for (var i:uint = 0; i < 4; i++) {
trace('rendering bookcase',i);                
                render_bookcases_at_depth(i);
            }
        }
         
        protected function render_bookcases_at_depth(depth:uint):void
        {
            var bookcases:Array = this['_depth_' + String(depth) + '_bookcases'];
            for (var i:uint = 0; i < bookcases.length; i++)
            {
                var depth_indicator:String = get_depth_indicator(depth);
                trace('\n',depth_indicator, 'Rendering ' + depth + ':' + i + ' - ' + bookcases[i][0].nativePath + ' - has', bookcases[i].length, 'books.');
                trace(depth_indicator, '* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *');
                for (var j:uint = 0; j < bookcases[i].length; j++)
                {
                    print_file_data(bookcases[i][j], depth);
                }
            }
        }
        
        public function filename_search(query:String):void
        {
            
        }
        
        
        protected function print_file_data(file:File, depth:uint = 0, delimeter:String = '--------------'):void
        {
            trace(get_depth_indicator(depth), file.name,'type:', file.extension, 'size:', file.size, 'bytes');
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