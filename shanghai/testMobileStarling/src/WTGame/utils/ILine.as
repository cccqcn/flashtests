package WTGame.utils
{
	public interface ILine
	{
		function moveTo(x:Number, y:Number):void;
		function lineTo(x:Number, y:Number):void;
		function clear():void;
		function lineStyle(w:Number = 0, c:uint = 0, a:Number = 1):void;
		function beginFill(c:uint, a:Number = 1):void;
		function endFill():void;
	}
}