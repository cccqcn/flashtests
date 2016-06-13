package 
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author cccqcn
	 */
	public class Main extends Sprite 
	{
		
		private	var l:Loader = new Loader;
		public static var abc:Bitmap;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			l.load(new URLRequest("gif.png"));
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoad);
		}
		
		private function onLoad(e:Event):void
		{
			Main.abc = l.contentLoaderInfo.content;
			trace(Main.abc);
			var g:Game = new Game;
			addChild(g);
		}
		
	}
	
}