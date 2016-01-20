package
{
	import org.robotlegs.core.IInjector;
	import org.robotlegs.mvcs.Actor;
	
	public class Manager extends Actor
	{
		
		public var testView:TestView;
		
		public function Manager()
		{
			super();
		}
		
		public function createTestView():void
		{
			testView = new TestView;
		}
	}
}