package
{
	import WTGame.Constant;
	import WTGame.Main;
	import WTGame.utils.GraphicsUtils;
	
	import feathers.examples.layoutExplorer.screens.MainMenuScreen;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.StarlingContext;
	
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	[SWF(frameRate = 60, backgroundColor = 0x333333)]
	public class testMobileStarling extends Sprite
	{
		
		private var _starling:Starling;
		private var _starlingContext:StarlingContext;
		
		public function testMobileStarling()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			var stageWidth:int   = Constant.STAGE_WIDTH;
			var stageHeight:int  = Constant.STAGE_HEIGHT;
			
			var scale:Number = 1;
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenHeight, stage.fullScreenWidth), 
				ScaleMode.SHOW_ALL);
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
//			Starling.handleLostContext = true;
//			Starling.multitouchEnabled = true;
			Main.stage = stage;
			_starling = new Starling(Main, stage, viewPort);
			this._starling.stage.stageWidth = stageWidth;
			this._starling.stage.stageHeight = stageHeight;
			Main.starling = _starling;
			_starling.start();
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
//			setTimeout(addUI, 1000);
		}
		private function stage_resizeHandler(event:Event):void
		{
			
			var stageWidth:int   = Constant.STAGE_WIDTH;
			var stageHeight:int  = Constant.STAGE_HEIGHT;
			
			this._starling.stage.stageWidth = stageWidth;
			this._starling.stage.stageHeight = stageHeight;
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenHeight, stage.fullScreenWidth), 
				ScaleMode.SHOW_ALL);
			try
			{
				this._starling.viewPort = viewPort;
			}
			catch(error:Error) {}
		}
		
		private function stage_deactivateHandler(event:Event):void
		{
			this._starling.stop();
			this.stage.addEventListener(Event.ACTIVATE, stage_activateHandler, false, 0, true);
		}
		
		private function stage_activateHandler(event:Event):void
		{
			this.stage.removeEventListener(Event.ACTIVATE, stage_activateHandler);
			this._starling.start();
		}
	}
}