package
{
    import test.FileApiTest;
    import view.engine.AlternativaEngine;

    import flash.display.Sprite;
    
    // Note these are the dimensions of the stage itself.
    [SWF(backgroundColor = "0x909090", width = "800", height = "600")]
    public class Main extends Sprite
    {        
        public function Main() 
        {
            run_tests();
        }
        
        protected function run_tests():void
        {
            var engine:AlternativaEngine = new AlternativaEngine();
            addChild(engine);
            
            var file_api_test:FileApiTest = new FileApiTest();
            
            trace('\nTesting now dude!');
        }
   }
}