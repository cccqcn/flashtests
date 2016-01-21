/**
 * Tomislav Podhraški
 * http://www.justpinegames.com
 */

 // QuadricBezierCurve.as represents Bezier curve using a vector of points
 
package  
{
	import flash.geom.Point;
	
	public class QuadricBezierCurve 
	{
		private var _nodes:Vector.<CurveNode>;
		
		public function QuadricBezierCurve() 
		{
			_nodes = new Vector.<CurveNode>;
		}
		
		public function add(positionX:Number, positionY:Number, controlX:Number = 0, controlY:Number = 0):CurveNode
		{
			var position:Point = new Point(positionX, positionY);
			var control:Point = new Point(controlX, controlY);
			
			var newNode:CurveNode = new CurveNode(position, control);
			
			_nodes.push(newNode);
			
			return newNode;
		}
		
		private function quadraticBezier(P0:Point, P1:Point, control:Point, t:Number):Point
        {
			// Calculate point that results form quadratic Bezier expression
			var resultX:Number = (1 - t) * (1 - t) * P0.x + (2 - 2 * t) * t * control.x + P1.x * t * t;
			var resultY:Number = (1 - t) * (1 - t) * P0.y + (2 - 2 * t) * t * control.y + P1.y * t * t;
			
            return new Point(resultX, resultY);
        }
		
		public function convertToPoints(quality:Number = 60):Vector.<Point>
		{
			var points:Vector.<Point> = new Vector.<Point>();
			
			var precision:Number = 1 / quality;
			
			// Pass through all nodes to generate line segments
			for (var i:int = 0; i < _nodes.length - 1; i++)
			{
				var current:CurveNode = _nodes[i];
				var next:CurveNode = _nodes[i + 1];
				
				// Between 2 nodes approximate Bezier curve using a custom number of steps
				for (var step:Number = 0; step < 1; step += precision)
				{
					var newPoint:Point = quadraticBezier(current.position, next.position, current.control, step);
					points.push(newPoint);
				}
			}

			var finalPoint:Point = quadraticBezier(current.position, next.position, current.control, 1);
			points.push(finalPoint);
			
			return points;
		}
		
		public function get nodes():Vector.<CurveNode> 
		{
			return _nodes;
		}
		
		// Calculate normal vector on provided line segment defined with points A and B
		private function lineSegmentNormal(A:Point, B:Point):Point
		{
			// Notice that point components are reversed! (y, x)
            var normal:Point = new Point(B.y - A.y, A.x - B.x);
            normal.normalize(1);
            return normal;
		}
		
		public function offsetedCurve(offset:Number):QuadricBezierCurve
		{
			var offseted:QuadricBezierCurve = new QuadricBezierCurve();
			
			// Iterate through all points
			for (var i:int = 0; i < _nodes.length; i++) {
				
				var normal:Point;
				var surfaceNormal:Point;
				
				if (i == 0) {
					// First point - take normal from first line segment	
					normal = lineSegmentNormal(_nodes[i].position, _nodes[i].control);
					surfaceNormal = lineSegmentNormal(_nodes[i].position, _nodes[i + 1].position);
				}
				else if (i + 1 == _nodes.length) {
					// Last point - take normal from last line segment
					normal = lineSegmentNormal(_nodes[i - 1].control, _nodes[i].position);
					surfaceNormal = lineSegmentNormal(_nodes[i - 1].position, _nodes[i].position);
				}
				else {
					// Middle point - take 2 normals from segments adjecent to the point, and interpolate them
					normal = lineSegmentNormal(_nodes[i].position, _nodes[i].control);
					normal = normal.add(lineSegmentNormal(_nodes[i - 1].control, _nodes[i].position));
					normal.normalize(1);
					
					// This couses a slight visual issue for thicker rivers
					// It can be avoided by adding more nodes
					surfaceNormal = lineSegmentNormal(_nodes[i].position, _nodes[i + 1].position);
				}
				
				offseted.add(
					_nodes[i].position.x + normal.x * offset, _nodes[i].position.y + normal.y * offset,
					_nodes[i].control.x + surfaceNormal.x * offset, _nodes[i].control.y + surfaceNormal.y * offset
				);
			}
			
			return offseted;
		}
	}
}