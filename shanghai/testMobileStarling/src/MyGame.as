package
{
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.StarlingContext;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MyGame extends Sprite
	{
		private var _starlingContext:StarlingContext;
		
		public function MyGame()
		{
			super();
			
			_starlingContext = new MyStarlingGameContext(this);
			
			
			setTimeout(addUI, 1000);
		}
		private function addUI():void
		{
   			var secondView:SecondView = new SecondView();
			addChild(secondView);
			
			// Test mediator removal
//			setTimeout(secondView.parent.removeChild, 3000, secondView);
			
		}
	}
}