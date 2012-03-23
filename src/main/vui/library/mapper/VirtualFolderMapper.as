package vui.library.mapper
{
    import flash.filesystem.File;
    
    import vui.library.model.VirtualFolder;
    import vui.utils.FileReaderWriter;

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
//            throw new Error('[VirtualFolderMapper] I am a singleton class, saving myself for marriage!');
        }
        
        public static function get folders():Vector.<VirtualFolder>
        {
            return _virtual_folders;
        }

        
        /* * * * * * * * * * *
        * Initialization
        * * * * * * * * * * */
        
        // TODO? - make protected so as to only be called internally?  I like that.
        public static function init():Vector.<VirtualFolder>
        {
            init_application_storage();
            
            _virtual_folders = new Vector.<VirtualFolder>();
            
            read_from_disk();
            
            return _virtual_folders;
        }
        
        protected static function init_application_storage():void
        {
            _application_storage = File.applicationStorageDirectory.resolvePath('virtual_folders' + File.separator);
            if (!_application_storage.exists) {
                _application_storage.createDirectory();
            }
            
            trace('[VirtualFolderMapper] init: application storage directory is', _application_storage.nativePath, _application_storage.exists, '\n');
        }
        
        
        
        /* * * * * * * * * * *
        * Read
        * * * * * * * * * * */
        
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
        
        
        /* * * * * * * * * * *
        * Write
        * * * * * * * * * * */
        public static function create_folder(virtual_folder_name:String, flush_to_disk:Boolean = true):VirtualFolder
        {
            trace('[Virtual Folder Mapper] Creating virtual folder with name:', virtual_folder_name);
            
            var new_folder:VirtualFolder = new VirtualFolder(virtual_folder_name);
            _virtual_folders.push(new_folder);
            
            if (flush_to_disk) {
                flush();                
            }
            
            return new_folder; 
        }
        
        public static function delete_folder(virtual_folder_name:String, flush_to_disk:Boolean = true):void
        {
            var target_folder:VirtualFolder = get_folder(virtual_folder_name);
            if (!target_folder) {
                return;
            }

            _virtual_folders.splice(_virtual_folders.indexOf(target_folder), 1);
            
            if (flush_to_disk) {
                flush();                
            }
        }
        
        public static function add_files_to_folder(virtual_folder_name:String, files:Vector.<File>, flush_to_disk:Boolean = true):void
        {
            var target_folder:VirtualFolder = get_folder(virtual_folder_name);
            if (!target_folder) {
                return;
            }

            for (var i:uint = 0; i < files.length; i++) {
                target_folder.add_file(files[i]);
            }
            
            if (flush_to_disk) {
                flush();                
            }
        }
        
        // public static function add_files_to_folder(virtual_folder_name:String, files:Vector.<File>):void
        
        public static function remove_files_from_folder(virtual_folder_name:String, files:Vector.<File>, flush_to_disk:Boolean = true):void
        {
            var target_folder:VirtualFolder = get_folder(virtual_folder_name);
            if (!target_folder) {
                return;
            }
            
            for (var i:uint = 0; i < files.length; i++) {
                target_folder.remove_file(files[i]);                
            }
            
            if (flush_to_disk) {
                flush();                
            }            
        }
        
        
        /* * * * * * * * * * *
        * Disk read/write
        * * * * * * * * * * */
        
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
                disk_current_virtual_folder_text = FileReaderWriter.read(disk_virtual_folder_files[i]);
// TODO: null check                
                disk_current_virtual_folder_files = disk_current_virtual_folder_text.split(VIRTUAL_FOLDER_FILE_DELIMETER);
                current_virtual_folder_files = new Vector.<File>();
                
                _virtual_folders.push(new VirtualFolder(get_virtual_folder_name_from_filename(disk_virtual_folder_files[i].name), current_virtual_folder_files));
                
                // Make sure the virtual folder is not empty.
                if (disk_current_virtual_folder_files.length && disk_current_virtual_folder_files[0] == "") {
                    continue;
                }
                    
                for (var j:uint = 0; j < disk_current_virtual_folder_files.length; j++)
                {
                    current_virtual_folder_file = new File(disk_current_virtual_folder_files[j]);
                    current_virtual_folder_files.push(current_virtual_folder_file);
                }
            }
        }
        
        // Just removes the file extension(s) from the input filename - substrings at first instance of "." so no regexing required.
        protected static function get_virtual_folder_name_from_filename(filename:String):String
        {
            if (filename.indexOf(".") != -1) {
                return filename.substring(0, filename.indexOf("."));
            }
                
            return filename;
        }
        
        // Write through changes to the local (cached) virtual folders to persistent storage (the application storage directory).
        // TODO: Clear the application storage directory in a SAFE way; try moving them to a timestamped "backup" location before each flush()
        // so the user can recover them in the event of error (future feature).
        public static function flush():void
        {
            backup_virtual_folders();
            delete_virtual_folders();
            
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
                FileReaderWriter.write(current_virtual_folder_file, current_virtual_folder_text);
            } 
        }
        
        protected static function backup_virtual_folders():void
        {
            trace('[Virtual Folder Mapper] Backing up virtual folders...');
        }
        protected static function delete_virtual_folders():void
        {
            trace('[Virtual Folder Mapper] Deleting virtual folders...');
            
            _application_storage.deleteDirectory(true);
            init_application_storage();
        }
    }
}

class SingletonEnforcer { }