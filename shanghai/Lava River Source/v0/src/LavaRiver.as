/**
 * Tomislav Podhraški
 * http://www.justpinegames.com
 */

package  
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;

	public class LavaRiver extends Sprite
	{
		[Embed(source="../../FinalBackground.png")]
		private var BackgroundBitmap:Class;
		
		[Embed(source="../../FinalRock.png")]
		private var RockBitmap:Class;
		
		private var _debugInterface:Interface;
		
		public function LavaRiver() 
		{
			// Create and add a background image
			var backgroundImage:Image = new Image(Texture.fromBitmap(new BackgroundBitmap));
			this.addChild(backgroundImage);

			// Create and add a foreground rock image
			var rockImage:Image = new Image(Texture.fromBitmap(new RockBitmap));
			this.addChild(rockImage);
			
			_debugInterface = new Interface();
			_debugInterface.addEventListener(Interface.THICKNESS_CHANGED, thicknessChanged);
			_debugInterface.addEventListener(Interface.SPEED_CHANGED, speedChanged);
			this.addChild(_debugInterface);
		}
		
		private function thicknessChanged(e:Event):void
		{
			var thickness:Number = e.data.thickness;
			trace("Thickness changed:", thickness);
		}
		
		private function speedChanged(e:Event):void
		{
			var speed:Number = e.data.speed;
			trace("Speed changed:", speed);
		}
	}
}