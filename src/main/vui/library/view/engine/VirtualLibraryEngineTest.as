package vui.library.view.engine
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.primitives.GeoSphere;
    
    import flash.events.Event;
    
    public class VirtualLibraryEngineTest extends VirtualLibraryEngine
    {
        private var sphere:GeoSphere;

        
        public function VirtualLibraryEngineTest(options:Object)
        {
            super(options);
        }
        
        override protected function init(event:Event = null) : void
        {
            super.init(event);
            
            test();
        }
        
        private function add_test_sphere() : void
        {
            sphere = new GeoSphere(50, 2);
            var sphere_color:Number = 0xFF0000;
            sphere.setMaterialToAllSurfaces(new FillMaterial(sphere_color, 0.9));
            
            _root_container.addChild(sphere);
        }
        
        private function rotate(object:Object3D, x:Number, y:Number, z:Number) : void
        {
            object.rotationX += x;
            object.rotationY += y;
            object.rotationZ += z;
        }
        
        protected function test() : void
        {
            add_test_sphere();
            sphere.x = 50;
        }

        override protected function on_ENTER_FRAME(event:Event) : void 
        {
            rotate(sphere, 0.03, 0.03, 0.03);
            
            super.on_ENTER_FRAME(event);
        }

    }
}