package vui.library.view.engine
{
    import alternativa.engine3d.core.Object3D;
    import alternativa.engine3d.materials.FillMaterial;
    import alternativa.engine3d.primitives.GeoSphere;
    import alternativa.engine3d.primitives.Plane;
    
    import flash.events.Event;
    
    import vui.engine.AlternativaEngine;
    
    public class VirtualLibraryEngine extends AlternativaEngine
    {
        
        public function VirtualLibraryEngine(options:Object)
        {
            super(options);
        }
        
        override protected function init(event:Event = null) : void
        {
            super.init(event);
            // ...
        }

        override protected function on_ENTER_FRAME(event:Event) : void 
        {
            // ...
            
            super.on_ENTER_FRAME(event);
        }

    }
}