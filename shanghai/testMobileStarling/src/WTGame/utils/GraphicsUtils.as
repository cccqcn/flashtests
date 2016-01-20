package WTGame.utils
{
	import WTGame.Main;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class GraphicsUtils
	{
		public static var drawsp:Sprite = new Sprite;
		public static var box:Shape = new Shape;
		
		
		
		public static function getWorm(color:uint = 0x0, size:int = 12):BitmapData
		{
			trace("newWorm");
			var ww:int = Main.stage.stageWidth / size;
			box.graphics.clear();
			box.graphics.lineStyle(1, color);
			box.graphics.beginFill(color, 1);
			box.graphics.drawRect(0, 0, ww, ww);
			box.graphics.drawCircle(ww, ww / 2, ww / 2);
			box.graphics.endFill();
			var bmd:BitmapData = new BitmapData(ww * 1.5, ww, true, 0);
			bmd.draw(box);
			return bmd;
		}
		public static function getHole(color:uint = 0x0):BitmapData
		{
			var ww:int = Main.stage.stageWidth * 2 / 12;
			box.graphics.clear();
			box.graphics.lineStyle(3, color);
//			box.graphics.beginFill(0x0, 1);
			box.graphics.drawRect(1, 1, ww - 3, ww - 3);
//			box.graphics.endFill();
			var bmd:BitmapData = new BitmapData(ww, ww, true, 0);
			bmd.draw(box);
			return bmd;
		}
		public static function getButton(color:uint = 0x00FF00):BitmapData
		{
			var ww:int = Main.stage.stageWidth * 2 / 15;
			box.graphics.clear();
			box.graphics.lineStyle(3, color);
			box.graphics.beginFill(color, 1);
			box.graphics.drawRect(1, 1, ww - 3, (ww - 3) / 2);
			box.graphics.endFill();
			var bmd:BitmapData = new BitmapData(ww, ww / 2, true, 0);
			bmd.draw(box);
			return bmd;
		}
	}
}