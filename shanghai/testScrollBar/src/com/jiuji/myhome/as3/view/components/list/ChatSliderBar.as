package com.jiuji.myhome.as3.view.components.list
{
	import com.jiuji.myhome.as3.view.ChatSlideBarThumb;
	import com.jiuji.myhome.as3.view.ChatSlideBarTrack;
	
	import flash.display.MovieClip;
	
	/**
	 * 
	 * @author chenchao
	 * 
	 */
	public class ChatSliderBar extends BaseScrollbar
	{
		public function ChatSliderBar()
		{
			var thumb:ChatSlideBarThumb = new ChatSlideBarThumb();
			var track:ChatSlideBarTrack = new ChatSlideBarTrack();
			
			super(track, thumb, true);
		}
	}
}