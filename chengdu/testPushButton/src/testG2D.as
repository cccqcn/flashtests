package
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.net.URLRequest;
	
	[SWF(width="1000",height="600", frameRate="30")]
	public class testG2D extends Sprite
	{
		private var ld:Loader;
		private var g2d:Sprite;
		
		public function testG2D()
		{
			ld = new Loader();
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadg2d);
			ld.load(new URLRequest("G2D.swf"));
			//ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadbmp);
			//ld.load(new URLRequest("testBmpRender.swf"));
			super();
		}
		private function onloadbmp(e:Event):void
		{
			g2d = Sprite(ld.content);
			addChild(g2d);
		}
		private function onloadg2d(e:Event):void
		{
			g2d = Sprite(ld.content);
			addChild(g2d);
			ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onloadg2d);
			ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadimg);
			ld.load(new URLRequest("image 1.png"));
		}
		private function onloadimg(e:Event):void
		{
			g2d["g2dapi"].start(1000, 600);
			var bitmap:Bitmap = Bitmap(ld.content);
			var i:int;
			var pos:Point;
			for(i=0;i<100;i++)
			{
				pos = new Point(Math.random()*800, Math.random()*450);
				g2d["g2dapi"].create("AnimatedGObject", {realpos:pos, bitmap:bitmap, fps:25, frames:25});
			}
		}
	}
}