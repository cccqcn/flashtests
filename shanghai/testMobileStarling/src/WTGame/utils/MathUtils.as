package WTGame.utils
{
	import WTGame.roles.Role;
	
	import com.greensock.motionPaths.LinePath2D;
	
	import flash.geom.Point;

	public class MathUtils
	{
		public static function getPointIndexByProgress(path:LinePath2D, progress:Number):int
		{
			var i:int;
			var arr:Array = path.points;
			var dis:Number = 0;
			var total:Number = path.totalLength;
			for(i=0;i<arr.length - 1;i++)
			{
				var xx:Number = Math.abs(arr[i+1].x - arr[i].x);
				var yy:Number = Math.abs(arr[i+1].y - arr[i].y);
				dis += Math.sqrt(xx * xx + yy * yy);
				if(dis / total > progress)
				{
					return i+1;
				}
			}
			return path.points.length - 1;
		}
		
		public static function getLength(p1:Point, p2:Point):Number
		{
			return Math.sqrt(Math.pow(Math.abs(p1.x - p2.x), 2) + Math.pow(Math.abs(p1.y - p2.y), 2));
		}
		public static function getLength2(p1x:Number, p1y:Number, p2x:Number, p2y:Number):Number
		{
			return Math.sqrt(Math.pow(Math.abs(p1x - p2x), 2) + Math.pow(Math.abs(p1y - p2y), 2));
		}
		public static function getPointsLength(arr:Array):int
		{
			var i:int;
			var dis:Number = 0;
			for(i=0;i<arr.length - 1;i++)
			{
				var xx:Number = Math.abs(arr[i+1].x - arr[i].x);
				var yy:Number = Math.abs(arr[i+1].y - arr[i].y);
				dis += Math.sqrt(xx * xx + yy * yy);
			}
			return dis;
		}
		
		public function containPoint(r:Role, p:Point):Boolean
		{
			return r.collisionArea.containsPoint(p);
		}
						
		public static function bresenhamLine(start:Vector2D, end:Vector2D):Array {
			var points:Array = [];//the array of all the points on the line
			var steep:Boolean = Math.abs(end.y-start.y) > Math.abs(end.x-start.x);
			var swapped:Boolean = false;
			if(steep){
				start = swap(start.x,start.y);//reflecting the line
				end = swap(end.x,end.y);
			}
			if(start.x > end.x){ //make sure the line goes downward
				var t:Number = start.x;
				start.x = end.x;
				end.x = t;
				t = start.y;
				start.y = end.y;
				end.y = t;
				swapped = true;
			}
			var deltax:Number = end.x-start.x;//x slope
			var deltay:Number = Math.abs(end.y-start.y); //y slope, positive because the lines always go down
			var error:Number = deltax/2; //error is used instead of tracking the y values.
			var ystep:Number;
			var y:Number = start.y;
			if(start.y < end.y) ystep = 1;
			else ystep = -1;
			for(var x:int = start.x; x < end.x; x++){//for each point
				if(steep){
					points.push(new Vector2D(y,x));//if its steep, push flipped version
				} else {
					points.push(new Vector2D(x,y));//push normal
				}
				error -= deltay;//change the error
				if (error < 0){
					y += ystep;//if the error is too much, adjust the ystep
					error += deltax;
				}
			}
			if(swapped) points.reverse();
			return points;
		}
		
		private static function swap(x:Number,y:Number):Vector2D {
			return new Vector2D(y,x)
		}
	}
}