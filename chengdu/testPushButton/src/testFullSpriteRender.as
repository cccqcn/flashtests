package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[SWF(width="1000",height="600", frameRate="30")]
	public class testFullSpriteRender extends Sprite
	{
		private var all:Array = [];
		private var last:Date;
		private var now:Date;
		private var bmd:BitmapData;
		public function testFullSpriteRender()
		{
			var ld:Loader = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onload);
			ld.load(new URLRequest("image 1.png"));
		}
		private function onload(e:Event):void
		{
			var i:int;
			bmd = new BitmapData(1000, 600, false, 0x0);
			var sp:Sprite = new Sprite;
			sp.graphics.clear();
			sp.graphics.beginBitmapFill(bmd);
			sp.graphics.drawRect(0, 0, 1000, 600);
			sp.graphics.endFill();
			addChild(sp);
			var go:gobject;
			for(i=0;i<100;i++)
			{
				go = new gobject(Bitmap(LoaderInfo(e.currentTarget).content).bitmapData, 25);
				go.x = Math.random()*800;
				go.y = Math.random()*450;
				all.push(go);
			}
			this.addEventListener(Event.ENTER_FRAME, enter);
			now = new Date;
			last = new Date;
		}
		private function enter(e:Event):void
		{
			bmd.fillRect(bmd.rect, 0xFFFFFF);
			now = new Date;
			var d:Number = (now.getTime() - last.getTime())/1000.0;
			for each(var go:gobject in all)
			{
				go.draw(d, bmd);
			}
			last = now;
		}
	}
}
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

class gobject 
{
	private var source:BitmapData;
	private var bmd:BitmapData;
	private var frames:int;
	protected var frameTime:Number = 0;
	protected var currentFrame:int = 0;
	protected var frameWidth:int;
	public var x:int;
	public var y:int;
	public function gobject(bitmap:BitmapData, frames:int):void
	{
		source = bitmap.clone();
		this.frames = frames;
		frameWidth = source.width / this.frames;
		bmd = new BitmapData(source.width / frames, source.height);
	}
	public function draw(d:Number, buffer:BitmapData):void
	{
		frameTime += d;
		while (frameTime > 1/frames)
		{
			frameTime -= 1/frames;
			currentFrame = (currentFrame + 1) % frames;
		}
		buffer.copyPixels(source, new Rectangle(currentFrame * frameWidth, 0, frameWidth, bmd.height), new Point(x, y));
	}
}