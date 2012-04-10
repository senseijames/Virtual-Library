package vui.library.view.engine
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.primitives.GeoSphere;
    import alternativa.engine3d.primitives.Plane;
    
    import flash.events.Event;
    import flash.filesystem.File;
    
    import vui.engine.AlternativaEngine;
    import vui.library.model.FileDirectory;
    import vui.library.view.engine.models.Book;
    import vui.library.view.engine.models.Bookcase;
    
    public class VirtualLibraryEngine extends AlternativaEngine
    {
        protected var _floor : Plane;
        protected var _folders : Vector.<Bookcase>;
        protected var _file_directories : Vector.<FileDirectory>;

        
        public function VirtualLibraryEngine (options:Object)
        {
            super(options);
            
            _file_directories = new Vector.<FileDirectory>;
        }
        
        override protected function init (event:Event = null) : void
        {
            super.init(event);
            
            // ...
            
            add_floor();
        }
        
        
        public function add_directory (file_directory:FileDirectory, depth:uint) : void
        {
            _file_directories.push(file_directory);
            
            var bookcase:Bookcase = new Bookcase;
            
            if (!file_directory.files) {
                return;
            }
            
            var current_file:File;
            for (var i:uint = 0; i < file_directory.files.length; i++) 
            {
                current_file = file_directory.files[i].directory;
                bookcase.add_book(new Book(current_file, _stage3D));
                
//                print_file_data(current_file, depth, false, current_file.isDirectory && depth != _depth);
            }

             _root_container_buffer.addChild(bookcase);
        }

        protected function add_floor () : void
        {
            _floor = new Plane(600, 600, 5, 5, true, false, new FillMaterial(0x0000FF), new FillMaterial(0x00FFFF));
            // TODO: add free navigation (v2 feature?)
            
            _root_container.addChild(_floor);
        }


        override protected function on_ENTER_FRAME (event:Event) : void 
        {
            // ...
            
            super.on_ENTER_FRAME(event);
        }

    }
}