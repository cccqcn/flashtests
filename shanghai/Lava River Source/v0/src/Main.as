/**
 * Tomislav Podhraški
 * http://www.justpinegames.com
 */

package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import starling.core.Starling;

	public class Main extends Sprite 
	{
		private var _starling:Starling;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// Setup Starling
			_starling = new Starling(LavaRiver, stage);
			_starling.start();			
		}
	}
}