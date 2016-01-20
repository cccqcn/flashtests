package WTGame
{
	import WTGame.managers.GameManager;
	import WTGame.model.GameModel;
	
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.events.Event;
	
	public class MainMediator extends StarlingMediator
	{
		[Inject]
		public var view:Main;
		
		[Inject]
		public var model:GameModel;
		
		[Inject]
		public var game:GameManager;
		
		override public function onRegister():void
		{
			game.init(view);
			this.addContextListener(Constant.EVENT_GAME_LOADED, onGameLoaded, flash.events.Event);
		}
		private function onGameLoaded(e:flash.events.Event):void
		{
			this.addViewListener(starling.events.Event.ENTER_FRAME, onEnterFrame, starling.events.Event);
			Main.stage.addEventListener(flash.events.Event.RESIZE, stage_resizeHandler, false, int.MAX_VALUE, true);
			Main.stage.addEventListener(flash.events.Event.DEACTIVATE, stage_deactivateHandler, false, 0, true);
		}
		private function onEnterFrame(e:starling.events.Event):void
		{
			model.debug.clear();
			if (model.handJoint.active) {
				model.handJoint.anchor1.setxy(Main.stage.mouseX, Main.stage.mouseY);
			}
			model.space.step(1 / 60);
			model.debug.draw(model.space);
			game.onEnterFrame(e);
		}
		private function stage_resizeHandler(event:flash.events.Event):void
		{
			Main.starling.stage.stageWidth = Main.stage.stageWidth;
			Main.starling.stage.stageHeight = Main.stage.stageHeight;
			
			const viewPort:Rectangle = Main.starling.viewPort;
			viewPort.width = Main.stage.stageWidth;
			viewPort.height = Main.stage.stageHeight;
			try
			{
				Main.starling.viewPort = viewPort;
			}
			catch(error:Error) {}
		}
		
		private function stage_deactivateHandler(event:flash.events.Event):void
		{
			Main.starling.stop();
			Main.stage.addEventListener(flash.events.Event.ACTIVATE, stage_activateHandler, false, 0, true);
			game.pause();
			trace("deactived");
		}
		
		private function stage_activateHandler(event:flash.events.Event):void
		{
			Main.stage.removeEventListener(flash.events.Event.ACTIVATE, stage_activateHandler);
			Main.starling.start();
//			game.resume();
		}
	}
}