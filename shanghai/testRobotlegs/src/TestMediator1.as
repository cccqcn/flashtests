package
{
	import org.robotlegs.mvcs.Mediator;
	
	public class TestMediator1 extends Mediator
	{
		
		[Inject]
		public var manager:Manager;
		
		public function TestMediator1()
		{
			super();
		}
		override public function onRegister():void
		{
			trace(222);
			manager.createTestView();
			mediatorMap.createMediator(manager.testView);
		}
		
	}
}