package vui.library.view.engine.models
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.primitives.Plane;
    
    import vui.engine.models.Object3DModel;
    import vui.library.model.VirtualFolder;
    
    
    public class Bookcase extends Object3DModel
    {
        // TODO: Allow for constructor injection and externalize.
        public static const DEFAULT_WIDTH : uint = 100;
        public static const DEFAULT_HEIGHT : uint = 200; // 300
        public static const DEFAULT_NUM_SHELVES : uint = 4;
        
        // Entities
        protected var _bookcase : Plane;
        protected var _books : Vector.<Book>;
        protected var _content : Object;
        // State
        protected var _width : uint;
        protected var _height : uint;
        protected var _num_shelves : uint;
        protected var _next_x : int;
        protected var _next_y : int;
//        protected var _files : Vector.<Book>;
        
        
        public function Bookcase (content:Object)
        {
            super();
            
            _content = content;
            _books = new Vector.<Book>;
            _num_shelves = DEFAULT_NUM_SHELVES;
            _next_x = -0.5 * DEFAULT_WIDTH;
            _next_y = 0.5 * DEFAULT_HEIGHT;
            
            // TODO: Decouple into render method?
            _bookcase = new Plane(DEFAULT_WIDTH, DEFAULT_HEIGHT, 5, 5, true, false, new FillMaterial(0x0000FF), new FillMaterial(0xFF0000));
            _bookcase.rotationX = 90;
            // TODO: Confirm.
            // NOTE: This means that translating an object moves it with respect to its coordinate system.
            // TODO: Why Object3D.boundBox null?  Only before render?
            _bookcase.z = 0.5 * DEFAULT_HEIGHT;
//            _bookcase.rotationY = 45;
            
            addChild(_bookcase);
        }
        
        public function add_book (book:Book) : void
        {
            var book_size:uint = book.file_display_size;
            if (_next_x + book_size > 0.5 * DEFAULT_WIDTH) {
                _next_y -= int(DEFAULT_HEIGHT / _num_shelves);
                _next_x = -0.5 * DEFAULT_WIDTH;
            }

            book.x = _next_x + 0.5 * book_size;
            book.y = _next_y - 0.5 * book_size;
            _bookcase.addChild(book);
            _books.push(book);

            _next_x += book_size + 10;
        }
        
        // TODO: Add visual indication of current selection.
        public function select () : void
        {
        }
        public function deselect () : void
        {
        }
        
        public function get content () : Object
        {
            return _content;
        }
        
        public function get view() : Object3D
        {
            return _bookcase;
        }
        
        public function set isDoubleClickEnabled (is_enabled:Boolean) : void
        {
            _bookcase.doubleClickEnabled = is_enabled;
        }

    }
}