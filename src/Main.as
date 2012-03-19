package 
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getQualifiedClassName;
    
    import vui.library.controller.VirtualLibraryController;
    import vui.library.view.engine.AlternativaEngine;

    // Note these are the dimensions of the stage itself.
    [SWF(backgroundColor = "0x909090", width = "800", height = "600")]
    public class Main extends Sprite
    {
        protected static const VERSION:String = '0.0.9 (Console Prototype v. 0.9)';
        protected static const FILE_SEARCH_DEPTH : uint = 4;
        protected static const SHOW_HIDDEN : Boolean = false;
        protected static const IS_LOOSE_PACK : Boolean = true;
        
        
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

        
        /* * * * * * * * *
        * Testing (remove from production with conditional compilation)
        * * * * * * * * */
        
        protected function trace_boilerplate():void
        {
            trace('\n\nVirtual Library version', VERSION);
            trace('* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\n');            
        }
        
        protected function test_alternativa_engine():void
        {
            var engine:AlternativaEngine = new AlternativaEngine({ width: stage.stageWidth, height: stage.stageHeight - VirtualLibraryController.CHROME_HEIGHT });
            addChild(engine);
        }
        
        protected function run_tests():void
        {
            test_alternativa_engine();
//            init_click_test();
            
            // Put the container foremost in the display list.
            setChildIndex(getChildAt(0), numChildren - 1);
        }
        
        protected function init_click_test():void
        {
            stage.addEventListener(flash.events.MouseEvent.CLICK, function(e:Event):void
                                                     {
                                                        trace('Clicked target', e.target, 'currentTarget', e.currentTarget, 'name', e.target.name, flash.utils.getQualifiedClassName(e.target));
                                                     });
        }
   }
}