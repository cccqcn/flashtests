/**
 * Tomislav Podhraški
 * http://www.justpinegames.com
 */

// CurveNode.as Stores curve node: position and control points

package  
{
	import flash.geom.Point;
	
	public class CurveNode 
	{
		private var _position:Point;
		private var _control:Point;
		
		public function CurveNode(position:Point, control:Point) 
		{
			_position = position;
			_control = control;
		}
		
		public function get position():Point 
		{
			return _position;
		}
		
		public function set position(value:Point):void 
		{
			_position = value;
		}
		
		public function get control():Point 
		{
			return _control;
		}
		
		public function set control(value:Point):void 
		{
			_control = value;
		}
	}
}