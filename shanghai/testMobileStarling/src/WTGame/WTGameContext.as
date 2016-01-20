package WTGame
{
	import WTGame.managers.GameManager;
	import WTGame.model.GameModel;
	import WTGame.roles.Hole;
	import WTGame.roles.HoleMediator;
	import WTGame.roles.Worm;
	import WTGame.roles.WormMediator;
	import WTGame.ui.EndMediator;
	import WTGame.ui.EndView;
	import WTGame.ui.InGameMediator;
	import WTGame.ui.InGameView;
	import WTGame.ui.PausingMediator;
	import WTGame.ui.PausingView;
	import WTGame.ui.SettingMediator;
	import WTGame.ui.SettingView;
	import WTGame.ui.StartMediator;
	import WTGame.ui.StartView;
	import WTGame.ui.TestMediator;
	import WTGame.ui.TestView;
	
	import org.robotlegs.mvcs.StarlingContext;
	
	import starling.display.DisplayObjectContainer;
	
	public class WTGameContext extends StarlingContext
	{
		public function WTGameContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		override public function startup():void
		{
			injector.mapSingleton(GameModel);
			injector.mapSingleton(GameManager);
			
			mediatorMap.mapView(Worm, WormMediator);
			mediatorMap.mapView(Hole, HoleMediator);
			
			mediatorMap.mapView(StartView, StartMediator);
			mediatorMap.mapView(TestView, TestMediator);
			mediatorMap.mapView(InGameView, InGameMediator);
			mediatorMap.mapView(SettingView, SettingMediator);
			mediatorMap.mapView(PausingView, PausingMediator);
			mediatorMap.mapView(EndView, EndMediator);
			
			mediatorMap.mapView(Main, MainMediator);
			
			//			commandMap.mapEvent(FlashEvent.EVENT_NAME, EventCommand);
			
			super.startup();
		}
	}
}