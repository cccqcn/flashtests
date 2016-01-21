package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import flare.basic.Scene3D;
	import flare.loaders.Flare3DLoader1;
	import flare.materials.filters.AlphaMaskFilter;
	import flare.materials.filters.NormalMapFilter;
	import flare.materials.filters.SpecularFilter;
	import flare.primitives.Plane;
	
	import gear.socket.SocketClient;
	import gear.socket.SocketData;
	
	[SWF(width="1000", height="800", frameRate="30")]
	public class TankTest2 extends Sprite
	{
		private var scene:Scene3D;
		private var tank:MyTank;
		
		private var plane:Plane;
		
		private var tanks:Vector.<Tank> = new Vector.<Tank>();
		
		private var client:SocketClient = new SocketClient();
		private var data:SocketData = new SocketData("tank", "192.168.0.226", 22666);
		
		private var loadComplete:Boolean = false;
		private var socketComplete:Boolean = false;
		
		public function TankTest2()
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
			
			tank = new MyTank("assets/model/tank1.f3d", client);
			tank.addEventListener("ok", completeEvent);
			
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
		
		/*protected function onPlaneMove(event:MouseEvent3D):void
		{
			var dir:Vector3D = tank.globalToLocal(event.info.point);
			dir.y = 0;
			if (paotai)
				paotai.setOrientation(dir);
		}*/
		
		private function initScene():void
		{
			if (socketComplete && loadComplete)
			{
				// 镜头
				scene.camera.setPosition(0, 500, -500);
				scene.camera.lookAt(0, 0, 0);
				
				scene.addChild(tank);
				tank.setPosition(0, 0, 0);
				
				client.addCallback("call_login", callLogin);
				client.call("login");
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
		
		private function callLogin(id:int):void
		{
			tank.name = id.toString();
			tank.startMoving();
			
			client.addCallback("call_location", callLocation);
			client.addCallback("call_remove", callRemove);
		}
		
		private function callLocation(id:String, x:String, z:String, dirX:String, dirZ:String, paoDirX:String, paoDirZ:String
									  , isWDown:Boolean, isSDown:Boolean, isADown:Boolean, isDDown:Boolean, action:int):void
		{
			var tank1:Tank = getTank(id);
			if (!tank1)
			{
				tank1 = getNewTank(id);
				scene.addChild(tank1);
				tanks.push(tank1);
			}
			
			if (action == 0)
			{
				tank1.setState(Number(x), Number(z), Number(dirX), Number(dirZ), Number(paoDirX), Number(paoDirZ));
				tank1.startMoving();
			}
			else if (action == 1)
			{
				tank1.updateState(isWDown, isSDown, isADown, isDDown, Number(paoDirX), Number(paoDirZ));
			}
			else if (action == 2)
			{
				tank1.stopMoving();
			}
		}
		
		private function callRemove(id:String):void
		{
			var tank:Tank = getTank(id);
			if (tank)
				scene.removeChild(tank);
		}
		
		private function getNewTank(name:String):Tank
		{
			return tank.cloneModel(name);
		}
		
		private function getTank(name:String):Tank
		{
			if (tank.name == name)
				return tank;
			
			for each (var tank1:Tank in tanks)
			{
				if (tank1.name == name)
					return tank1;
			}
			
			return null;
		}
	}
}