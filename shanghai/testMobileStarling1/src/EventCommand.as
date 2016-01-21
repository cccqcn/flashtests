package
{
	import org.robotlegs.mvcs.StarlingCommand;
	
	public class EventCommand extends StarlingCommand
	{
		public function EventCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			trace("EventCommand.execute()");
		}
	}
}