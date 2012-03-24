package
{
    public class VirtualLibraryConfig
    {
        public static const VERSION:String = '3D Engine Prototype v. 0.2.0 (Console Prototype 2.0 Complete)';
        public static const FILE_SEARCH_DEPTH : uint = 4;
        public static const SHOW_HIDDEN : Boolean = false;
        public static const IS_LOOSE_PACK : Boolean = true;
        public static const USE_WEBCAM : Boolean = false;
        public static const WEBCAM_ACTIVITY_LEVEL : uint = 15;
        public static const WEBCAM_ACTIVITY_TIME : uint = 250;
        public static const WEBCAM_SHOW_VIDEO : Boolean = true;


        public function VirtualLibraryConfig(chastity_belt:SingletonEnforcer) { }
    }
}

class SingletonEnforcer { }