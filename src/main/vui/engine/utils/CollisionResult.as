package vui.engine.utils
{
    /**
     * 	A simple class that holds the result of a collision calculation
     */
    public class CollisionResult
    {
        public var distance:Number = 0;
        public var result:Boolean = false;
        
        public function CollisionResult(d:Number, r:Boolean)
        {
            this.distance = d;
            this.result = r;
        }
    }}