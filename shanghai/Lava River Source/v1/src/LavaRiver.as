/**
 * Tomislav Podhraški
 * http://www.justpinegames.com
 */

// LavaRiver.as main Starling class used to setup the demo
 
package  
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;

	public class LavaRiver extends Sprite
	{
		[Embed(source="../../FinalBackground.png")]
		private var BackgroundBitmap:Class;
		
		[Embed(source="../../FinalRock.png")]
		private var RockBitmap:Class;
		
		private var _debugInterface:Interface;
		
		private var _riverCurve:QuadricBezierCurve;
		private var _river:River;
		
		private var _speed:Number;
		
		public function LavaRiver() 
		{
			_speed = 1;
			
			// Create river curve segements
			_riverCurve = new QuadricBezierCurve();
			_riverCurve.add( 114 , 90 , 183 , 25 );
			_riverCurve.add( 278 , 104 , 322 , 161 );
			_riverCurve.add( 287 , 241 , 275 , 375 );
			_riverCurve.add( 445 , 350 , 560 , 312 );
			_riverCurve.add( 621 , 416 );
			
			
			var backgroundImage:Image = new Image(Texture.fromBitmap(new BackgroundBitmap));
			this.addChild(backgroundImage);
		
			//
			// Create river object using bezier curve
			//
			_river = new River();
			_river.curve = _riverCurve;
			this.addChild(_river);

			
			// Create and add a foreground rock image
			var rockImage:Image = new Image(Texture.fromBitmap(new RockBitmap));
			this.addChild(rockImage);
			
			_debugInterface = new Interface();
			_debugInterface.curveToEdit = _riverCurve;
			_debugInterface.addEventListener(Interface.THICKNESS_CHANGED, thicknessChanged);
			_debugInterface.addEventListener(Interface.CURVE_CHANGED, curveChanged);
			this.addChild(_debugInterface);
		}
		
		private function thicknessChanged(e:Event):void
		{
			var thickness:Number = e.data.thickness;
			_river.thickness = thickness;
			trace("Thickness changed:", thickness);
		}
		
		private function curveChanged(e:Event):void
		{
			// Refresh the graphics
			_river.curve = _riverCurve;
		}
	}
}