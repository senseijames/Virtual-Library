package vui.library.view.engine
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.RayIntersectionData;
    import alternativa.engine3d.core.events.MouseEvent3D;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.primitives.GeoSphere;
    import alternativa.engine3d.primitives.Plane;
    
    import flash.events.Event;
    import flash.events.KeyboardEvent;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.ui.Keyboard;
    
    import vui.engine.AlternativaEngine;
    import vui.engine.utils.CollisionResult;
    import vui.engine.utils.GeomUtils;
    import vui.library.model.FileDirectory;
    import vui.library.model.VirtualFolder;
    import vui.library.model.VirtualFolderEvent;
    import vui.library.view.engine.models.Book;
    import vui.library.view.engine.models.Bookcase;
    
    public class VirtualLibraryEngine extends AlternativaEngine
    {
        // TODO: Consider externalizing as config options.
        public static const FLOOR_WIDTH : uint = 600;
        public static const FLOOR_DEPTH : uint = 600;
        public static const FILE_SYSTEM_FOLDER_COLOR : uint = 0x0000FF;
        public static const VIRTUAL_FOLDER_COLOR : uint = 0xFF0000;
        
        // Entities
        protected var _floor : Plane;
        // TODO: May want to distinguish between file system folder bookcases and virtual folder bookcases somehow...
        protected var _bookcases : Vector.<Bookcase>;
        protected var _virtual_folders : Vector.<VirtualFolder>;
        protected var _file_system_folders : Vector.<FileDirectory>;
        //State
        protected var _selected_virtual_folder : VirtualFolder;
        protected var _selected_bookcase : Bookcase;
        protected var _selected_files : Vector.<Book>;

        
        // TODO: add free navigation (v2 feature?)
        public function VirtualLibraryEngine (options:Object)
        {
            super(options);
            
            _file_system_folders = new Vector.<FileDirectory>;
            _bookcases = new Vector.<Bookcase>;
            _virtual_folders = new Vector.<VirtualFolder>;
            _selected_files = new Vector.<Book>;
        }
        
        public function get selected_files () : Vector.<File>
        {
            var files:Vector.<File> = new Vector.<File>;
            for (var i:uint = 0; i < _selected_files.length; i++) {
                files.push(_selected_files[i].content);
            }
            return files; 
        }
        
        public function get virtual_folders () : Vector.<VirtualFolder>
        {
            // TODO: Consider concat() here.  The protection is probably not worth the complexity.
            return _virtual_folders;
        }
        
        public function live_search (query:String) : void
        {
            var current_virtual_folder:VirtualFolder;
            var current_book:Book;
            for (var i:uint = 0; i < _bookcases.length; i++)
            {
                for (var j:uint = 0; j < _bookcases[i].books.length; j++)
                {
                    current_book = _bookcases[i].books[j];
                    if (current_book.content.name.indexOf(query) != -1) {
                        current_book.select();
                    }
                    else {
                        current_book.deselect();
                    }
                }
            }
        }
        
        
        /* * * * * * * * * * *
        * Initialization
        * * * * * * * * * * */
        override protected function init (event:Event = null) : void
        {
            super.init(event);
            
            // ...
            
            add_floor();
            
            addEventListeners();

//            upload_resources_to_GPU(_root_container);
        }
        
        protected function add_floor () : void
        {
            _floor = new Plane(FLOOR_WIDTH, FLOOR_DEPTH, 5, 5, true, false, new FillMaterial(0x0000FF), new FillMaterial(0x00FFFF));
            _root_container.addChild(_floor);
        }
        
        protected function addEventListeners () : void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, key_DOWN);
//            addEventListener(VirtualFolderEvent.
        }
        
        protected function key_DOWN (event:KeyboardEvent) : void
        {
            switch (event.keyCode)
            {
                case Keyboard.X:
                    toggle_mouse_look();
                default:
                    break;
            }
        }
        
        
        /* * * * * * * * * * * * * * *
        * Virtual Folder CRUD
        * * * * * * * * * * * * * * */
        
        protected function bookcase_CLICK (event:MouseEvent3D) : void
        {
            trace('[VirtualLibraryEngine] Virtual folder clicked and current folder is', event.currentTarget.content.title);
            if (_selected_virtual_folder == event.currentTarget.content)
            {
                _selected_virtual_folder = null;
                event.currentTarget.deselect();
            }
            else
            {
                if (_selected_bookcase) {
                    _selected_bookcase.deselect();
                }
                _selected_virtual_folder = event.currentTarget.content;
                _selected_bookcase = Bookcase(event.currentTarget);
                _selected_bookcase.select();
            }
            trace('Virtual folder now', _selected_virtual_folder);
        }
        
        protected function book_CLICK (event:MouseEvent3D) : void
        {
            trace('[VirtualLibraryEngine] Virtual file clicked and current file is', event.currentTarget.content.name);
            toggle_book_select(Book(event.currentTarget));

            // Stop the event from reaching the bookcase incorrectly.
            event.stopImmediatePropagation();
        }
        
        protected function toggle_book_select (book:Book) : void
        {
            var file_index:int = _selected_files.indexOf(book);
            if (file_index != -1)
            {
                _selected_files.splice(file_index, 1);
                book.deselect();
            }
            else 
            {
                _selected_files.push(book);
                book.select();
            }
            trace('Files are now', _selected_files);
        }
        
        protected function bookcase_DOUBLE_CLICK (event:MouseEvent3D) : void
        {
            trace('\n[VirtualLibraryEngine] Open virtual folder clicked!!\n');
            
            dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.OPEN_FOLDER, { target_folder: event.currentTarget.content.title }));            
        }

        // TODO: Bug - should not have to select the folder in order to remove files from it.
        protected function remove_file_from_folder_CLICK (event:MouseEvent3D) : void
        {
            if (!_selected_virtual_folder) {
                return;
            }
            
            trace('\n[Menu] Remove file from folder clicked!!\n');
            
            dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.REMOVE_FILE, { target_folder: _selected_virtual_folder.title, target_files: _selected_files }));
        }
        
/*
        CRUD:
        1. Add files to virtual folder (future feature, holding control key moves them instead?)
        2. Remove file from a virtual folder (rely on menu??)
    Left off here - need to be able to drag/drop all files that are selected, and then add them to the bookcase upon which they are dropped.    
        
        // Add mouse down listener to book
        // activates mouse move listener that moves all the selected files
        // on mouse up, see if mouse is over a bookcase (if yes, move them to that Virtual Folder, else I'ld be 
*/
//        protected function add_files_to_folder_DROP (event:MouseEvent3D) : void
//        {
//// How to determine whether the mouse is over the bookcase???            
//            if (!_selected_virtual_folder) {
//                return;
//            }
//            
//            trace('\n[Menu] Add file to folder clicked!!\n');
//            
//            dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.ADD_FILE, { target_folder: _selected_virtual_folder.title, target_files: _selected_files }));
//        }
        
// xxx        
        
        
        
        
        
        
        
        /* * * * * * * * * * * * * *
        * Drag and drop support
        * * * * * * * * * * * * * */
        
//        protected var _prev_mouse_x : Number;
//        protected var _prev_mouse_y : Number;
        protected var _drag_start_point : Vector3D;

        
        
        protected function get_drag_start_point (object:Object3D, event:MouseEvent3D) : Vector3D
        {
//            return new Vector3D(event.localX, event.localY, event.localZ);
            return new Vector3D(object.x, object.y, object.z);
            //            var globalCoords:Vector3D = book.localToGlobal(new Vector3D(event.localX, event.localY, event.localZ));
            //            _prev_mouse_x = globalCoords.x;
            //            _prev_mouse_y = globalCoords.y;
            //            var tempObject:Object3D = event.target as Object3D;
            // No longer supported!!  Fuunk
            //            var data:RayIntersectionData = book.intersectRay(event.localOrigin, event.localDirection);
            
            //camera has calculateRay method
            //which calculates center and direction of ray
            //            _camera.calculateRay(localOrigin, localDirection, stage.mouseX, stage.mouseY);
            var local_origin:Vector3D = new Vector3D(event.localX, event.localY, event.localZ);
            //var local_origin:Vector3D = new Vector3D(book.x, book.y, book.z); //_camera.view.x, _camera.view.y, 1);
            
            var local_direction:Vector3D = new Vector3D; // = book.globalToLocal(global_direction);
            trace('before', local_direction);
            _camera.calculateRay(local_origin, local_direction, _camera.view.x, _camera.view.y); //stage.mouseX, stage.mouseY);
            trace('after', local_direction);
            var data:RayIntersectionData = book.intersectRay(local_origin, local_direction);
            if (!data) {
                trace('no ray intersection data!!!!');
                return null;   
            }
            else data.point;
            //_drag_start_point = data.point;
            
            //            _drag_start_point = new Vector3D(event.localX, event.localY, event.localZ); //data.point;
            //            var point:Point = local3DToGlobal(new Vector3D(event.localX, event.localY, event.localZ));
            // new Vector3D(data.point.xpoint.x, point.y, 1);
        }

        
        
        
        protected function book_MOUSE_DOWN (event:MouseEvent3D) : void
        {
            // Keep the event from triggering a bookcase select.
            event.stopImmediatePropagation();
            
trace('mouse down...');            
            var book:Book = Book(event.currentTarget);
            toggle_book_select(book);
// TODO: Re-enable this when you get mouse move working...            
return;         
            _drag_start_point = get_drag_start_point(book, event); 

            stage.addEventListener(MouseEvent.MOUSE_MOVE, book_MOUSE_MOVE);
            stage.addEventListener(MouseEvent.MOUSE_UP, book_MOUSE_UP);
        }
        
        protected function book_MOUSE_UP (event:MouseEvent) : void
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, book_MOUSE_MOVE);
            stage.removeEventListener(MouseEvent.MOUSE_UP, book_MOUSE_UP);
trace('mouse up');
//            _camera_controller.mouseSensitivity = 0.5;
            var target_folder:VirtualFolder;
return;            
            for (var i:uint = 0; i < _bookcases.length; i++)
            {
/*
                Left off here here.
                Major roadblocks here - dragging stuff, and detecting a collision with the bookcase.  Must be a way.  Google.
                
                Definitely need to address the 'add ish to menu doubly draws stuff' bug.
*/
                // If there is a collision with the target folder.
                break;
            }
            
            if (!target_folder) {
                return;
            }
            
            // TODO: Add to virtual folder.        
            dispatchEvent(new VirtualFolderEvent(VirtualFolderEvent.ADD_FILE, { target_folder: target_folder.title, target_files: _selected_files }));
            
        }
        
protected var previous_position : Vector3D;
        
        // Move parallel to the drag target distance is moved parallel to CENTER of cameraView, the distance between the Object3D
        protected function book_MOUSE_MOVE (event:MouseEvent) : void
        {
            var origin:Vector3D = new Vector3D;
            var directionA:Vector3D = new Vector3D;
            var directionB:Vector3D = new Vector3D;
            var direction:Vector3D = new Vector3D;
//trace('Moving:', mouseX, mouseY,'and', _selected_files.length, 'were selected');            
            _camera.calculateRay(origin, directionA, _camera.view.width/2, _camera.view.height/2);
            _camera.calculateRay(origin, directionB, mouseX, mouseY);
            var pos:Vector3D = GeomUtils.get_intersection_point(origin, directionB, new Vector3D(0, _drag_start_point.y, 0), new Vector3D(0, 1, 0));
            
            for (var i:uint = 0; i < _selected_files.length; i++)
            {
                _selected_files[i].x = pos.x - _drag_start_point.x;
                _selected_files[i].y = pos.y - _drag_start_point.y;
                _selected_files[i].z = pos.z - _drag_start_point.z;
            }
            
            
            
            //            trace(event.localX, event.localY, event.stageX, event.stageY);
            /*
            
            Left off here - get the deltas right, then continue with CRUD.  Once you have that, it's polish all the way!  Integrating webcam is a nice to have.
            
            */
            
//            if (Math.abs(event.localX - _prev_mouse_x) > 100) {
//                _prev_mouse_x = event.localX;
//                _prev_mouse_y = event.localY;
//                trace('returning');                
//                return;
//            }

//            
//            _prev_mouse_x = event.localX;
//            _prev_mouse_y = event.localY;
        }
        
        
        
        
        
        
        
        
        
        

        
        
        
        
        /* * * * * * * * * * * * * * * * * * *
        * Virtual Folder/Directory Display
        * * * * * * * * * * * * * * * * * * */
        
        public function set virtual_folders (folders:Vector.<VirtualFolder>) : void
        {
            // TODO: Make sure this doesn't invalidate other arrays.
            var holder:Vector.<VirtualFolder> = folders.concat();
            clear();
            _virtual_folders = holder;
            
            display_virtual_folders();
        }
        
        protected function display_virtual_folders () : void
        {
            if (!_virtual_folders) {
                return;
            }
            for (var i:uint = 0; i < _virtual_folders.length; i++) 
            {
                display_virtual_folder(_virtual_folders[i]);
            }
        }
       
        protected function display_virtual_folder (virtual_folder:VirtualFolder) : void
        {
            var bookcase:Bookcase = new Bookcase(virtual_folder, VIRTUAL_FOLDER_COLOR);
            var current_book:Book;
            // Add each file in the virtual folder.
            for (var i:uint = 0; i < virtual_folder.contents.length; i++) 
            {
                current_book = new Book(virtual_folder.contents[i], _stage3D);
//                current_book.addEventListener(MouseEvent3D.CLICK, book_CLICK);
                current_book.addEventListener(MouseEvent3D.MOUSE_DOWN, book_MOUSE_DOWN);
                bookcase.add_book(current_book);
            }
            
            add_bookcase(bookcase);

            // NOTE: Simplifying assumption - only allow file system files to be selectable.
            bookcase.isDoubleClickEnabled = true;
            bookcase.addEventListener(MouseEvent3D.CLICK, bookcase_CLICK);
            bookcase.addEventListener(MouseEvent3D.DOUBLE_CLICK, bookcase_DOUBLE_CLICK);
        }
        
        // Adds a file system directory to the display.
        public function add_directory (file_directory:FileDirectory) : void //, depth:uint) : void
        {
            if (!file_directory.files) {
                return;
            }

            var bookcase:Bookcase = new Bookcase(file_directory, FILE_SYSTEM_FOLDER_COLOR);
            var current_book:Book;
            for (var i:uint = 0; i < file_directory.files.length; i++) 
            {
                current_book = new Book(file_directory.files[i].directory, _stage3D);
                current_book.addEventListener(MouseEvent3D.MOUSE_DOWN, book_MOUSE_DOWN);
                bookcase.add_book(current_book);
            }
            
            _file_system_folders.push(file_directory);
            
            add_bookcase(bookcase);
        }
        
        
        /* * * * * * * * *
        * UI Helpers
        * * * * * * * * */
        
        protected function add_bookcase (bookcase:Bookcase) : void
        {
            position_bookcase(bookcase);
            
            _bookcases.push(bookcase);
            
            _content_container_buffer.addChild(bookcase);
        }


        // TODO: Consider whether need to make this a 'position_content' method, or whether you should just add
        // a 'layout' method once all the bookcases have been added (maybe call it on render?).
        // TODO: Position the content better.
        protected function position_bookcase (bookcase:Bookcase) : void
        {
            bookcase.x = -0.5 * FLOOR_WIDTH + 0.5 * Bookcase.DEFAULT_WIDTH + _bookcases.length * (Bookcase.DEFAULT_WIDTH + 10);
        }


        /* * * * * * * * * * * *
        * On Enter Frame
        * * * * * * * * * * * */
        override protected function on_ENTER_FRAME (event:Event) : void 
        {
            // ...
            
            super.on_ENTER_FRAME(event);
        }
        
        override public function clear () : void
        {
            super.clear();
            
            _file_system_folders.length = 0;
            _bookcases.length = 0;
            _virtual_folders.length = 0;
        }


    }
}