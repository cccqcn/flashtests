package com.jiuji.myhome.as3.view.components.list
{
//	import com.jiuji.myhome.as3.events.ListRelatedEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class BaseList extends Sprite
	{
		// 数据源
		protected var _dataProvider:Array = new Array();
		
		public function get dataProvider():Array
		{
			return _dataProvider;
		}
		
		/**
		 * 更新整个列表
		 * @param value
		 * 
		 */		
		public function set dataProvider(value:Array):void
		{
			_dataProvider = value;
			this.updateItems();
		}
		
		protected var left:int = 0;
		protected var up:int = 0;
		protected var horizontalGap:int = 0;
		protected var verticalGap:int = 0;
		protected var horizontalRepeat:int = 1;
		
		protected var itemVector:Vector.<IListItemRenderer> = new Vector.<IListItemRenderer>();
		
		public function BaseList()
		{
			this.addEventListener(MouseEvent.CLICK, onListClicked);
		}
		
		/**
		 * 待重载
		 * @param event
		 * 
		 */		
		protected function onListClicked(event:MouseEvent):void
		{
		}
		
		protected function updateItems(isChangeOld:Boolean = true):void
		{
			var length:int = itemVector.length;
			
			if(dataProvider)
				for (var i:int = 0; i < dataProvider.length; i++)
				{
					if (i < length)
					{
						if (isChangeOld)
							itemVector[i].updateItem(dataProvider[i]);
					}
					else
					{
						var item:IListItemRenderer = createItem(i);
						this.addChild(item as DisplayObject);
						itemVector.push(item);
						
						var x:int = int(i % horizontalRepeat) * ((item as DisplayObject).width + horizontalGap) + left;
						var y:int;
						
						if (horizontalRepeat == 1)
						{
							if (i == 0)
								y = up;
							else
								y = (itemVector[i - 1] as DisplayObject).y + (itemVector[i - 1] as DisplayObject).height + verticalGap;
						}
						else
						{
							y = int(i / horizontalRepeat) * ((item as DisplayObject).height + verticalGap) + up;
						}
						
						(item as DisplayObject).x = x;
						(item as DisplayObject).y = y;
					}
				}
			
			if (i < length)
			{
				for (var j:int = length - 1; j >= i; j--)
				{
					this.removeChild(itemVector[j] as DisplayObject);
					var deleteItem:IListItemRenderer = itemVector.splice(j, 1)[0];
					deleteItem.dispose();
					deleteItem = null;
				}
			}
		}
		
		/**
		 * 待重载
		 * @return 
		 * 
		 */		
		protected function createItem(index:int):IListItemRenderer
		{
			return null;
		}
		
		/**
		 * 返回列表项数
		 * @return 
		 * 
		 */		
		public function getItemCount():int
		{
			return itemVector.length;
		}
		
		/**
		 * 增加一个 Item
		 * @param data
		 * 
		 */		
		public function addItem(data:*):void
		{
			dataProvider.push(data);
			this.updateItems(false);
		}
		
		/**
		 * 清空重置
		 * 
		 */		
		public function clear():void
		{
			for (var i:int = itemVector.length - 1; i >= 0; i--)
			{
				var item:IListItemRenderer = itemVector[i];
				this.removeChild(item as DisplayObject);
				itemVector.splice(i, 1);
				dataProvider.splice(i, 1);
				
				item.dispose();
				item = null;
			}
			
			itemVector = new Vector.<IListItemRenderer>();
			dataProvider = new Array();
		}
		
		/**
		 * 删除一个 Item
		 * @param index
		 * 
		 */		
		public function deleteItem(index:int):void
		{
			this.removeChild(itemVector[index] as DisplayObject);
			var deleteItem:IListItemRenderer = itemVector.splice(index, 1)[0];
			
			var itemWidth:Number = (deleteItem as DisplayObject).width;
			var itemHeight:Number = (deleteItem as DisplayObject).height;
			
			deleteItem.dispose();
			deleteItem = null;
			
			this.dataProvider.splice(index, 1);
			
			for (var i:int = index; i < itemVector.length; i++)
			{
				itemVector[i].changeIndex();
				
				if (horizontalRepeat > 1)
				{
					if (((itemVector[i].getIndex() + 1) % horizontalRepeat) == 0)
					{
						(itemVector[i] as DisplayObject).x += ((itemWidth + horizontalGap) * (horizontalRepeat - 1));
						(itemVector[i] as DisplayObject).y -= (verticalGap + itemHeight);
					}
					else
						(itemVector[i] as DisplayObject).x -= (horizontalGap + itemWidth);
				}
				else if (horizontalRepeat == 1)
				{
					(itemVector[i] as DisplayObject).y -= (verticalGap + itemHeight);
				}
			}
		}
		
		/**
		 * 更新一个 Item
		 * @param data
		 * @param index
		 * 
		 */		
		public function updateItem(data:*, index:int):void
		{
			itemVector[index].updateItem(data);
		}
		
		/**
		 * 获取一个 Item
		 * @param index
		 * 
		 */		
		public function getItem(index:int):IListItemRenderer
		{
			return itemVector[index];
		}
	}
}