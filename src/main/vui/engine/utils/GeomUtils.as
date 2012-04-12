package vui.engine.utils
{
    import flash.geom.Vector3D;

    public class GeomUtils
    {
        public function GeomUtils (chastity_belt:SingletonEnforcer)
        {
        }
        
        
        /**
         * 	Takes a screen coordinate and returns a the distance along the ray where
         *  the collision with the supplied plane occurs, if at all.
         */
        public static function testIntersionPlane(planeNormal:Vector3D, planePosition:Vector3D, rayStart:Vector3D, rayDirection:Vector3D): CollisionResult
        {
            var dot:Number = rayDirection.dotProduct(planeNormal);
            if (dot == 0)
                return new CollisionResult(0, false);
            
            var collisionDistance:Number = planeNormal.dotProduct(planePosition.subtract(rayStart)) / dot;
            
            if (collisionDistance <= 0)
                return new CollisionResult(0, false);
            
            return new CollisionResult(collisionDistance, true);
        }
        
        
        
        
        
        
        
        /**
            Copied with only typographical modifications from http://wonderfl.net/c/hrsq
            Original authors: 
                narutohyper
                liquid.cow
        */
        public static function get_intersection_point (lineStart:Vector3D, lineDirection:Vector3D, planePosition:Vector3D, planeNormal:Vector3D) : Vector3D
        {
            var result:Vector3D = new Vector3D();
            var w:Vector3D = lineStart.subtract(planePosition);
            var d:Number = planeNormal.dotProduct(lineDirection);
            var n:Number = -planeNormal.dotProduct(w);
            
            if (Math.abs(d) < 0.0000001) return result;    
            
            var sI:Number = n / d;
            
            result.x = lineStart.x + (lineDirection.x * sI);
            result.y = lineStart.y + (lineDirection.y * sI);
            result.z = lineStart.z + (lineDirection.z * sI);
            
            return result;    
        }
    }
}

class SingletonEnforcer { }