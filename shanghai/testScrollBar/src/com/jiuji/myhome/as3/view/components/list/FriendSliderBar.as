package com.jiuji.myhome.as3.view.components.list
{
	import com.jiuji.myhome.as3.view.ChatSlideBarThumb;
	import com.jiuji.myhome.as3.view.ChatSlideBarTrack;
	import com.jiuji.myhome.as3.view.FriendSlideBarThumb;
	import com.jiuji.myhome.as3.view.FriendSlideBarTrack;
	
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	
	/**
	 * 
	 * @author chenchao
	 * 
	 */
	public class FriendSliderBar extends BaseScrollbar
	{
		public function FriendSliderBar()
		{
			var thumb:FriendSlideBarThumb = new FriendSlideBarThumb();
			var track:FriendSlideBarTrack = new FriendSlideBarTrack();
			
			super(track, thumb, false);
		}
	}
}