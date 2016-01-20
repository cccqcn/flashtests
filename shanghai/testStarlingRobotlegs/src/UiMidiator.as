package
{
	import org.robotlegs.mvcs.StarlingMediator;
	
	public class UiMidiator extends StarlingMediator
	{
		public function UiMidiator()
		{
			super();
		}
		
		override public function onRegister():void
		{
			trace("ui.onRegister()");
		}
		
		override public function onRemove():void
		{
			trace("ui.onRemove()");
		}
	}
}