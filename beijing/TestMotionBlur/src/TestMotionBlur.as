package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	
	[SWF(width=1200, height=400, frameRate="30", backgroundColor="#AAAAAA")]
	public class TestMotionBlur extends Sprite
	{
		private var box:Sprite;
		private var tween:TweenLite;
		private var blur:MotionGhost;
		private var _blur:BlurFilter;
		[Embed(source="a.png")] 
		private static var bbb:Class;
		
		/** @private **/
		protected var _xCurrent:Number;
		/** @private **/
		protected var _yCurrent:Number;
		protected var _rect:Rectangle;
		private var cachedTime:int;
		protected var _bd:BitmapData;
		protected var _bitmap:Bitmap;
		protected var _matrix:Matrix = new Matrix();
		private static const _point:Point = new Point(0, 0);
		
		public function TestMotionBlur()
		{
			box = new Sprite;
			addChild(box);
			box.x = 100;
			box.y = 100;
//			box.graphics.lineStyle(5, 0x0000FF);
//			box.graphics.beginFill(0xFF0000);
//			box.graphics.drawCircle(0, 0, 50);
//			box.graphics.endFill();
			addEventListener(Event.ADDED_TO_STAGE, onadd);
			var b:Bitmap = new bbb();
			box.addChild(b);
			b.x = -b.width / 2;
			b.y = -b.height / 2;
		}
		private function onadd(e:Event):void
		{
			stage.addEventListener(MouseEvent.CLICK, onClick);
			trace(box.x);
			setInterval(test, 111);
		}
		
		protected function onClick(event:MouseEvent):void
		{
			if(blur)
			{
				blur.disable();
				TweenLite.killTweensOf(box);
			}
			tween = TweenLite.to(box, .5, {
				x:int(stage.mouseX), 
				y:int(stage.mouseY), 
				onUpdate:onUpdate, onComplete:onComplete, ease:Cubic.easeInOut
			});
//			box.alpha = 0;
			_blur = new BlurFilter();
			_bd = new BitmapData(box.width + 30, box.height + 30, true, 0x00FFFFFF);
			_bitmap = new Bitmap(_bd);
			_bitmap.smoothing = Boolean(_blur.quality > 1);
			_rect = new Rectangle(0, 0, _bd.width, _bd.height);
			addChild(_bitmap);
			box
			_xCurrent = box.x;
			_yCurrent = box.y;
//			box.filters = [bf];
			blur = new MotionGhost;
			blur._onInitTween(box, {strength:3, quality:3}, tween);
		}
		
		private function onUpdate():void
		{
//			blur.setRatio(tween.ratio);
			var t:int = getTimer();
			var time:Number = (t - cachedTime)/1000;
			cachedTime = t;
			var dx:Number = box.x - _xCurrent;
			var dy:Number = box.y - _yCurrent;
			//			var rx:Number = box.x - _xRef;
			//			var ry:Number = box.y - _yRef;
			_blur.blurX = Math.sqrt(dx * dx + dy * dy) * 1 / time;
			var bounds:Rectangle = box.getBounds(box.parent);
			if (bounds.height > _bd.height || bounds.width + _blur.blurX * 2 > _bd.width) {
				_bd = _bitmap.bitmapData = new BitmapData(bounds.width + _blur.blurX * 2 + 10, bounds.height + 10, true, 0x00FFFFFF);
				_rect = new Rectangle(0, 0, _bd.width, _bd.height);
				_bitmap.smoothing = Boolean(_blur.quality > 1);
				trace("_bd", _bd.width);
			}
//			box.filters = [bf];
			_xCurrent = box.x;
			_yCurrent = box.y;
			_matrix.tx = _blur.blurX - bounds.x;
			_matrix.ty = -bounds.y;
			_bitmap.x = bounds.x - _blur.blurX;
			_bitmap.y = bounds.y ;
			trace(dx, dy, time, _blur.blurX, _bitmap.x, _bitmap.y);
			bounds.x = bounds.y = 0;
			bounds.width += _blur.blurX * 2;
			_bd.fillRect(_rect, 0x00FFFFFF);
			_bd.draw(box.parent, _matrix, null, "normal", bounds, Boolean(_blur.quality > 1));
			_bd.applyFilter(_bd, bounds, _point, _blur);            
			
		}
		private function onComplete():void
		{
			blur.disable();
			box.filters = [];
			_bitmap.parent && _bitmap.parent.removeChild(_bitmap);
			_bitmap.bitmapData.dispose();
//			box.alpha = 1;
		}
		
		private function test():void
		{
//			trace(box.mask, box.stage, box.visible, box.alpha);
		}
	}
}