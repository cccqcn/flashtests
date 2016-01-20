package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.StarlingContext;
	
	import starling.core.Starling;
	
	[SWF(width = 800, height = 600, frameRate = 20, backgroundColor = 0xDDDDDD)]
	public class testStarlingRobotlegs extends Sprite
	{
		private var _starling:Starling;
		private var _starlingContext:StarlingContext;
		
		public function testStarlingRobotlegs()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			Starling.handleLostContext = true;
			Starling.multitouchEnabled = true;
			_starling = new Starling(MyGame, stage);
			_starling.start();
			
//			this.stage.addEventListener(Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			this.stage.addEventListener(Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
			setTimeout(addUI, 1000);
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
		private function addUI():void
		{
			var ui:UiView = new UiView;
			addChild(ui);
		}
	}
}