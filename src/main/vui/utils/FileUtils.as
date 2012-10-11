package vui.utils
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.filesystem.File;

    public class FileUtils
    {
        public function FileUtils () //chastity_belt:SingletonEnforcer)
        {
        }
        
        public static function get_icon (file:File, max_height:uint = 0, is_power_of_two:Boolean = false) : Bitmap
        {
            var file_icon_bitmap_datas:Array = file.icon.bitmaps;
            var smallest_bitmap_data:BitmapData = file_icon_bitmap_datas[0];
            var bitmap_data:BitmapData = new BitmapData(1, 1);
            for (var i:uint = 0; i < file_icon_bitmap_datas.length; i++)
            {
                if (is_power_of_two && !MathUtils.is_power_of_two(file_icon_bitmap_datas[i].height)) {
                    continue;
                }
                
                if (file_icon_bitmap_datas[i].height > bitmap_data.height && 
                    file_icon_bitmap_datas[i].height <= max_height) {
                    bitmap_data = file_icon_bitmap_datas[i];
                }
                if (file_icon_bitmap_datas[i].height < smallest_bitmap_data.height) {
                    smallest_bitmap_data = file_icon_bitmap_datas[i];
                }
            }
            
            return new Bitmap((bitmap_data.height > 1) ? bitmap_data : smallest_bitmap_data);
        }
        
    }
}

//class SingletonEnforcer { }