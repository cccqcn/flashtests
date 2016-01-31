package com.jiuji.myhome.as3.view.components.list
{
//	import com.jiuji.myhome.as3.events.ListRelatedEvent;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class ListContainer extends Sprite
	{
		public static const SC_LEFT:String = "left";
		public static const SC_RIGHT:String = "right";
		public static const SC_TOP:String = "top";
		public static const SC_BOTTOM:String = "bottom";
		
		// 遮罩
		private var scmask:Sprite = new Sprite();
		// 内容
		public var content:DisplayObject;
		// 滚动条
		public var listScrollBar:BaseScrollbar;
		
		// List 的宽度
		private var listWidth:Number;
		// List 的高度
		private var listHeight:Number;
		
		// List 的类型
		private var listType:String;
		// 滚动条布局
		private var scLocation:String;
		
		public function ListContainer(content:DisplayObject, listScrollBar:BaseScrollbar, listWidth:Number, listHeight:Number, sclocation:String = "right")
		{
			super();
			
			this.listWidth = listWidth;
			this.listHeight = listHeight;
			this.scLocation = sclocation;
			this.content = content;
			this.listScrollBar = listScrollBar;
			
			init();
			initListener();
		}
		
		private function init():void
		{
			scmask.graphics.clear();
			scmask.graphics.beginFill(0x000000);
			scmask.graphics.drawRect(0, 0, listWidth, listHeight);
			scmask.graphics.endFill();
			
			this.addChild(scmask);
			
			listScrollBar.scrollmask = scmask;
			this.addChild(content);
			this.addChild(listScrollBar);
			
			if (scLocation == "right")
			{
				listScrollBar.x = this.listWidth - listScrollBar.width;
			}
			else if(scLocation == "left")
			{
				listScrollBar.x = 0;
				content.x = listScrollBar.width;
			}
			else if(scLocation == "top")
			{
				listScrollBar.y = 0;
				content.x = listScrollBar.height;
			}
			else if(scLocation == "bottom")
			{
				listScrollBar.y = this.listHeight - listScrollBar.height;
			}
			
			var type:String = (scLocation == "left" || scLocation == "right") ? "VScrollBar" : "HScrollBar";
			listScrollBar.init(content, this.listWidth, this.listHeight, type);
		}
		
		private function initListener():void
		{
//			this.addEventListener(ListRelatedEvent.LIST_HEIGHT_CHANGED, onHeightChange);
		}
		
//		protected function onHeightChange(evt:ListRelatedEvent):void
//		{
//			listScrollBar.update();
//		}
		
		/**
		 * 清空 LIST
		 * 
		 */		
		public function clearList():void
		{
			if(content is BaseList)
			{
				(content as BaseList).clear();
			}
			listScrollBar.clear();
		}
	}
}