package 
{
	import flash.display.Sprite;
	import DottedLine;

	/**
	* ...
	* @author DefaultUser (Tools -> Custom Arguments...)
	*/
	public class Test2 extends Sprite 
	{
		public function Test2()
		{
			//这里是设置你要在哪个地方画线。sprite。
			DottedLine.setContainer(this);
			//DottedLine.lineStyle(线的粗细， 线的颜色， 线段长，间隔长);
			DottedLine.lineStyle(2, 0x008080, 10,15);
			DottedLine.moveTo(10, 10);
			DottedLine.lineTo(10,  110);			
			DottedLine.lineTo(110,  110);			
			DottedLine.lineTo(110,  10);			
			DottedLine.lineTo(10,  10);	
			
			DottedLine.lineStyle(2, 0x0000FF, 5, 5);
			DottedLine.moveTo(210, 10);
			DottedLine.lineTo(210,  110);			
			DottedLine.lineTo(310,  110);			
			DottedLine.lineTo(310,  10);			
			DottedLine.lineTo(210,  10);	
			DottedLine.lineTo(210,  50);	
			DottedLine.lineTo(210,  100);	
			DottedLine.lineTo(210,  103);	
			DottedLine.lineTo(210,  150);	
			DottedLine.lineTo(210,  350);	
			DottedLine.lineTo(210,  550);	
			
		}		
	}	
}