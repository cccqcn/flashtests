package
{
	import feathers.examples.componentsExplorer.Main;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	public class testFethersUI extends Sprite
	{
		private var _starling:Starling;
		
		public function testFethersUI()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
		protected function onAddedToStage(event:Event):void
		{
			var stageWidth:int   = 480;
			var stageHeight:int  = 640;
			
			var scale:Number = 1;
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenHeight, stage.fullScreenWidth), 
				ScaleMode.SHOW_ALL);
			var scaleFactor:int = viewPort.width < 480 ? 1 : 2; // midway between 320 and 640
			//			Starling.handleLostContext = true;
			//			Starling.multitouchEnabled = true;
			_starling = new Starling(Main, stage );
			this._starling.stage.stageWidth = stage.stageWidth;
			this._starling.stage.stageHeight = stage.stageHeight;
			_starling.start();
			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
			//			setTimeout(addUI, 1000);
		}
		private function stage_resizeHandler(event:Event):void
		{
			
			this._starling.stage.stageWidth = this.stage.stageWidth;
			this._starling.stage.stageHeight = this.stage.stageHeight;
			
			const viewPort:Rectangle = this._starling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
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