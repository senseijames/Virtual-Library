package vui.library.mapper
{
    import flash.filesystem.File;

    /*
    Model that the Controller uses to manage (CRUD) virtual folders.  
    The Controller also initializes and receives events from the Menu, which is populated with
    VirtualFolders (Dictionary okay?  String -> Vector.<File / VirtualDirectory>) sent back by the VirtualFolderMapper.
    Menu only receives content and displays it, and dispatches events to the controller to respond to appropriately.

    Main responsibility is CRUD of virtual folders - actually interacting with the file system, personal folder where
    that stuff is kept.
    
    
    */
    public class VirtualFolderMapper
    {
        protected var _application_storage : File;
        
        public function VirtualFolderMapper()
        {
            _application_storage = File.applicationStorageDirectory;
        }
    }
}