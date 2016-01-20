package WTGame.ui
{
	import WTGame.managers.GameManager;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.events.Event;
	
	public class EndMediator extends StarlingMediator
	{
		[Inject]
		public var view:EndView;
		
		[Inject]
		public var game:GameManager;
		
		override public function onRegister():void
		{
			view.addEventListener(Event.TRIGGERED, onButtonTriggered);
		}
		private function onButtonTriggered(e:Event):void
		{
			if(e.target == view.replayBtn)
			{
				game.stop();
				game.start();
			}
			if(e.target == view.backBtn)
			{
				game.resetGame();
			}
		}
		override public function onRemove():void
		{
			view.removeEventListener(Event.TRIGGERED, onButtonTriggered);
		}
	}
}