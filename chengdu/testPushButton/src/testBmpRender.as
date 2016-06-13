package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[SWF(width="1000",height="600", frameRate="30")]
	public class testBmpRender extends Sprite
	{
		private var all:Array = [];
		private var last:Date;
		private var now:Date;
		private var bitmap:Bitmap;
		public function testBmpRender()
		{
			var ld:Loader = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onload);
			ld.load(new URLRequest("image 1.png"));
		}
		private function onload(e:Event):void
		{
			var i:int;
			var go:gobject;
			var sp:Sprite = new Sprite;
			var sp1:Sprite = new Sprite;
			sp1.addChild(sp);
			addChild(sp1);
			for(i=0;i<100;i++)
			{
				go = new gobject(Bitmap(LoaderInfo(e.currentTarget).content).bitmapData, 25, sp);
				all.push(go);
			}
			this.addEventListener(Event.ENTER_FRAME, enter);
			now = new Date;
			last = new Date;
		}
		private function enter(e:Event):void
		{
			now = new Date;
			var d:Number = (now.getTime() - last.getTime())/1000.0;
			for each(var go:gobject in all)
			{
				go.draw(d);
			}
			last = now;
		}
	}
}
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

class gobject 
{
	private var source:BitmapData;
	private var bmp:Bitmap;
	private var bmd:BitmapData;
	private var frames:int;
	private var sp:Sprite;
	protected var frameTime:Number = 0;
	protected var currentFrame:int = 0;
	protected var frameWidth:int;
	public var x:int;
	public var y:int;
	public function gobject(bitmap:BitmapData, frames:int, sp:Sprite):void
	{
		source = bitmap.clone();
		this.frames = frames;
		frameWidth = source.width / this.frames;
		bmd = new BitmapData(source.width / frames, source.height);
		bmp = new Bitmap();
		//bmp.cacheAsBitmap = true;
		bmp.bitmapData = bmd;
		x = Math.random()*800;
		y = Math.random()*450;
		bmp.x = x;
		bmp.y = y;
		sp.addChild(bmp);
	}
	public function draw(d:Number):void
	{
		frameTime += d;
		while (frameTime > 1/frames)
		{
			frameTime -= 1/frames;
			currentFrame = (currentFrame + 1) % frames;
		}
		bmd.copyPixels(source, new Rectangle(currentFrame * frameWidth, 0, frameWidth, bmd.height), new Point(0, 0));
		bmp.x = x;
		bmp.y = y;
	}
}