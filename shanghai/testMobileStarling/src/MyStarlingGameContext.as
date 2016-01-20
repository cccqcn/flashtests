package
{
	import org.robotlegs.mvcs.StarlingContext;
	
	import starling.display.DisplayObjectContainer;
	
	public class MyStarlingGameContext extends StarlingContext
	{
		public function MyStarlingGameContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		
		override public function startup():void
		{
//			mediatorMap.mapView(MyGame, MyGameMediator);
			mediatorMap.mapView(SecondView, SecondViewMediator);
			
//			commandMap.mapEvent(FlashEvent.EVENT_NAME, EventCommand);
			
			super.startup();
		}
	}
}