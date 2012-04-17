package vui.ui
{
    /**
    * Feels like a good public I/F for any InteractiveObject.
    */
    public interface IBeInteractive
    {
        function init (options:Object) : void;
        
        function enable (options:Object) : void;
        
        function disable (options:Object) : void;
        
        function teardown (options:Object) : void;
    }
}