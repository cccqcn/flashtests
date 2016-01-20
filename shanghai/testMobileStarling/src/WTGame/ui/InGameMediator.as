package WTGame.ui
{
	import WTGame.Constant;
	import WTGame.managers.GameManager;
	import WTGame.model.GameModel;
	
	import flash.events.Event;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.events.Event;
	
	public class InGameMediator extends StarlingMediator
	{
		[Inject]
		public var view:InGameView;
		
		[Inject]
		public var game:GameManager;
		
		[Inject]
		public var model:GameModel;
		
		override public function onRegister():void
		{
			view.addEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
			this.addContextListener(Constant.EVENT_WORM_ENTER, addWorm, flash.events.Event);
		}
		private function onButtonTriggered(e:starling.events.Event):void
		{
			if(e.target == view.pauseBtn)
			{
				game.pause();
			}
		}
		private function addWorm(e:flash.events.Event):void
		{
			view.wormNums.text = "Worms:" + model.score;
		}
		override public function onRemove():void
		{
			view.removeEventListener(starling.events.Event.TRIGGERED, onButtonTriggered);
		}
	}
}