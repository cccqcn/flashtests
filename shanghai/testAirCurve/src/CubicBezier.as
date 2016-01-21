package
{
	import fl.motion.BezierSegment;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Point;

	public class CubicBezier
	{
		private static var _g:Graphics;
		private static function get g():Graphics
		{
			return _g;
		}
		
		private static function set g(g:Graphics):void
		{
			_g = g;
		}
		public static function drawCurve(ggg:Graphics, p1:Point, p2:Point, p3:Point, p4:Point):void
		{
			g = ggg;
			var bezier=new BezierSegment(p1, p2, p3, p4);
			g.moveTo(p1.x, p1.y);

			for (var t=.01; t < 1.01; t+=.01)
			{
				var val=bezier.getValue(t);
				g.lineTo(val.x, val.y);
			}
		}
		public static function curveThroughPoints(ggg:Graphics, points:Array /*of Points*/, z:Number=.5, angleFactor:Number=.75, moveTo:Boolean=true):void
		{
			g = ggg;
			recordpoints = [];
			try
			{
				var p:Array=points.slice(); // Local copy of points array		
				var duplicates:Array=new Array(); // Array to hold indices of duplicate points	
				// Check to make sure array contains only Points			
				for (var i=0; i < p.length; i++)
				{
					if (!(p[i] is Point))
					{
						throw new Error("Array must contain Point objects");
					}
					// Check for the same point twice in a row					
					if (i > 0)
					{
						if (p[i].x == p[i - 1].x && p[i].y == p[i - 1].y)
						{
							duplicates.push(i); // add index of duplicate to duplicates array
						}
					}
				}
				// Loop through duplicates array and remove points from the points array				
				for (i=duplicates.length - 1; i >= 0; i--)
				{
					p.splice(duplicates[i], 1);
				}
				// Make sure z is between 0 and 1 (too messy otherwise)				
				if (z <= 0)
				{
					z=.5;
				}
				else if (z > 1)
				{
					z=1;
				}
				// Make sure angleFactor is between 0 and 1		
				if (angleFactor < 0)
				{
					angleFactor=0;
				}
				else if (angleFactor > 1)
				{
					angleFactor=1;
				} //				// First calculate all the curve control points				// 				// None of this junk will do any good if there are only two points				
				if (p.length > 2)
				{
					// Ordinarily, curve calculations will start with the second point and go through the second-to-last point
					var firstPt=1;
					var lastPt=p.length - 1;
					// Check if this is a closed line (the first and last points are the same)					
					if (p[0].x == p[p.length - 1].x && p[0].y == p[p.length - 1].y)
					{
						// Include first and last points in curve calculations						
						firstPt=0;
						lastPt=p.length;
					}
					var controlPts:Array=new Array(); // An array to store the two control points (of a cubic Bézier curve) for each point
					// Loop through all the points (except the first and last if not a closed line) to get curve control points for each.	
					for (i=firstPt; i < lastPt; i++)
					{
						// The previous, current, and next points					
						var p0=(i - 1 < 0) ? p[p.length - 2] : p[i - 1]; // If the first point (of a closed line), use the second-to-last point as the previous point
						var p1=p[i];
						var p2=(i + 1 == p.length) ? p[1] : p[i + 1]; // If the last point (of a closed line), use the second point as the next point		
						var a=Point.distance(p0, p1); // Distance from previous point to current point						
						if (a < 0.001)
							a=.001; // Correct for near-zero distances, a cheap way to prevent division by zero						
						var b=Point.distance(p1, p2); // Distance from current point to next point						
						if (b < 0.001)
							b=.001;
						var c=Point.distance(p0, p2); // Distance from previous point to next point						
						if (c < 0.001)
							c=.001;
						var cos=(b * b + a * a - c * c) / (2 * b * a);
						// Make sure above value is between -1 and 1 so that Math.acos will work	
						if (cos < -1)
							cos=-1;
						else if (cos > 1)
							cos=1;
						var C=Math.acos(cos);
						// Angle formed by the two sides of the triangle (described by the three points above) adjacent to the current point						// Duplicate set of points. Start by giving previous and next points values RELATIVE to the current point.						
						var aPt=new Point(p0.x - p1.x, p0.y - p1.y);
						var bPt=new Point(p1.x, p1.y);
						var cPt=new Point(p2.x - p1.x, p2.y - p1.y);
						if (a > b)
						{
							aPt.normalize(b); // Scale the segment to aPt (bPt to aPt) to the size of b (bPt to cPt) if b is shorter.					
						}
						else if (b > a)
						{
							cPt.normalize(a); // Scale the segment to cPt (bPt to cPt) to the size of a (aPt to bPt) if a is shorter.		
						}

						aPt.offset(p1.x, p1.y);
						cPt.offset(p1.x, p1.y);

						var ax=bPt.x - aPt.x; // x component of the segment from previous to current point					
						var ay=bPt.y - aPt.y;
						var bx=bPt.x - cPt.x; // x component of the segment from next to current point						
						var by=bPt.y - cPt.y;
						var rx=ax + bx; // sum of x components						
						var ry=ay + by;

						if (rx == 0 && ry == 0)
						{
							rx=-bx; // Really not sure why this seems to have to be negative							
							ry=by;
						}

						if (ay == 0 && by == 0)
						{
							rx=0;
							ry=1;
						}
						else if (ax == 0 && bx == 0)
						{
							rx=1;
							ry=0;
						}
						var r=Math.sqrt(rx * rx + ry * ry); // length of the summed vector - not being used, but there it is anyway						
						var theta=Math.atan2(ry, rx); // angle of the new vector 						

						var controlDist=Math.min(a, b) * z;
						var controlScaleFactor=C / Math.PI;
						controlDist*=((1 - angleFactor) + angleFactor * controlScaleFactor); // Mess with this for some fine-tuning						
						var controlAngle=theta + Math.PI / 2;
						var controlPoint2=Point.polar(controlDist, controlAngle); // Control point 2, curving to the next point.						
						var controlPoint1=Point.polar(controlDist, controlAngle + Math.PI);

						controlPoint1.offset(p1.x, p1.y);
						controlPoint2.offset(p1.x, p1.y);
						if (Point.distance(controlPoint2, p2) > Point.distance(controlPoint1, p2))
						{
							controlPts[i]=new Array(controlPoint2, controlPoint1); // Add the two control points to the array in reverse order						
						}
						else
						{
							controlPts[i]=new Array(controlPoint1, controlPoint2);
						}
					}
					if (moveTo)
					{
						gMoveTo(g, p[0].x, p[0].y);
					}
					else
					{
						gLineTo(g, p[0].x, p[0].y);
					}
					if (firstPt == 1)
					{ // irst control point of the second point						
						gCurveTo(g, controlPts[1][0].x, controlPts[1][0].y, p[1].x, p[1].y);
					}
					var straightLines:Boolean=true; // Change trather than curves. You'll get straight lines but possible sharp corners!		
					for (i=firstPt; i < lastPt - 1; i++)
					{ // Determine if multiple points in a row are in a straight line			
						var isStraight:Boolean=((i > 0 && Math.atan2(p[i].y - p[i - 1].y, p[i].x - p[i - 1].x) == Math.atan2(p[i + 1].y - p[i].y, p[i + 1].x - p[i].x)) || (i < p.length - 2 && Math.atan2(p[i + 2].y - p[i + 1].y, p[i + 2].x - p[i + 1].x) == Math.atan2(p[i + 1].y - p[i].y, p[i + 1].x - p[i].x)));
						if (straightLines && isStraight)
						{
							gLineTo(g, p[i + 1].x, p[i + 1].y);
						}
						else
						{ // BezierSegment 							
							var bezier:BezierSegment=new BezierSegment(p[i], controlPts[i][1], controlPts[i + 1][0], p[i + 1]);
							for (var t=.01; t < 1.01; t+=.01)
							{
								var val=bezier.getValue(t); // x,y on the curve for a given t					
								gLineTo(g, val.x, val.y);
							}
						}
					} // If this isn't a closed line					
					if (lastPt == p.length - 1)
					{
						gCurveTo(g, controlPts[i][1].x, controlPts[i][1].y, p[i + 1].x, p[i + 1].y);
					} // just draw a line if only two points				
				}
				else if (p.length == 2)
				{
					gMoveTo(g, p[0].x, p[0].y);
					gLineTo(g, p[1].x, p[1].y);
				}
			} // Catch error			
			catch (e)
			{
				trace(e.getStackTrace());
			}
		}
		public static var recordpoints:Array = [];
		private static function gMoveTo(g:Graphics, xx:Number, yy:Number):void
		{
			recordpoints.push({type:"move", x:xx, y:yy});
			g.moveTo(xx, yy);
		}
		private static function gLineTo(g:Graphics, xx:Number, yy:Number):void
		{
			recordpoints.push({type:"line", x:xx, y:yy});
			g.lineTo(xx, yy);
//			TweenLite.to(box, 500, {x:xx, y:yy});
		}
		private static function gCurveTo(g:Graphics, cx:Number, cy:Number, ax:Number, ay:Number):void
		{
			recordpoints.push({type:"curve", ax:ax, ay:ay, cx:cx, cy:cy});
			g.curveTo(cx, cy, ax, ay);
//			gLineTo(box, xx, yy);
		}
	}
}