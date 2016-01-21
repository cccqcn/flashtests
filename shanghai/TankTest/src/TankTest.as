package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import flare.basic.Scene3D;
	import flare.core.Mesh3D;
	import flare.core.Pivot3D;
	import flare.events.MouseEvent3D;
	import flare.loaders.Flare3DLoader;
	import flare.loaders.Flare3DLoader1;
	import flare.materials.Shader3D;
	import flare.materials.filters.AlphaMaskFilter;
	import flare.materials.filters.NormalMapFilter;
	import flare.materials.filters.SpecularFilter;
	import flare.materials.filters.TextureFilter;
	import flare.primitives.Plane;
	import flare.system.Device3D;
	import flare.system.Input3D;
	import flare.utils.Pivot3DUtils;
	
	import gear.socket.SocketClient;
	import gear.socket.SocketData;
	
	[SWF(width="1000", height="800", frameRate="30")]
	public class TankTest extends Sprite
	{
		private var scene:Scene3D;
		private var tank:Pivot3D;
		private var paotai:Pivot3D;
		private var lvdaiMaterial:Shader3D;
		
		private var plane:Plane;
		
		private var tanks:Vector.<Pivot3D> = new Vector.<Pivot3D>();
		
		private var client:SocketClient = new SocketClient();
		private var data:SocketData = new SocketData("tank", "192.168.0.226", 22666);
		
		private var loadComplete:Boolean = false;
		private var socketComplete:Boolean = false;
		
		private var timer:Timer = new Timer(200);
		
		public function TankTest()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			initServer();
			
			scene = new Scene3D(this);
			scene.antialias = 4;
			
			scene.registerClass(AlphaMaskFilter);
			scene.registerClass(Flare3DLoader1);
			scene.registerClass(SpecularFilter);
			scene.registerClass(NormalMapFilter);
			
			//scene.clearColor.setTo(0.6, 0.6, 0.6);
			scene.lights.ambientColor.setTo(1, 1, 1);
			scene.lights.maxPointLights = 0;
			scene.defaultLight = null;
			
			//tank = scene.addChildFromFile("assets/model/tank1.f3d");
			tank = new Flare3DLoader("assets/model/tank1.f3d");
			Device3D.scene.library.push(tank as Flare3DLoader);
			scene.addEventListener(Scene3D.COMPLETE_EVENT, completeEvent);
			
			// 底面
			plane = new Plane("", 1000, 1000, 10, null, "+xz");
			scene.addChild(plane);
			
			this.addChild(new Stats());
		}
		
		protected function completeEvent(event:Event):void
		{
			loadComplete = true;
			initScene();
		}
		
		protected function onPlaneMove(event:MouseEvent3D):void
		{
			var dir:Vector3D = tank.globalToLocal(event.info.point);
			dir.y = 0;
			if (paotai)
				paotai.setOrientation(dir);
		}
		
		protected function updateEvent(event:Event):void
		{
			// 履带动画
			if (Input3D.keyDown(Input3D.W) || Input3D.keyDown(Input3D.S) || Input3D.keyDown(Input3D.A) || Input3D.keyDown(Input3D.D))
			{
				(lvdaiMaterial.filters[0] as TextureFilter).offsetX -= 0.1;
				lvdaiMaterial.build();
			}
			
			if (Input3D.keyDown(Input3D.W))
				tank.translateZ(8);
			if (Input3D.keyDown(Input3D.S))
				tank.translateZ(-8);
			
			if (Input3D.keyDown(Input3D.A))
				tank.rotateY(-1.5);
			if (Input3D.keyDown(Input3D.D))
				tank.rotateY(1.5);
			
			// 发送数据
			/*if (tank && tank.name != "")
			{
				client.call("location", tank.name,
					int(tank.x), int(tank.z),
					String(tank.getDir().x), String(tank.getDir().z),
					String(paotai.getDir().x), String(paotai.getDir().z)
					//, Input3D.keyDown(Input3D.W), Input3D.keyDown(Input3D.S), Input3D.keyDown(Input3D.A), Input3D.keyDown(Input3D.D)
				);
			}*/
			
			Pivot3DUtils.setPositionWithReference(scene.camera, 0, 300, -350, tank, 0.07);
			Pivot3DUtils.lookAtWithReference(scene.camera, 0, 0, 0, tank);
		}
		
		private function initScene():void
		{
			if (socketComplete && loadComplete)
			{
				// 镜头
				scene.camera.setPosition(0, 500, -500);
				scene.camera.lookAt(0, 0, 0);
				
				tank = tank.children[0];
				scene.addChild(tank);
				//tank.setPosition(Math.random() * 1000, 0, Math.random() * 1000);
				tank.setPosition(0, 0, 0);
				
				paotai = tank.getChildByName("paotai");
				lvdaiMaterial = (tank.getChildByName("lvdai") as Mesh3D).getMaterialByName("lvdai") as Shader3D;
				
				//scene.addEventListener(Scene3D.UPDATE_EVENT, updateEvent);
				
				plane.addEventListener(MouseEvent3D.MOUSE_MOVE, onPlaneMove);
				
				client.addCallback("call_login", callLogin);
				client.call("login");
				
				timer.addEventListener(TimerEvent.TIMER, sendTankInfo);
				timer.start();
			}
		}
		
		private function sendTankInfo(event:TimerEvent):void
		{
			if (tank && tank.name != "")
			{
				client.call("location", tank.name,
					int(tank.x), int(tank.z),
					String(tank.getDir().x), String(tank.getDir().z),
					String(paotai.getDir().x), String(paotai.getDir().z)
					//, Input3D.keyDown(Input3D.W), Input3D.keyDown(Input3D.S), Input3D.keyDown(Input3D.A), Input3D.keyDown(Input3D.D)
				);
			}
		}
		
		private function initServer():void
		{
			//client.addEventListener(SocketClient.IO_ERROR, gameServer_ioErrorHandler);
			//client.addEventListener(SocketClient.SECURITY_ERROR, gameServer_securityErrorHandler);
			//client.addEventListener(SocketClient.CLOSE, gameServer_closeHandler);
			client.addEventListener(Event.CONNECT, serverConnectedHandler);
			client.connect(data);
		}
		
		private function serverConnectedHandler(event:Event) : void {
			client.removeEventListener(Event.CONNECT, serverConnectedHandler);
			
			socketComplete = true;
			initScene();
		}
		
		private var tempValue:Number;
		
		private function callLogin(id:int):void
		{
			tank.name = id.toString();
			client.call("location", tank.name, int(tank.x), int(tank.z), String(tank.getDir().x), String(tank.getDir().z), String(paotai.getDir().x), String(paotai.getDir().z));
			
			client.addCallback("call_location", callLocation);
			client.addCallback("call_remove", callRemove);
			
			scene.addEventListener(Scene3D.UPDATE_EVENT, updateEvent);
		}
		
		private function callLocation(id:String, x:int, z:int, dirX:String, dirZ:String, paoDirX:String, paoDirZ:String):void
		{
			trace(getTimer() - tempValue);
			tempValue = getTimer();
			
			var tank1:Pivot3D = getTank(id);
			if (!tank1)
			{
				tank1 = getNewTank(id);
				scene.addChild(tank1);
				tanks.push(tank1);
			}
			
			tank1.x = x;
			tank1.z = z;
			tank1.setOrientation(new Vector3D(Number(dirX), 0, Number(dirZ)));
			tank1.getChildByName("paotai").setOrientation(new Vector3D(Number(paoDirX), 0, Number(paoDirZ)));
		}
		
		private function callRemove(id:String):void
		{
			var tank:Pivot3D = getTank(id);
			if (tank)
				scene.removeChild(tank);
		}
		
		private function getNewTank(name:String):Pivot3D
		{
			var newTank:Pivot3D = tank.clone();
			newTank.name = name;
			return newTank;
		}
		
		private function getTank(name:String):Pivot3D
		{
			if (tank.name == name)
				return tank;
			
			for each (var tank1:Pivot3D in tanks)
			{
				if (tank1.name == name)
					return tank1;
			}
			
			return null;
		}
	}
}