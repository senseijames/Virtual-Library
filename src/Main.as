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
        protected static const VERSION:String = '0.0.2';
        protected static const FILE_SEARCH_DEPTH:uint = 3;
        protected static const SHOW_HIDDEN:Boolean = false;
        protected static const IS_LOOSE_PACK:Boolean = true;
        
        
        public function Main() 
        {
            trace_boilerplate();
            
            run();
            
            run_tests();
        }
        
        protected function run():void
        {
            var container:Sprite = new Sprite();
            addChild(container);
            var virtual_library_controller:VirtualLibraryController = new VirtualLibraryController();
            virtual_library_controller.init(container, {depth: FILE_SEARCH_DEPTH, show_hidden: SHOW_HIDDEN, is_loose_pack: IS_LOOSE_PACK });
        }

        protected function trace_boilerplate():void
        {
            trace('\n\nVirtual Library version', VERSION);
            trace('* * * * * * * * * * * * * * * * * * * * * *\n');            
        }
        
        protected function test_alternativa_engine():void
        {
            var engine:AlternativaEngine = new AlternativaEngine({ width: stage.stageWidth, height: stage.stageHeight - VirtualLibraryController.CHROME_HEIGHT });
            addChild(engine);
        }
        
        protected function run_tests():void
        {
            test_alternativa_engine();
//            var file_api_test:FileApiTest = new FileApiTest();
        }
   }
}