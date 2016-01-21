package  
{
	import flare.system.Device3D;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class EkoFPS extends Sprite
	{
		private var txtFps:TextField;
		private var mem:Number=0;
		private var mem_max:Number=0;
		
		private var WIDTH : uint = 150;
		private var HEIGHT : uint = 110;
		
		public function EkoFPS()
		{
			this.graphics.beginFill(0x202020);
			this.graphics.drawRect(0,0,WIDTH,HEIGHT);
			this.graphics.endFill();
			txtFps=new TextField();
			txtFps.defaultTextFormat = new TextFormat("Tahoma", 12);
			txtFps.textColor=0xffff00;
			txtFps.text="FPS:";
			txtFps.width=WIDTH;
			txtFps.height=HEIGHT;
			txtFps.mouseEnabled=false;
			txtFps.selectable=false;
			this.addChild(txtFps);
			
			var timer:Timer=new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER,onTimer);
			timer.start();
		}
		private function onTimer(e:TimerEvent):void
		{
			if(Device3D.scene!=null)
			{
				txtFps.text="FPS:"+Device3D.scene.rendersPerSecond+"/"+Device3D.scene.frameRate+"/"+stage.frameRate;
				txtFps.appendText("\nOBJ:"+Device3D.objectsDrawn);
				txtFps.appendText("\nTRI:"+Device3D.trianglesDrawn);
				mem=Number((System.totalMemory*0.000000954).toFixed(3));
				txtFps.appendText("\nMEM:"+mem);
				if(mem>mem_max) mem_max=mem;
				txtFps.appendText("\nMAX:"+mem_max);
				var stage3DAvailable:Boolean = stage.hasOwnProperty("stage3Ds");
				if(stage3DAvailable) 
				{
					var stage3D:Stage3D = stage.stage3Ds[0];
					var context3D:Context3D = stage3D.context3D;
					var isHardwareAccelerated:Boolean = context3D.driverInfo.toLowerCase().indexOf("software") == -1;
					txtFps.appendText("\nHardware:" + isHardwareAccelerated );
					txtFps.appendText("\n" + context3D.driverInfo );
					
				}
			}
		}
	}
}