package
{
	import com.jiuji.myhome.as3.view.components.list.BaseScrollbar;
	import com.jiuji.myhome.as3.view.components.list.ListContainer;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class testScrollBar extends Sprite
	{
		private var container:Sprite;
		private var list:ListContainer;
		
		public function testScrollBar()
		{
			addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		
		private function onadd(e:Event):void
		{
			container = new Sprite;
			var type:String = "bottom";		//横式
//			var type:String = "right";		//竖式
			addChild(container);
			var i:int;
			var box:Sprite;
			for(i=0;i<15;i++)
			{
				if(type == "bottom")
				{
					box = getbox(55 * i, 0);
				}
				else
				{
					box = getbox(0, 55 * i);
				}
				container.addChild(box);
			}
			
			var bar:BaseScrollbar = new BaseScrollbar(gettrack(), getthumb());
			list = new ListContainer(container, bar, 200, 200, type);
			list.x = 50;
			list.y = 50;
			addChild(list);
		}
		
		private var total:int;
		private function getbox(x:int, y:int):Sprite
		{
			var box:Sprite = new Sprite;
			box.graphics.beginFill(0x00FF00);
			box.graphics.drawRect(0, 0, 50, 50);
			box.graphics.endFill();
			box.x = x;
			box.y = y;
			var tf:TextField = new TextField;
			tf.selectable = false;
			tf.text = total.toString();
			total++;
			box.addChild(tf);
			return box;
		}
		private function gettrack():MovieClip
		{
			var track:MovieClip = new MovieClip;
			track.graphics.beginFill(0x333333);
			track.graphics.drawRect(0, 0, 10, 10);
			track.graphics.endFill();
			return track;
		}
		private function getthumb():MovieClip
		{
			var thumb:MovieClip = new MovieClip;
			thumb.graphics.beginFill(0xDDDDDD);
			thumb.graphics.drawRect(0, 0, 10, 10);
			thumb.graphics.endFill();
			return thumb;
		}
	}
}