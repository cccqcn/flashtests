package
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.LinePath2D;
	import com.greensock.plugins.BezierPlugin;
	import com.greensock.plugins.BezierThroughPlugin;
	import com.greensock.plugins.TweenPlugin;
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class testAirCurve extends Sprite
	{
		private var isdown:Boolean;
		private var line_mc:MovieClip;
		public function testAirCurve()
		{
			addEventListener(Event.ADDED_TO_STAGE, onadd);
			TweenPlugin.activate([BezierPlugin, BezierThroughPlugin]);
		}
		private function onadd(e:Event):void
		{
			/*
			var box:Shape = new Shape;
			box.graphics.lineStyle(1, 0x0);
			box.graphics.drawCircle(0, 0, 5);
			addChild(box);
			var tween:Array = [];
			tween.push({x:100,y:100, duration:1});
			tween.push({bezier:[{x:100,y:300},{x:200,y:200}]});
			tween.push({x:100,y:100});
			addTween(box, tween);
			return;*/
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
			if(dis > 5)
			{
				pArr.push(new Point(stage.mouseX, stage.mouseY));
				graphics.drawCircle(stage.mouseX, stage.mouseY, 2);
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
		private var offsetx:int = 80;
		private var offsety:int = 0;
		private function onup(e:MouseEvent):void
		{
			removeEventListener(Event.ENTER_FRAME, onenter);
			isdown = false;
//			pArr.push(new Point(stage.mouseX, stage.mouseY));
//			pArr.push(new Point(stage.mouseX, stage.mouseY));
			graphics.drawCircle(stage.mouseX, stage.mouseY, 1);
			
			var box:Shape = new Shape;
			box.graphics.lineStyle(1, 0x0);
			box.graphics.beginFill(0x0, 1);
			box.graphics.drawRect(-22 / 2, -22 / 2, 22, 22);
			box.graphics.drawCircle(22 / 2, 0, 22 / 2);
			box.graphics.endFill();
			line_mc.addChild(box);
			
			var i:int=0;
			var pointArr:Array = new Array;
			for(i=0;i<pArr.length;i++)
			{
				pointArr[i] = pArr[i];
			}
			var path:LinePath2D = new LinePath2D(pointArr);path.graphics.clear();
			addChild(path);
			//path.distribute(box, 0, 1, true);
			path.addFollower(box, path.getSegmentProgress(1, 0), true);
			var dis:Number = getDistances(pointArr);
			var speed:Number = 200;
			trace(dis, dis / speed);
			//tween all of the squares through the path once (wrapping when they reach the end)
			TweenMax.to(path, dis / speed, {progress:1, ease:Linear.easeNone});
			
			return;
			
			
			var tween:Array = [];
			var duration:Number = 1;
			
			box.x = pArr[0].x;
			box.y = pArr[0].y;
			for(i=0;i<pArr.length-2;i++)
			{
				var xc:Number = (pArr[i].x+pArr[i+1].x)/2; 
				var yc:Number = (pArr[i].y+pArr[i+1].y)/2; 
				tween.push(
					{
						ease:Linear.easeNone,
						bezier:[
							{x:pArr[i].x, y:pArr[i].y},
						{x:xc, y:yc}], 
						duration:duration
					});
			}
			addTween(box, tween);
			trace("tween", tween.length);
//			return;
			
			var box:Shape = new Shape;
			box.graphics.lineStyle(1, 0x0);
			box.graphics.drawCircle(0, 0, 5);
			line_mc.addChild(box);
			var tween:Array = [];
			var duration:Number = 1;
			box.x = CubicBezier.recordpoints[0].x;
			box.y = CubicBezier.recordpoints[0].y;
			for(i=0;i<CubicBezier.recordpoints.length;i++)
			{
				if(CubicBezier.recordpoints[i].type == "move")
				{
					trace(CubicBezier.recordpoints[i].type);
					graphics.drawCircle(CubicBezier.recordpoints[i].x, CubicBezier.recordpoints[i].y+100, 1);
					tween.push({x:CubicBezier.recordpoints[i].x, y:CubicBezier.recordpoints[i].y, 
						ease:Linear.easeNone, duration:0});
				}
				if(CubicBezier.recordpoints[i].type == "line")
				{
					duration = 0.001/Math.sqrt((box.x - CubicBezier.recordpoints[i].x) * (box.x - CubicBezier.recordpoints[i].x) + 
						(box.y - CubicBezier.recordpoints[i].y) * (box.y - CubicBezier.recordpoints[i].y));
					trace(CubicBezier.recordpoints[i].type,  duration);
					graphics.drawCircle(CubicBezier.recordpoints[i].x, CubicBezier.recordpoints[i].y+100, 1);
					tween.push({x:CubicBezier.recordpoints[i].x, y:CubicBezier.recordpoints[i].y, 
						ease:Linear.easeNone, duration:duration});
				}
				if(CubicBezier.recordpoints[i].type == "curve")
				{
					duration = Math.sqrt((box.x - CubicBezier.recordpoints[i].ax) * (box.x - CubicBezier.recordpoints[i].ax) + 
						(box.y - CubicBezier.recordpoints[i].ay) * (box.y - CubicBezier.recordpoints[i].ay));
					if(duration != 0)
					{
						duration = 500/duration;
					}
					trace(CubicBezier.recordpoints[i].type,  duration);
					tween.push(
						{
							ease:Linear.easeNone,
							bezier:[{x:CubicBezier.recordpoints[i].cx, y:CubicBezier.recordpoints[i].cy},
								{x:CubicBezier.recordpoints[i].ax, y:CubicBezier.recordpoints[i].ay}], 
							duration:duration
						});
				}
			}
			addTween(box, tween);
			trace("CubicBezier", CubicBezier.recordpoints.length);
			
		}
		private function dodraw():void
		{
			trace("draw");
			line_mc = new MovieClip();
			addChild(line_mc);
			var myShape:Shape = new Shape();
			line_mc.addChild(myShape);
			myShape.graphics.lineStyle(2, 0xFF0000, 1,false,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER,1);
			line_mc.x = offsetx;
			line_mc.y = offsety;
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
				arr[i].x += offsetx;
				arr[i].y += offsety;
			}
			myShape.graphics.lineStyle(2, 0x00FF00, 1,false,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER,1);
			CubicBezier.curveThroughPoints(myShape.graphics,arr);
			
			
			return;
		}
		public function getDistances(arr:Array):Number
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
		public static function addTween(obj:Object, tween:Array, finished:Function = null, lastComplete:Function = null, lastParams:Array = null):void
		{
			if(lastComplete != null)
			{
				lastComplete.apply(null, lastParams);
			}
			if(tween.length > 0)
			{
				var params:Object = tween.shift();
				var duration:Number = 1;
				if(params.hasOwnProperty("duration"))
				{
					duration = params.duration;
					delete params.duration;
				}
				var _onComplete:Function;
				var _onCompleteParams:Array;
				if(params.hasOwnProperty("onComplete"))
				{
					_onComplete = params.onComplete;
					_onCompleteParams = params.onCompleteParams;
				}
				params.onComplete = addTween;
				params.onCompleteParams = [obj, tween, finished, _onComplete, _onCompleteParams];
				TweenLite.to(obj, duration, params);
				// TODO
			}
			else if(finished != null)
			{
				finished();
			}
		}
		
	}
}