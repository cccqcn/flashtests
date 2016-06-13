package {
	import flash.display.*;
	import flash.events.*;
	public class Player extends Sprite {
		public var currentFrame:int = 1;
		public var totalFrames:int = 0;
		private var rate:int = 2;
		private var timer:int = 0;
		private var playflag:Boolean = true;
		private var mc:Array = new Array();
		
		public function Player():void
		{
			//addEventListener(Event.ENTER_FRAME, enterframe);
		}
		
		public function addFrameChild(bitmap:Bitmap):void
		{
			mc.push(bitmap);
			mc[totalFrames].visible=false;
			addChild(mc[totalFrames]);
			totalFrames++;
		}
		
		public function enterframe(e:Event):void
		{
			timer++;
			if(timer==rate)
			{
				timer=0;
			}
			else
			{
				return;
			}
			if(!totalFrames)return;
			var i:int;
			for(i=0;i<totalFrames;i++)
			{
				mc[i].visible=false;
			}
			mc[currentFrame-1].visible=true;
			if(!playflag)return;
			if(currentFrame==totalFrames)
			{
				currentFrame = 1;
			}
			else
			{
				currentFrame++;
			}
		}
		
		public function play():void
		{
			playflag = true;
		}
		
		public function stop():void
		{
			playflag = false;
		}
		
		public function gotoAndPlay(f:int):void
		{
			playflag = true;
			currentFrame=f;
		}
		
		public function gotoAndStop(f:int):void
		{
			playflag = false;
			currentFrame=f;
		}
	}
}