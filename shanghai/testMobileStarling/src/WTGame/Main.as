package WTGame
{
	import WTGame.ui.StartView;
	import WTGame.utils.Stats;
	
	import flash.display.Stage;
	
	import org.robotlegs.mvcs.StarlingContext;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Main extends Sprite
	{
		[Embed(source = "/WTGame/assets/grass.jpg")]
		private var Background:Class;
		
		
		public static var stage:Stage;
		public static var starling:Starling;
		private var _starlingContext:StarlingContext;
		
		public function Main()
		{
			super();
			var bgTexture:Texture = Texture.fromBitmap(new Background());
			var backgroundImage:Image = new Image(bgTexture); 
			backgroundImage.blendMode = BlendMode.NONE;
			addChild(backgroundImage);
			
			_starlingContext = new WTGameContext(this);
			
			addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		private function onadd(e:Event):void
		{
			trace("on add main");
			var stats:Stats = new Stats;
			stats.x = 300;
			addChild(stats);
		}
	}
}