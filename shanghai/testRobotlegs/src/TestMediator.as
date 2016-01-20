package
{
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.Mediator;
	
	public class TestMediator extends Mediator
	{
		[Inject]
		public var view:TestView;
		
		[Inject]
		public var manager:Manager;
		
		
		public function TestMediator()
		{
			super();
		}
		override public function onRegister():void
		{
			trace(111);
		}
		private function create():void
		{
		}
	}
}