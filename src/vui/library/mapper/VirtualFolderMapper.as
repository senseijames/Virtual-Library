package vui.library.mapper
{
    import flash.filesystem.File;
    
    import vui.library.model.VirtualFolder;
    import vui.library.utils.FileWriter;

    /**
    * Mapper that the Controller uses to manage (CRUD) virtual folders; actually uses FileWriter to interact with the file system.
    * Each virtual folder is stored as a separate text file, with its member files as (newline delimited string) filepaths.
    */
    
    /*
    Responsibilities & Relationships...
    * The Controller initializes and receives events from the Menu, which is populated with VirtualFolders sent back by the VirtualFolderMapper.
    * The Menu only receives content and displays it, and dispatches events to the controller to respond to appropriately.
    */
    public class VirtualFolderMapper
    {
        public static const VIRTUAL_FOLDER_FILE_DELIMETER : String = "<VirtualFolderFileDelimeter>";
        protected static var _application_storage : File;
        protected static var _virtual_folders : Vector.<VirtualFolder>;
        
        public function VirtualFolderMapper(chastity_belt:SingletonEnforcer)
        {
        }
        
        public static function get folders():Vector.<VirtualFolder>
        {
            return _virtual_folders;
        }
        
        // TODO: Assumes init() has been called first.
        public static function get_folder(virtual_folder_name:String):VirtualFolder
        {
            for (var i:uint = 0; i < _virtual_folders.length; i++)
            {
                if (_virtual_folders[i].title == virtual_folder_name) {
                    return _virtual_folders[i];
                }
            }
            
            return null;
        }
        
        // TODO? - make protected so as to only be called internally?  I like that.
        public static function init():void
        {
            init_application_storage();
            
            _virtual_folders = new Vector.<VirtualFolder>();
            
            read_from_disk();
        }
        
        protected static function init_application_storage():void
        {
            _application_storage = File.applicationStorageDirectory.resolvePath('virtual_folders' + File.separator);
            if (!_application_storage.exists) {
                _application_storage.createDirectory();
            }
            
            trace('[VirtualFolderMapper] init: application storage directory is', _application_storage.nativePath, _application_storage.exists, '\n');
        }
        
        // Read the virtual folders from persistent storage and write them through to VirtualFolder models.
        protected static function read_from_disk():void
        {
            _virtual_folders.length = 0;
            
            // Persistent storage variables.
            var disk_virtual_folder_files:Array = _application_storage.getDirectoryListing();
            var disk_current_virtual_folder_text:String;
            var disk_current_virtual_folder_files:Array;
            // Runtime storage variables.
            var current_virtual_folder_files:Vector.<File>;
            var current_virtual_folder_file:File;
            
            for (var i:uint = 0; i < disk_virtual_folder_files.length; i++)
            {
                // Get the text and parse it.
                disk_current_virtual_folder_text = FileWriter.read(disk_virtual_folder_files[i]);
// TODO: null check                
                disk_current_virtual_folder_files = disk_current_virtual_folder_text.split(VIRTUAL_FOLDER_FILE_DELIMETER);
                current_virtual_folder_files = new Vector.<File>();
                for (var j:uint = 0; j < disk_current_virtual_folder_files.length; j++)
                {
                    current_virtual_folder_file = new File(disk_current_virtual_folder_files[j]);
                    current_virtual_folder_files.push(current_virtual_folder_file);
                }
                
                _virtual_folders.push(new VirtualFolder(disk_virtual_folder_files[i].name, current_virtual_folder_files));
            }
        }
        
        // Write through changes to the local (cached) virtual folders to persistent storage (the application storage directory).
        // TODO: Clear the application storage directory in a SAFE way; try moving them to a timestamped "backup" location before each flush()
        // so the user can recover them in the event of error (future feature).
        public static function flush():void
        {
            // Runtime storage variables.
            var current_virtual_folder:VirtualFolder;
            var current_virtual_folder_file:File;
            // Persistent storage variables.
            var current_virtual_folder_text:String;
            for (var i:uint = 0; i < _virtual_folders.length; i++)
            {
                current_virtual_folder = _virtual_folders[i];
                current_virtual_folder_text = "";
                for (var j:uint = 0; j < current_virtual_folder.contents.length; j++)
                {
                    if (j != 0) current_virtual_folder_text += VIRTUAL_FOLDER_FILE_DELIMETER;
                    current_virtual_folder_text += current_virtual_folder.contents[j].nativePath;
                }
                
                current_virtual_folder_file = new File(_application_storage.nativePath + File.separator + current_virtual_folder.title + ".txt");
                FileWriter.write(current_virtual_folder_file, current_virtual_folder_text);
            } 
        }
        
        
        // TODO: Test code - export.
        public static function get_test_folders():Vector.<VirtualFolder>
        {
            var test_file_set:Array = File.desktopDirectory.getDirectoryListing();
            var virtual_folders:Vector.<VirtualFolder> = new Vector.<VirtualFolder>(3);
            for (var i:uint = 0; i < 3; i++)
            {
                var folder:VirtualFolder = new VirtualFolder('test folder ' + i);
                for (var j:uint = 0; j < 10; j++)
                {
                    if (test_file_set[10 * i + j].isHidden) {
                        continue;
                    }
                    folder.add_file(test_file_set[10 * i + j]);
                }
                
                virtual_folders[i] = folder;
            }
            
            return virtual_folders;
        }
    }
}

class SingletonEnforcer { }