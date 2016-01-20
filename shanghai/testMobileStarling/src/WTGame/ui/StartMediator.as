package WTGame.ui
{
	import WTGame.managers.GameManager;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.events.Event;
	
	public class StartMediator extends StarlingMediator
	{
		[Inject]
		public var view:StartView;
		
		[Inject]
		public var game:GameManager;
		
		override public function onRegister():void
		{
			view.addEventListener(Event.TRIGGERED, onButtonTriggered);
		}
		private function onButtonTriggered(e:Event):void
		{
			if(e.target == view.startBtn)
			{
				game.start();
			}
			else if(e.target == view.settingBtn)
			{
				game.toggleSetting();
			}
		}
		override public function onRemove():void
		{
			view.removeEventListener(Event.TRIGGERED, onButtonTriggered);
		}
	}
}