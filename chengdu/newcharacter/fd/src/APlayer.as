package {
	import flash.display.*;
	import flash.events.*;
	public class APlayer extends Sprite {
		
		private var mc:Array = new Array();
		
		private var speed:int = 3;
		private var _forward:int;			/* 
										 *  0: down
										 *  1: left
										 *  2: right
										 *  3: up
										 */
		
		public function APlayer():void
		{
			
		}
		
		public function addPlayer(p:Player):void
		{
			if(mc.length<4)
			{
				mc.push(p);
				addChild(p);
				p.visible = false;
			}
		}
		
		public function get forward():int
		{
			return _forward;
		}
		
		public function set forward(f:int):void
		{
			if(f>3)f=0;
			if(f<0)f=3;
			_forward = f;
			var i:int;
			for(i=0;i<4;i++)
			{
				mc[i].visible = false;
			}
			mc[f].visible = true;
		}
		
		//沿着当前方向继续移动
		public function moveon():void
		{
			switch(_forward)
			{
				case 0:
					y+=speed;
					break;
				case 1:
					x-=speed;
					break;
				case 2:
					x+=speed;
					break;
				case 3:
					y-=speed;
					break;
			}
		}
		
		//判断边界并反向
		public function backward(x1:int, y1:int, x2:int, y2:int):void
		{
			if(x-speed<x1)forward=2;
			if(x+speed>x2-width)forward=1;
			if(y-speed<y1)forward=0;
			if(y+speed>y2-height)forward=3;
		}
	}
}