package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[SWF(width="1000",height="600", frameRate="30")]
	public class testSpriteRender extends Sprite
	{
		private var all:Array = [];
		private var last:Date;
		private var now:Date;
		private var bitmap:Bitmap;
		public function testSpriteRender()
		{
			var ld:Loader = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onload);
			ld.load(new URLRequest("image 1.png"));
		}
		private function onload(e:Event):void
		{
			var i:int;
			var sp:Sprite;
			var go:gobject;
			for(i=0;i<1000;i++)
			{
				sp = new Sprite;
				addChild(sp);
				go = new gobject(Bitmap(LoaderInfo(e.currentTarget).content).bitmapData, 25, sp);
				sp.x = Math.random()*800;
				sp.y = Math.random()*450;
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
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Point;
import flash.geom.Rectangle;

class gobject 
{
	private var source:BitmapData;
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
		this.sp = sp;
		source = bitmap.clone();
		this.frames = frames;
		frameWidth = source.width / this.frames;
		bmd = new BitmapData(source.width / frames, source.height);
		sp.graphics.clear();
		sp.graphics.beginBitmapFill(bmd);
		sp.graphics.drawRect(0, 0, source.width / frames, source.height);
		sp.graphics.endFill();
	}
	public function draw(d:Number):void
	{
		frameTime += d;
		while (frameTime > 1/frames)
		{
			frameTime -= 1/frames;
			currentFrame = (currentFrame + 1) % frames;
		}
		bmd.fillRect(bmd.rect, 0x0);
		bmd.copyPixels(source, new Rectangle(currentFrame * frameWidth, 0, frameWidth, bmd.height), new Point(0, 0));
	}
}