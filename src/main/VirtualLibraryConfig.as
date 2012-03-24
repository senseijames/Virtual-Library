package
{
    public class VirtualLibraryConfig
    {
        public static const VERSION:String = 'Console Prototype v. 1.5 (0.1.5 - Webcam Support)';
        public static const FILE_SEARCH_DEPTH : uint = 4;
        public static const SHOW_HIDDEN : Boolean = false;
        public static const IS_LOOSE_PACK : Boolean = true;
        public static const USE_WEBCAM : Boolean = true;
        public static const WEBCAM_ACTIVITY_LEVEL : uint = 15;
        public static const WEBCAM_ACTIVITY_TIME : uint = 250;
        public static const WEBCAM_SHOW_VIDEO : Boolean = true;


        public function VirtualLibraryConfig(chastity_belt:SingletonEnforcer) { }
    }
}

class SingletonEnforcer { }