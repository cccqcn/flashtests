package 
{
	import flash.display.Sprite;
	
	/**
	* ...
	* @author 		zhangxuchao
	* @version 	1.0
	* @explain 	画虚线
	*/
	public class DottedLine
	{
		private static var bx:Number;
		private static var by:Number;
		private static var ex:Number;
		private static var ey:Number;
		private static var line_thick:Number;
		private static var line_color:Number;
		private static var line_length:Number;
		private static var spacing_length:Number;
		private static var container:Sprite;
		
		private static var t:Number;							//斜率
		private static var line_x_step:Number;
		private static var line_y_step:Number;
		private static var spacing_x_step:Number;
		private static var spacing_y_step:Number;
		
		private static var currentX:Number;
		private static var currentY:Number;
		
		public static function setContainer(c:Sprite):void
		{
			container = c;
		}
		public static function lineStyle(thick:Number, color:Number, lineLength:Number, spacing:Number):void 
		{
			line_thick = thick;
			line_color = color;
			line_length = lineLength;
			spacing_length = spacing;
		}
		public static function moveTo(x:Number, y:Number):void 
		{
			bx = x;
			by = y;
			currentX = x;
			currentY = y;
		}
		public static function lineTo(x:Number, y:Number):void 
		{
			ex = x;
			ey = y;
			drawLine();
		}
		private static function drawLine():void 
		{
			if (bx == ex && by == ey) 
			{
				return;
			}
			container.graphics.moveTo(bx, by);
			container.graphics.lineStyle(line_thick, line_color, 1);
			getSlope();			
			draw();
		}
		private static function getSlope():void 
		{
			if (bx == ex) 
			{
				line_x_step = 0;
				line_y_step = line_length;
				spacing_x_step = 0;
				spacing_y_step = spacing_length;
				return;
			}
			if (by == ey) 
			{
				line_x_step = line_length;
				line_y_step = 0;
				spacing_x_step = spacing_length;
				spacing_y_step = 0;
				return;
			}
			t =  (ex - bx) / (ey - by);
			set_line_x_step();
			set_line_y_step();
			set_spacing_x_step();
			set_spacing_y_step();
		}
		private static function set_line_x_step():void
		{
			var fz:Number = line_length * Math.abs(t);
			var fm:Number = Math.sqrt(t * t + 1);
			line_x_step = Math.abs(fz / fm);
		}
		private static function set_line_y_step():void
		{
			var fz:Number = line_length;
			var fm:Number = Math.sqrt(t * t + 1);
			line_y_step = Math.abs(fz / fm);
		}
		private static function set_spacing_x_step():void
		{
			var fz:Number = spacing_length * Math.abs(t);
			var fm:Number = Math.sqrt(t * t + 1);
			spacing_x_step = Math.abs(fz / fm);
		}
		private static function set_spacing_y_step():void 
		{
			var fz:Number = spacing_length;
			var fm:Number = Math.sqrt(t * t + 1);
			spacing_y_step = Math.abs(fz / fm);
		}
		private static function draw():void
		{
			if (bx < ex) 
			{
				while (currentX < ex) 
				{
					if ((currentX + line_x_step) >= ex) 
					{
						container.graphics.lineTo(ex, ey);
						currentX = ex;						
					}
					else 
					{
						drawStep();
					}
				}
			}
			else if (bx > ex) 
			{
				while (currentX > ex) 
				{
					if ((currentX + line_x_step) <= ex) 
					{
						container.graphics.lineTo(ex, ey);
						currentX = ex;
					}
					else 
					{
						drawStep();
					}
				}
			}
			else	//当bx和ex相等时。
			{
//***************************************************************************************
//*******************************画竖线***************************************************
//***************************************************************************************
				if (by > ey) 
				{
					while (currentY > ey) 
					{
						if ((currentY + line_y_step) <= ey) 
						{
							container.graphics.lineTo(ex, ey);
							currentY = ey;
						}
						else 
						{
							drawStep();
						}
					}
				}
				else if (by < ey) 
				{
					while (currentY < ey) 
					{
						if ((currentY + line_y_step) >= ey) 
						{
							container.graphics.lineTo(ex, ey);
							currentY = ey;
						}
						else 
						{
							drawStep();
						}
					}
				}
//***************************************************************************************
			}
			currentX = ex;
			currentY = ey;
			bx = ex;
			by = ey;
		}
		private static function drawStep():void 
		{
			var x_sign:int = (bx < ex)?1: -1;
			var y_sign:int = (by < ey)?1: -1;
			container.graphics.lineTo(currentX + line_x_step * x_sign, currentY + line_y_step * y_sign);
			currentX = currentX + line_x_step * x_sign;
			currentY = currentY + line_y_step * y_sign;
			container.graphics.moveTo(currentX + spacing_x_step * x_sign, currentY + spacing_y_step * y_sign);
			currentX = currentX + spacing_x_step * x_sign;
			currentY = currentY + spacing_y_step * y_sign;
		}
	}
	
}