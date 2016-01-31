package
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	[SWF(width=600, height=600, frameRate="30", backgroundColor="#000000")]
	public class TestPrj extends Sprite
	{
		private var total:int = 88;
		private var roundnum:int = 22;
		private var duration:Number = 2;
		private var alphaChange:Boolean = true;
		
		private var rs:Array = [];
		private var current:int;
		
		public function TestPrj()
		{
			var i:int;
			for(i = 0; i < total; i++)
			{
				var r:Round = new Round(i, i * Math.PI / (roundnum / 2) - Math.PI / 2);
				addChild(r);
				r.addEventListener(MouseEvent.CLICK, onClick);
				setXY(r);
				rs.push(r);
			}
			refreshAlpha();
		}
		
		protected function onClick(e:MouseEvent):void
		{
			var cr:Round = e.currentTarget as Round;
			trace("click", cr.index, cr.angle * 180 / Math.PI);
			current = cr.index;
			var rotate:Number = cr.angle + Math.PI / 2;
			while(Math.abs(rotate) > Math.PI)
			{
				rotate = rotate > 0 ? (rotate - Math.PI * 2) : (rotate + Math.PI * 2);
			}
			var i:int;
			for(i = 0; i < rs.length; i++)
			{
				var r:Round = rs[i];
				trace(r.index, (r.angle - rotate) * 180 / Math.PI);
				TweenMax.to(r, duration, {angle:r.angle - rotate, onUpdate:onUpdate, onUpdateParams:[r]});
			}
		}
		private function onUpdate(r:Round):void
		{
			setXY(r);
			refreshAlpha();
		}
		private function setXY(r:Round):void
		{
			r.x = Math.sin(r.angle) * 200 + 300;
			r.y = Math.cos(r.angle) * 200 + 300;
		}
		private function refreshAlpha():void
		{
			var i:int;
			for(i = 0; i < rs.length; i++)
			{
				var r:Round = rs[i];
				var angle:Number = r.angle + Math.PI / 2;
				while(Math.abs(angle) > Math.PI)
				{
					angle = angle > 0 ? (angle - Math.PI * 2) : (angle + Math.PI * 2);
				}
				if(alphaChange)
				{
					r.alpha = (2 - Math.abs(angle)) / 2;
				}
				var offset:int = Math.abs(r.index - current);
				r.visible = offset <= roundnum / 2 && r.alpha > 0.2;
			}
		}
	}
}
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;
import flash.text.TextFormat;

class Round extends Sprite
{
	public var index:int;
	public var angle:Number;
	public function Round(i:int, angle:Number)
	{
		super();
		this.index = i;
		this.angle = angle;
		var tf:TextField = new TextField;
		tf.selectable = false;
		tf.defaultTextFormat = new TextFormat(null, 22, 0xFFF000, null, null, null, null, null, "center");
		tf.text = i.toString();
		tf.x = -10;
		tf.y = -12;
		tf.width = 25;
		tf.height = 25;
		tf.mouseEnabled = false;
		tf.cacheAsBitmap = true;
		addChild(tf);
		graphics.lineStyle(2, 0x0);
		graphics.beginFill(0xFF0000);
		graphics.drawCircle(0, 0, 30);
		graphics.endFill();
		this.addEventListener(MouseEvent.MOUSE_OVER, over);
		this.addEventListener(MouseEvent.MOUSE_OUT, out);
	}
	
	protected function out(event:MouseEvent):void
	{
		this.filters = [];
	}
	
	protected function over(event:MouseEvent):void
	{
		this.filters = [new GlowFilter(0xFFFFFF)];
	}
}