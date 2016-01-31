package com.jiuji.myhome.as3.view.components.list
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class BaseScrollbar extends Sprite
	{
		private var type:String;
		// 需进行滚动的对象
		public var obj:DisplayObject;
		// 遮罩对象
		public var scrollmask:Sprite;
		// 滚动条整体高度
		public var scrollwidth:Number;
		public var scrollheight:Number;
		// 文本滚动速度（行/像素）
		public var textspeed:int;
		
		// 滑块
		public var bar:MovieClip;
		// 滑槽
		public var bg:MovieClip;
		public var upLoc:Boolean = false;
		
		// 滑块可滑动距离
		public var bars:Number;
		// 滑块可拖动范围
		public var rect:Rectangle;
		// 滚动条显示标志
		public var flag:int = 0;
		public var preObjWidth:Number = 0;
		public var preObjHeight:Number = 0;
		
		/**
		 * 构造函数
		 * @param value 
		 * 
		 */	
		public function BaseScrollbar(bg:MovieClip, bar:MovieClip, upLocation:Boolean = false)
		{
			super();
			
			this.textspeed = 20;
			this.upLoc = upLocation;
			
			this.bg = bg;
			this.bar = bar;
			this.addChild(bg);
			this.addChild(bar);
		}
		
		/**
		 * 初始化函数,在ListContainer中调用
		 * @param value 
		 * 
		 */	
		public function init(obj:DisplayObject, parentWidth:Number, parentHeight:Number, type:String = "VScrollBar"):void
		{
			this.type = type;
			this.obj = obj;
			
			this.scrollwidth = parentWidth;
			this.scrollheight = parentHeight;
			
			if (checkhide())
			{
				addEventListeners();
			}
			else
			{
				this.visible = false;
			}
			uiInit();
		}
		
		/**
		 * 重置函数，在content清空之后调用
		 * @param value 
		 * 
		 */	
		public function clear():void
		{
			this.visible = false;
			flag = 0;
			uiInit();
			
			obj.x = 0;
			obj.y = 0;
		}
		
		/**
		 * 检查滚动条是否显示
		 * @param value 
		 * 
		 */	
		private function checkhide():Boolean
		{
			if(type == "VScrollBar")
			{
				if (obj.height <= scrollmask.height)
					return false;
			}
			else
			{
				if (obj.width <= scrollmask.width)
					return false;
			}
			
			return true;
		}
		
		private function uiInit():void
		{
			if(type == "VScrollBar")
			{
				bg.height = scrollheight;
				bar.height = bg.height * 0.75;
				
				bg.x = 0;
				bg.y = 0;
				bar.x = bg.width / 2 - bar.width / 2;
				bar.y = bg.y;
				
				bars = bg.height - bar.height;
				obj.mask = scrollmask;
				
				rect = new Rectangle(bar.x, bg.y, 0, bg.height - bar.height);
			}
			else
			{
				bg.width = scrollwidth;
				bar.width = bg.width * 0.75;
				
				bg.x = 0;
				bg.y = 0;
				bar.y = bg.height / 2 - bar.height / 2;
				bar.x = bg.x;
				
				bars = bg.width - bar.width;
				obj.mask = scrollmask;
				
				rect = new Rectangle(bar.x, bg.y, bg.width - bar.width, 0);
			}
		}
		
		/**
		 * 更新函数，根据内容，更新滚动条位置
		 * @param value 
		 * 
		 */	
		public function update():void
		{
			if (checkhide())
			{
				flag = 1;
				if(type == "VScrollBar")
				{
					bar.height = bg.height * (scrollheight / obj.height);
					if (bar.height < 40)
						bar.height = 40;
					if (bar.height > bg.height * 0.75)
						bar.height = bg.height * 0.75;
				}
				else
				{
					bar.width = bg.width * (scrollwidth / obj.width);
					if (bar.width < 40)
						bar.width = 40;
					if (bar.width > bg.width * 0.75)
						bar.width = bg.width * 0.75;
				}
				
				if (upLoc)
				{
					if(type == "VScrollBar")
					{
						bar.y = bg.y + bg.height - bar.height;
						//bar.y +=  bars * textspeed /(obj.height - scrollmask.height);
						obj.y = scrollmask.y - obj.height + scrollmask.height;
					}
					else
					{
						bar.x = bg.x + bg.width - bar.width;
						//bar.y +=  bars * textspeed /(obj.height - scrollmask.height);
						obj.x = scrollmask.x - obj.width + scrollmask.width;
					}
					objRun(textspeed);
				}
				updateBar();
				if(type == "VScrollBar")
				{
					bars = bg.height - bar.height;
					//rect = new Rectangle(bar.x, bg.y + 1, 0, bg.height - bar.height);
					rect = new Rectangle(bar.x, bg.y, 0, bg.height - bar.height);
				}
				else
				{
					bars = bg.width - bar.width;
					//rect = new Rectangle(bar.x, bg.y + 1, 0, bg.height - bar.height);
					rect = new Rectangle(bar.x, bg.y, bg.width - bar.width, 0);
				}
				if (flag == 1)
				{
					this.visible = true;
					addEventListeners();
				}
				
				onBarEnterFrame(null);
			}
			else
			{
				if(type == "VScrollBar")
				{
					obj.y = 0;
				}
				else
				{
					obj.x = 0;
				}
				this.visible = false;
			}
			if(type == "VScrollBar")
			{
				preObjHeight = obj.height;
			}
			else
			{
				preObjWidth = obj.width;
			}
		}
		
		private function addEventListeners():void
		{
			bar.addEventListener(MouseEvent.MOUSE_DOWN, onBarClick);
			if (bar.stage)
				bar.stage.addEventListener(MouseEvent.MOUSE_UP, onBarUp);
			this.addEventListener(MouseEvent.MOUSE_UP, onBarUp);
			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			obj.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		private function onBarClick(evt:MouseEvent):void
		{
			bar.startDrag(false, rect);
			bar.addEventListener(Event.ENTER_FRAME, onBarEnterFrame);
		}
		
		// 鼠标点击滑块释放方法
		private function onBarUp(evt:MouseEvent):void
		{
			bar.stopDrag();
			updateBar();
			bar.removeEventListener(Event.ENTER_FRAME, onBarEnterFrame);
		}
		
		private function onBarEnterFrame(evt:Event):void
		{
			if(type == "VScrollBar")
			{
				obj.y = scrollmask.y - (bar.y - bg.y) * (obj.height - scrollmask.height) / bars;
				if (bar.y == 0)
					objRun(-textspeed);
				//else if (bar.y == bg.y + bg.height - bar.height - 1)
				else if (bar.y == bg.y + bg.height - bar.height)
					objRun(textspeed);
				if (obj.y > scrollmask.y)
				{
					obj.y = scrollmask.y;
				}
				else if (obj.y < (scrollmask.y - obj.height + scrollmask.height))
				{
					obj.y = scrollmask.y - obj.height + scrollmask.height;
				}
			}
			else
			{
				obj.x = scrollmask.x - (bar.x - bg.x) * (obj.width - scrollmask.width) / bars;
				if (bar.x == 0)
					objRun(-textspeed);
					//else if (bar.y == bg.y + bg.height - bar.height - 1)
				else if (bar.x == bg.x + bg.width - bar.width)
					objRun(textspeed);
				if (obj.x > scrollmask.x)
				{
					obj.x = scrollmask.x;
				}
				else if (obj.x < (scrollmask.x - obj.width + scrollmask.width))
				{
					obj.x = scrollmask.x - obj.width + scrollmask.width;
				}
			}
		}
		
		private function objRun(i:Number):void
		{
			if(type == "VScrollBar")
			{
				obj.y -=  i;
				if (obj.y > scrollmask.y)
				{
					obj.y = scrollmask.y;
				}
				else if (obj.y < (scrollmask.y - obj.height + scrollmask.height))
				{
					obj.y = scrollmask.y - obj.height + scrollmask.height;
				}
			}
			else
			{
				obj.x -=  i;
				if (obj.x > scrollmask.x)
				{
					obj.x = scrollmask.x;
				}
				else if (obj.x < (scrollmask.x - obj.width + scrollmask.width))
				{
					obj.x = scrollmask.x - obj.width + scrollmask.width;
				}
			}
		}
		
		private function checkBar():Boolean
		{
			if(type == "VScrollBar")
			{
				if (bar.y >= bg.y && bar.y <= (bars + bg.y))
				{
					return true;
				}
			}
			else
			{
				if (bar.x >= bg.x && bar.x <= (bars + bg.x))
				{
					return true;
				}
			}
			return false;
		}
		
		private function updateBar():void
		{
			if(type == "VScrollBar")
			{
				if (bar.y < bg.y)
				{
					//bar.y = bg.y + 1;
					bar.y = bg.y;
				}
				//else if (bar.y > (bg.y + bg.height - bar.height -1))
				else if (bar.y > (bg.y + bg.height - bar.height))
				{
					//bar.y = bg.y + bg.height - bar.height - 1;
					bar.y = bg.y + bg.height - bar.height;
				}
				if (bar.height < 40)
					bar.height = 40;
				if (bar.height > bg.height * 0.75)
					bar.height = bg.height * 0.75;
			}
			else
			{
				if (bar.x < bg.x)
				{
					//bar.y = bg.y + 1;
					bar.x = bg.x;
				}
					//else if (bar.y > (bg.y + bg.height - bar.height -1))
				else if (bar.x > (bg.x + bg.width - bar.width))
				{
					//bar.y = bg.y + bg.height - bar.height - 1;
					bar.x = bg.x + bg.width - bar.width;
				}
				if (bar.width < 40)
					bar.width = 40;
				if (bar.width > bg.width * 0.75)
					bar.width = bg.width * 0.75;
			}
		}
		
		private function onMouseWheel(evt:MouseEvent):void
		{
			if (evt.delta > 0)
			{
				if (checkBar())
				{
					if(type == "VScrollBar")
					{
						bar.y -=  bars * textspeed / (obj.height - scrollmask.height);
					}
					else
					{
						bar.x -=  bars * textspeed / (obj.width - scrollmask.width);
					}
					objRun(-textspeed);
					updateBar();
				}
			}
			else
			{
				if (checkBar())
				{
					if(type == "VScrollBar")
					{
						bar.y +=  bars * textspeed / (obj.height - scrollmask.height);
					}
					else
					{
						bar.x +=  bars * textspeed / (obj.width - scrollmask.width);
					}
					objRun(textspeed);
					updateBar();
				}
			}
		}
	}
}