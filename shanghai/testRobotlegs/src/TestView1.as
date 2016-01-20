package
{
	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	import flare.primitives.Box;
	import flare.primitives.Plane;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class TestView1 extends Sprite
	{
		public function TestView1()
		{
			super();
			
			var scene:Scene3D = new Scene3D(this);
//			scene.addChild(new  Box);
			var plane:Plane = new Plane("plane", 5000, 5000, 10, null, "+xz");
			scene.addChild(plane);
			var camera:Camera3D = new Camera3D("myOwnCamera");
			camera.far = 200000;
			camera.setPosition(0, 1500, -1500);
			scene.camera = camera;
			scene.addEventListener(Scene3D.UPDATE_EVENT, updateEventHandler);
		}
		protected function updateEventHandler(event:Event):void
		{
			
		}
	}
}