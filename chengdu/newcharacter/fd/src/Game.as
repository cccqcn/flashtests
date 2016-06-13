package {
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	public class Game extends Sprite {

		private var players:Array;

		public function Game():void 
		{
			initPlayer();
			addEventListener(Event.ENTER_FRAME, enterframe);
		}
		
		private function enterframe(e:Event):void
		{
			var i:int;
			var xx:int;
			for(i=0;i<players.length;i++)
			{
				(players[i] as APlayer).enterframe(e);
				if(Math.random()>0.9)
				{
					players[i].forward = int(Math.random()*4);
				}
				players[i].backward(90,100,90+360,100+190);
				players[i].moveon();
				if(Math.random()<.5)
				{
					players[i].filters=new Array(new GlowFilter(int(Math.random()*100000),1,5,5,2,1,false));
				}
				else
				{
					players[i].filters=null;
				}
			}
		}
		
		private function initPlayer():void
		{
			
			var w:int=12;
			var h:int=8;
			var ww:int=40;
			var hh:int=35;
			var bitmapData:BitmapData=BmpProcess.transparent(BmpProcess.rank(Main.abc,1,1).shift(),1,1);
			var bitmap:Bitmap=new Bitmap(bitmapData);
			var mc:Array=BmpProcess.rank(bitmap,w,h);
			var playermc:Array=new Array();
			var m:Player;

			var i:int;
			var image:Bitmap;
			for (i=0; i<w*h; i+=3) {
				m=new Player();
				image=new Bitmap(mc[i]);
				m.addFrameChild(image);
				image=new Bitmap(mc[i+1]);
				m.addFrameChild(image);
				image=new Bitmap(mc[i+2]);
				m.addFrameChild(image);
				m.gotoAndPlay(1);
				playermc.push(m);
			}
			trace(playermc.length);
			players = new Array;
			var a:APlayer;
			var j:int;
			for(i=0;i<8;i++)
			{
				j=i<4?i:(i+12);
				a=new APlayer;
				a.x=i%w*ww+100;
				a.y=int(i/w)*hh+200;
				a.addPlayer(playermc[j]);
				a.addPlayer(playermc[j+4]);
				a.addPlayer(playermc[j+8]);
				a.addPlayer(playermc[j+12]);
				a.forward = 1;
				a.addEventListener(MouseEvent.MOUSE_DOWN, down);
				a.addEventListener(MouseEvent.MOUSE_UP, up);
				addChild(a);
				players.push(a);
			}
		}

		private function down(e:MouseEvent):void {
			var a:APlayer = e.currentTarget;
			trace(a);
			a.forward++;
			a.startDrag();
		}
		private function up(e:MouseEvent):void {
			var a:APlayer = e.currentTarget;
			a.stopDrag();
		}
	}
}