package
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import flare.basic.Scene3D;
	import flare.core.Mesh3D;
	import flare.loaders.Flare3DLoader;
	import flare.materials.Shader3D;
	import flare.system.Device3D;
	import flare.system.Input3D;
	import flare.utils.Pivot3DUtils;
	
	import gear.socket.SocketClient;

	public class MyTank extends Tank
	{
		private var isMoving:Boolean = false;
		private var client:SocketClient;
		
		private var timer:Timer = new Timer(30);
		
		public function MyTank(url:String, client:SocketClient)
		{
			super();
			
			this.client = client;
			
			model = new Flare3DLoader(url);
			model.addEventListener(Scene3D.COMPLETE_EVENT, loadComplete);
			Device3D.scene.library.push(model as Flare3DLoader);
		}
		
		private function loadComplete(event:Event):void
		{
			model.removeEventListener(Scene3D.COMPLETE_EVENT, loadComplete);
			
			model = model.children[0];
			this.addChild(model);
			paotai = model.getChildByName("paotai");
			lvdaiMaterial = (model.getChildByName("lvdai") as Mesh3D).getMaterialByName("lvdai") as Shader3D;
			
			this.dispatchEvent(new Event("ok"));
			
			timer.addEventListener(TimerEvent.TIMER, sendTankInfo);
		}
		
		override public function startMoving():void
		{
			super.startMoving();
			
			sendLocationInfo(2);
		}
		
		override protected function updateEvent(event:Event):void
		{
			if (Input3D.keyDown(Input3D.W))
				isWDown = true;
			if (Input3D.keyUp(Input3D.W))
				isWDown = false;
			
			if (Input3D.keyDown(Input3D.A))
				isADown = true;
			if (Input3D.keyUp(Input3D.A))
				isADown = false;
			
			if (Input3D.keyDown(Input3D.S))
				isSDown = true;
			if (Input3D.keyUp(Input3D.S))
				isSDown = false;
			
			if (Input3D.keyDown(Input3D.D))
				isDDown = true;
			if (Input3D.keyUp(Input3D.D))
				isDDown = false;
			
			super.updateEvent(event);
			
			if (isWDown || isADown || isSDown || isDDown)
			{
				if (!isMoving)
				{
					// 一开始发送一次
					sendLocationInfo(0);
					timer.start();
					isMoving = true;
				}
				else
				{
					// 移动过程中的数据的发送
					sendLocationInfo(1);
				}
			}
			else
			{
				if (isMoving)
				{
					timer.stop();
					// 最后再发送一次
					sendLocationInfo(2);
					isMoving = false;
				}
			}
			
			Pivot3DUtils.setPositionWithReference(Device3D.scene.camera, 0, 300, -350, this, 0.07);
			Pivot3DUtils.lookAtWithReference(Device3D.scene.camera, 0, 0, 0, this);
		}
		
		private function sendTankInfo(event:TimerEvent):void
		{
			sendLocationInfo(1);
		}
		
		private function sendLocationInfo(action:int):void
		{
			client.call("location", this.name,
				String(this.x), String(this.z),
				String(this.getDir().x), String(this.getDir().z),
				String(paotai.getDir().x), String(paotai.getDir().z),
				Input3D.keyDown(Input3D.W), Input3D.keyDown(Input3D.S), Input3D.keyDown(Input3D.A), Input3D.keyDown(Input3D.D),
				action
			);
		}
	}
}