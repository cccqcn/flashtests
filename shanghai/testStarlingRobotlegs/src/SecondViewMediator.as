package
{
	import org.robotlegs.mvcs.StarlingMediator;
	
	public class SecondViewMediator extends StarlingMediator
	{
		public function SecondViewMediator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			trace("SecondViewMediator.onRegister()");
		}
		
		override public function onRemove():void
		{
			trace("SecondViewMediator.onRemove()");
		}
	}
}