package vui.library.utils
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    /**
    * Simple facade pattern for the File class - simplified I/F for read/write operations.
    */
    // TODO: Change the name of this class once I/F settles - "FileReaderWriter" ?
    public class FileWriter
    {
//        public static var _files:Vector.<File>;
        
        public function FileWriter(chastity_belt:SingletonEnforcer)
        {
        }
        
        public static function write(file:File, content:String):void
        {
            var file_stream:FileStream = new FileStream();
            file_stream.addEventListener(Event.COMPLETE, function(e:Event):void
                                                        {
trace('\ntrying to write',content,'to file',file.nativePath);                
                                                            file_stream.writeUTF(content);
                                                            file_stream.close();                
                                                        });
            file_stream.addEventListener(IOErrorEvent.IO_ERROR, trace);
            file_stream.openAsync(file, FileMode.UPDATE);
        }

        // TODO: Consider making this asynchronous and dispatching an event whose member is the text.
        public static function read(file:File):String
        {
            var file_stream:FileStream = new FileStream();
            file_stream.open(file, FileMode.READ);
            var text:String = file_stream.readUTF();
            file_stream.close();
            
            return text;
        }
    }
}

class SingletonEnforcer { }