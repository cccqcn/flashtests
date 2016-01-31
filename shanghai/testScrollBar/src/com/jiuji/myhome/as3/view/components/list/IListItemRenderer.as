package com.jiuji.myhome.as3.view.components.list
{
	public interface IListItemRenderer
	{
		function updateItem(params:*):void;
		function changeIndex():void;
		function getIndex():int;
		function dispose():void;
	}
}