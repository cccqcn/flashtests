package
{
	import com.jiuji.fly.as3.base3d.camera.BaseCamera;
	import com.jiuji.fly.as3.base3d.camera.StateOverLook;
	import com.jiuji.fly.as3.base3d.core.SceneManager;
	import com.jiuji.fly.as3.base3d.model.BaseModel3D;
	import com.jiuji.fly.as3.utils.EkoFPS;
	
	import flare.core.Pivot3D;
	import flare.primitives.Cube;
	import flare.system.Device3D;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class FridgeTest extends Sprite
	{
		private var s:SceneManager = new SceneManager;
		private var p:Pivot3D = new Pivot3D;
		private var c:BaseCamera;
		private var cube:Cube = new Cube();
		private var m1:BaseModel3D;
		
		public function FridgeTest()
		{
			super();
			
			// support autoOrients
//			stage.align = StageAlign.TOP_LEFT;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			this.addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		private function onadd(e:Event):void
		{
//			this.x = -300;
			s.init(this, false, true);
			var m:Pivot3D = s.scene.addChildFromFile("binggui_two.f3d");
			
			m.y = -250;
			p.y = 220;
			c = s.addCamera("aaa", 5000, p);
//			var overlook:StateOverLook = new StateOverLook(p, -300, 0.005);
//			overlook.execute(c);
			c.copyTransformFrom(m);
			c.translateZ(-500);
			s.useCamera("aaa");
			addEventListener(Event.ENTER_FRAME, update);
			cube.parent = Device3D.scene;
			var fps:EkoFPS = new EkoFPS;
			addChild(fps);
		}
		public function update(e:Event):void
		{
			
		}
	}
}