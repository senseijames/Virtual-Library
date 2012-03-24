package 
{
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getQualifiedClassName;
    
    import vui.library.controller.VirtualLibraryController;
    import vui.library.view.engine.VirtualLibraryEngine;
    import vui.utils.DisplayListUtils;

    // Note these are the dimensions of the stage itself.
    [SWF(backgroundColor = "0x909090", width = "800", height = "600")]
    public class Main extends Sprite
    {
        
        public function Main() 
        {
            trace_boilerplate();
            
            run();
            
            run_tests();
        }
        
        protected function run() : void
        {
            var container:Sprite = new Sprite();
            addChild(container);
            var virtual_library_controller:VirtualLibraryController = new VirtualLibraryController();
            virtual_library_controller.init(container, {depth: VirtualLibraryConfig.FILE_SEARCH_DEPTH, show_hidden: VirtualLibraryConfig.SHOW_HIDDEN, is_loose_pack: VirtualLibraryConfig.IS_LOOSE_PACK, 
                                                        use_webcam: VirtualLibraryConfig.USE_WEBCAM, webcam_activity_level: VirtualLibraryConfig.WEBCAM_ACTIVITY_LEVEL, webcam_activity_time: VirtualLibraryConfig.WEBCAM_ACTIVITY_TIME, 
                                                        webcam_show_video: VirtualLibraryConfig.WEBCAM_SHOW_VIDEO, webcam_show_activity : VirtualLibraryConfig.WEBCAM_SHOW_VIDEO });
        }

        
        /* * * * * * * * *
        * Testing (remove from production with conditional compilation)
        * * * * * * * * */
        
        protected function trace_boilerplate() : void
        {
            trace('\n\nVirtual Library version', VirtualLibraryConfig.VERSION);
            trace('* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *\n');            
        }
        protected function run_tests() : void
        {
//            test_alternativa_engine();
//            init_click_test();
        }
        protected function init_click_test() : void
        {
            stage.addEventListener(flash.events.MouseEvent.CLICK, function(e:Event) : void
                                                     {
                                                        trace('Clicked target', e.target, 'currentTarget', e.currentTarget, 'name', e.target.name, flash.utils.getQualifiedClassName(e.target));
                                                     });
        }
   }
}