package
{
	import com.bit101.components.PushButton;
	
	import flare.basic.Scene3D;
	import flare.primitives.Cube;
	import flare.system.Device3D;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	
	public class testGPU extends Sprite
	{
		protected var context3D:Context3D;
		private var btns:Array = [];
		private var tt:int;
		public function testGPU()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, onadd);
			addChild(new Stats);
		}
		
		protected function initStage3D(e:Event):void 
		{ 
			context3D = stage.stage3Ds[0].context3D; 
			btns[0].label = context3D.driverInfo;
		}
		
		protected function enterframe(event:Event):void
		{
			// TODO Auto-generated method stub
			tt++;
			if(Device3D.scene && Device3D.scene.context)
			{
				btns[0].label = Device3D.scene.context.driverInfo;
			}
			var i:int;
			for(i=0;i<btns.length;i++)
			{
				var btn:PushButton = btns[i];
				btn.visible = !btn.visible;
			}
		}
		protected function onadd(event:Event):void
		{
//			var stage3D:Stage3D = stage.stage3Ds[0];stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initStage3D ); 
//			stage.stage3Ds[0].requestContext3D(Context3DRenderMode.SOFTWARE); 
			var scene:Scene3D = new Scene3D(this);
			scene.addChild(new Cube);

			// TODO Auto-generated method stub
			var i:int;
			for(i=0;i<100;i++)
			{
				var btn:PushButton = new PushButton(this, int(i / 20) * 110, (i % 20) * 30, i.toString());
				btn.addEventListener(MouseEvent.MOUSE_OVER, onover);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onout);
				btns.push(btn);
			}
			for(i=0;i<1000;i++)
			{
				var btn:PushButton = new PushButton(this, int(i / 20) * 110, (i % 20) * 30, i.toString());
				btn.addEventListener(MouseEvent.MOUSE_OVER, onover);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onout);
				btns.push(btn);
			}
			for(i=0;i<1000;i++)
			{
				var btn:PushButton = new PushButton(this, int(i / 20) * 110, (i % 20) * 30, i.toString());
				btn.addEventListener(MouseEvent.MOUSE_OVER, onover);
				btn.addEventListener(MouseEvent.MOUSE_OUT, onout);
				btns.push(btn);
			}
			addEventListener(Event.ENTER_FRAME, enterframe);
		}
		
		protected function onout(event:MouseEvent):void
		{
			var btn:PushButton = event.currentTarget as PushButton;
			btn.filters = [];
			btn.alpha = 1;
		}
		protected function onover(event:MouseEvent):void
		{
			// TODO Auto-generated method stub
			var btn:PushButton = event.currentTarget as PushButton;
			btn.filters = [new GlowFilter(0xFF0000)];
			btn.alpha = 0.5;
		}
	}
}