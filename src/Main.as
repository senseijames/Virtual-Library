package
{
    import controller.VirtualLibraryController;
    
    import flash.display.Sprite;
    
    import test.FileApiTest;
    
    import view.engine.AlternativaEngine;
    

    
    // Note these are the dimensions of the stage itself.
    [SWF(backgroundColor = "0x909090", width = "800", height = "600")]
    public class Main extends Sprite
    {
        protected static const VERSION:String = '0.0.1';
        
        
        public function Main() 
        {
            var container:Sprite = new Sprite();
            var virtual_library_controller:VirtualLibraryController = new VirtualLibraryController();
            virtual_library_controller.init(container, {});
            virtual_library_controller.run();
            
            test_alternativa_engine();
        }

        protected function trace_boilerplate():void
        {
            trace('\nVirtual Library version', VERSION);
            trace('* * * * * * * * * * * * * * * * * * * * * *\n');            
        }
        
        protected function test_alternativa_engine():void
        {
            var engine:AlternativaEngine = new AlternativaEngine();
            addChild(engine);
        }
        
        protected function run_tests():void
        {
            test_alternativa_engine();
            
//            var file_api_test:FileApiTest = new FileApiTest();
            
            trace('\nTesting now dude!');
        }
   }
}