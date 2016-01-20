package
{
	import flash.display.DisplayObjectContainer;
	
	import org.robotlegs.mvcs.Context;
	
	public class Context extends org.robotlegs.mvcs.Context
	{
		public function Context(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
		{
			super(contextView, autoStartup);
		}
		override public function startup():void
		{
			injector.mapSingleton(Manager);
			var parserManager:Manager = injector.getInstance(Manager);
			
			mediatorMap.mapView(TestView, TestMediator, null, false, false);
			mediatorMap.mapView(TestView1, TestMediator1, null);
		}
	}
}