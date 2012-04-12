package vui.engine.models
{
    import alternativa.engine3d.core.Object3D;

    public class Object3DModel extends Object3D
    {
        public function Object3DModel()
        {
            super();
        }
        
        /*
            TODO: Figure out why boundBox is null.
                  Provide getters (and cached properties along with 'recalculate' methods) for half_width and half_height
        
                  calculateBoundBox() returns funky things (100000 and -100000)
        */
        
        public function get width () : Number
        {
            return boundBox.maxX - boundBox.minX;
        }
        
        public function get height () : Number
        {
            return boundBox.maxY - boundBox.minY;
        }
        
        // Currently unused.
        public function get depth () : Number
        {
            return boundBox.maxZ - boundBox.minZ;
        }

    }
}