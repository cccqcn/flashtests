package WTGame.utils
{
	import flash.display.CapsStyle;
	import flash.display.Shape;
	
	public class Line extends Shape implements ILine
	{
		protected var lineColor:uint;	// line color
		protected var lineWeight:Number;	// line weight
		protected var lineAlpha:Number = 1;	// line alpha
		
		public function Line(weight:Number = 0, color:uint = 0)
		{
			lineWeight = weight;
			lineColor = color;
		}
		public function moveTo(x:Number, y:Number):void{
			moveTo(x,y);
		}
		public function lineTo(x:Number, y:Number):void{
			lineTo(x,y);
		}
		public function clear():void{
			graphics.lineStyle(lineWeight,lineColor,lineAlpha,false,"none",CapsStyle.NONE);
			graphics.clear();
			moveTo(0,0);
		}
		public function lineStyle(w:Number = 0, c:uint = 0, a:Number = 1):void{
			lineWeight = w;
			lineColor = c;
			lineAlpha = a;
			graphics.lineStyle(lineWeight,lineColor,lineAlpha,false,"none",CapsStyle.NONE);
		}
		// basic beginFill
		public function beginFill(c:uint, a:Number = 1):void{
			graphics.beginFill(c,a);
		}
		// basic endFill
		public function endFill():void{
			graphics.endFill();
		}
	}
}