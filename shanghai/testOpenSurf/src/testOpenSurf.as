package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	[SWF(width='800',height='600',frameRate='60',backgroundColor='0xFFFFFF')]
	public class testOpenSurf extends Sprite
	{
		private var isdown:Boolean;
		private var bmd:BitmapData;
		private var surf:SurfAS;
		private var line_mc:MovieClip;
		public function testOpenSurf()
		{
			addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		private function onadd(e:Event):void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, ondown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onup);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onmove);
			graphics.lineStyle(1);
			graphics.drawRect(0, 0, 100, 100);
		}
		private function ondown(e:MouseEvent):void
		{
			isdown = true;
			pArr = new Vector.<Point>();
			graphics.clear();
			graphics.lineStyle(1);
			graphics.drawRect(0, 0, 100, 100);
			graphics.moveTo(stage.mouseX, stage.mouseY);
			if(bmd)
			{
				bmd.dispose();
			}
			if(surf)
			{
				removeChild(surf);
			}
			if(line_mc && line_mc.parent)
			{
				removeChild(line_mc);
			}
			pArr.push(new Point(stage.mouseX, stage.mouseY));
			addEventListener(Event.ENTER_FRAME, onenter);
		}
		private function onmove(e:MouseEvent):void
		{
			if(isdown)
			{
				graphics.lineTo(stage.mouseX, stage.mouseY);
			}
		}
		private function onenter(e:Event):void
		{
			var lastPoint:Point = pArr[pArr.length - 1];
			var p:Point = new Point(Math.abs(stage.mouseX - lastPoint.x), Math.abs(stage.mouseY - lastPoint.y));
			
			var dis:Number = Math.sqrt(p.x * p.x + p.y * p.y);
			trace(dis);
			if(dis > 50)
			{
				pArr.push(new Point(stage.mouseX, stage.mouseY));
				graphics.drawCircle(stage.mouseX, stage.mouseY, 1);
//				graphics.clear();
//				graphics.lineStyle(1);
				if(line_mc && line_mc.parent)
				{
					removeChild(line_mc);
					line_mc = null;
				}
				dodraw();
			}
			n++;
		}
		private var pArr:Vector.<Point>;
		private var n:int;
		private var offset:int = 80;
		private function onup(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, onenter);
			isdown = false;
			pArr.push(new Point(stage.mouseX, stage.mouseY));
			pArr.push(new Point(stage.mouseX, stage.mouseY));
			graphics.drawCircle(stage.mouseX, stage.mouseY, 1);
			
		}
		private function dodraw():void
		{
			trace("draw");
			line_mc = new MovieClip();
			addChild(line_mc);
			var myShape:Shape = new Shape();
			line_mc.addChild(myShape);
			myShape.graphics.lineStyle(2, 0xFF0000, 1,false,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER,1);
			line_mc.x = offset;
			line_mc.y = offset;
			var myI:uint=100;
			for (var i:int=0; i<pArr.length; i++) {
//				graphics.lineTo(pArr[i].x, pArr[i].y);
			}
			myShape.graphics.moveTo(pArr[0].x, pArr[0].y);
			for(i=1;i<pArr.length-2;i++){ 
				var xc:Number = (pArr[i].x+pArr[i+1].x)/2; 
				var yc:Number = (pArr[i].y+pArr[i+1].y)/2; 
				//i从1开始的，即第一个控点是原来的第二个点，终点（xc，yc）为原第二个点与第三个点间插入的新点,即第一个插入的点。。。循环结束i=numPoints-2,即还剩下两个点没有画线 
				myShape.graphics.curveTo(pArr[i].x,pArr[i].y,xc,yc); 
			} 
			//追加最后一条曲线(倒数第二个点为控点，最后一个点为终点) 
//			myShape.graphics.curveTo(pArr[i].x,pArr[i].y,pArr[i+1].x,pArr[i+1].y);
			
			var arr:Array = [];
			for(i=0;i<pArr.length;i++)
			{ 
				arr.push(pArr[i].clone());
				arr[i].x += offset;
				arr[i].y += offset;
			}
			myShape.graphics.lineStyle(2, 0x00FF00, 1,false,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER,1);
			CubicBezier.curveThroughPoints(myShape.graphics,arr);
			return;
			bmd = new BitmapData(100, 100);
			bmd.draw(this);
			var t1:int = getTimer();
			surf = new SurfAS(new Bitmap(bmd));
			addChild(surf);
			var t2:int = getTimer();
			trace(t2-t1);
		}
		
		// calculate point
		private function calculate(t:Number):Point {
			var temp:Point=new Point();
			for (var i:uint=0; i<pArr.length; i++) {
				//trace();
				var thisT:Point=new Point(0,0);
				if (i==0 || i==pArr.length-1) {
					thisT=multiply(Math.pow(t,i)*Math.pow(1-t,(pArr.length-i-1)),pArr[i]);
				} else {
					thisT=multiply((pArr.length-1)*Math.pow(t,i)*Math.pow(1-t,(pArr.length-i-1)),pArr[i]);
				}
				temp=temp.add(thisT);
				
			}
			return temp;
		}
		private function multiply(num:Number,p:Point):Point {
			var temp:Point = new Point();
			temp.x = p.x*num;
			temp.y = p.y*num;
			return temp;
		}
	}
}