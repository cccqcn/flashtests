package
{
	import Anima.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	[SWF(width="1000",height="600", frameRate="30")]
	public class testAnima extends Sprite
	{
		[Embed(source="ground.jpg")]
		public static var Ground:Class;
		[Embed(source="image 1.png")]
		public static var Image1:Class;
		[Embed(source="res_viewer.png")]
		public static var Role:Class;
		
		private var scene:Sprite;
		private var SPEED:int = 3;
		
		private var ld:Loader = new Loader;
		private var bitmap:Bitmap;
		private var i:int;
		
		private var key:Object = {};
		
		public function testAnima()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		private function onadd(e:Event):void
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, ondown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onup);
			onloadimg();
			//ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadimg);
			//ld.load(new URLRequest("ground.jpg"));
		}
		private function onloadimg(e:Event = null):void
		{
			var obj:Aniobj;
			obj = new Aniobj();
			if(e)
			{
				obj.graphics = Bitmap(ld.content).bitmapData;
			}
			else
			{
				obj.graphics = new Ground().bitmapData;
			}
			scene = new Sprite;
			addChild(scene);
			Animain.instance.startup(scene, obj.graphics.width, obj.graphics.height, 550, 400);
			
			onloadimg2();
			
			//ld.contentLoaderInfo.removeEventListener(Event.COMPLETE, onloadimg);
			//ld.contentLoaderInfo.addEventListener(Event.COMPLETE, onloadimg2);
			//ld.load(new URLRequest("image 1.png"));
		}
		private function onloadimg2(e:Event = null):void
		{
			this.stage.focus = this;
			
			if(e)
			{
				bitmap = Bitmap(ld.content);
			}
			else
			{
				bitmap = new Image1();
			}
			//addobj(new Point(0, 260));
		}
		private function addobj(pos:Point):void
		{
			var obj:Aniobj;
			obj = new Aniobj();
			obj.realpos = pos;
			obj.graphics = bitmap.bitmapData;
			obj.fps = 25;
			obj.frames = 25;
			if(0)
			{
				obj.addEventListener(Event.ENTER_FRAME, onenter);
				obj.data = SPEED;
			}
			i++;
		}
		private function onenter(e:Event):void
		{
			var obj:Aniobj = Aniobj(e.currentTarget);
			obj.realpos.y += obj.data;
			if(obj.realpos.y > 450)
			{
				obj.data = -SPEED;
			}
			else if(obj.realpos.y < 200)
			{
				obj.data = SPEED;
			}
			if(i < 1)
			{
				addobj(new Point(Math.random()*800, 200+Math.random()*250));
			}
		}
		
		private function ondown(e:KeyboardEvent):void
		{
			if(key[e.keyCode] == null)
			{
				key[e.keyCode] = getTimer();
			}
		}
		private function onup(e:KeyboardEvent):void
		{
			var d:int = (getTimer() - key[e.keyCode]) / 20;
			var t:int;
			key[e.keyCode] = null;
		}
	}
}