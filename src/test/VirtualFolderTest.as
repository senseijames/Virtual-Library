package test
{
    import vui.library.model.VirtualFolder;
    
    
    public class VirtualFolderTest
    {
        public function VirtualFolderTest()
        {
        }
        
        
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