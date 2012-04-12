package vui.library.view.engine.models
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.core.events.Event3D;
    import alternativa.engine3d.core.events.MouseEvent3D;
    import alternativa.engine3d.materials.TextureMaterial;
    import alternativa.engine3d.primitives.Box;
    import alternativa.engine3d.resources.BitmapTextureResource;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Stage3D;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filesystem.File;
    import flash.text.TextField;
    
    import vui.engine.models.Object3DModel;
    import vui.utils.FileUtils;
    import vui.utils.MathUtils;
    

    public class Book extends Object3DModel
    {
//        public static const DEFAULT_ALPHA : Number = 0.6;
//        public static const MOUSE_OVER_ALPHA : Number = 0.8;
//        public static const MOUSE_DOWN_ALPHA : Number = 1;
        
        // TODO: Cache icons for better performance.
//        protected static var icons_cache : Vector.<BitmapData> = new Vector.<BitmapData>;
        
        protected var _file : File;
        protected var _icon : Bitmap;
        protected var _cube : Box;
        
        
        public function Book (file:File, stage3D:Stage3D)
        {
            _file = file;
            
            var filesize:uint = file_display_size;
            
            _icon = FileUtils.get_icon(file, filesize, true);
            var texture:BitmapTextureResource = new BitmapTextureResource(_icon.bitmapData);
            texture.upload(stage3D.context3D);
            
            _cube = new Box(filesize, filesize, filesize);
            _cube.setMaterialToAllSurfaces(new TextureMaterial(texture));

            addEventListeners();
            
            addChild(_cube);
        }
        
        protected function addEventListeners () : void
        {
            _cube.useHandCursor = true;
            //            _cube.useShadow = true;
            _cube.addEventListener(MouseEvent3D.CLICK, cube_CLICK);
            _cube.addEventListener(MouseEvent3D.ROLL_OVER, cube_ROLL_OVER);
            _cube.addEventListener(MouseEvent3D.ROLL_OUT, cube_ROLL_OUT); 
        }

        // TODO: Expand on this.
        protected function cube_CLICK (event:Event3D) : void
        { 
        }
        protected function cube_ROLL_OVER (e:Event3D) : void 
        {
        }
        protected function cube_ROLL_OUT (event:Event3D) : void 
        { 
        }
        
        // TODO: Cache the result for faster lookup (or can allow clients to do the same?)
        public function get file_display_size () : uint
        {
            try {
                var kilobytes:Number = _file.size / 1024;
                if (kilobytes < 1) {
                    return 16;
                }
                else if (kilobytes > 100) {
                    return 32;
                }
            }
            catch (e:Error) {
                trace(Book, 'file.size threw an error!', e);
            }
            
            return 24;
        }
        
        public function select () : void
        {
            trace('book selected!');
        }
        public function deselect () : void
        {
            trace('book deselected');
        }

        public function get content () : File
        {
            return _file;
        }
        
    }
}