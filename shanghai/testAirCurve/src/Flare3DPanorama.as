package
{
	import com.jiuji.demo.UI;
	
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	import flare.core.Texture3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureFilter;
	import flare.primitives.Sphere;
	import flare.system.Input3D;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	
	import net.hires.debug.Stats;
	
	[SWF(width='1024', height='750', backgroundColor='0x666666', frameRate='60')]
	public class Flare3DPanorama extends Sprite
	{
		
		private var sprite:Sprite;
		
		private var scene:Scene3D;		
		
		public var spinX:Number = 0;
		public var spinY:Number = 0;
		public var angleY:Number = 0;
		public var angleX:Number = 0;
		public var deltaSpeed:Number = 0;
		public var distance:Number = zoomMin;
		public var lookAt:Pivot3D = new Pivot3D();
		
		public var startY:Number = 20;
		public var startAngle:Number = 222;
		public var startAngleY:Number = -30;
		public var zoomMin:Number = -650;
		public var zoomMax:Number = 0;
		public var deltaValue:Number = 1;
		
		private var earth:Sphere;
		private var radius:Number = 1000;
		private var segments:int = 24;
		
		private var ui:UI;
		private var panWidth:int = 790;
		private var panHeight:int = 520;
		private var plusX:Number = 170;
		private var plusY:Number = 120;
		private var lastMouse:Boolean;
		private var lastMouseX:Number = 0;
		private var lastMouseY:Number = 0;
		private var move:Boolean=false;
		private var rToD:Number=180 / Math.PI;
		
		private var isAutorotate:Boolean=false;
		private var isLeft:Boolean=false;
		private var isRight:Boolean=false;
		private var isUp:Boolean=false;
		private var isDown:Boolean=false;
		private var zoomIn:Boolean=false;
		private var zoomOut:Boolean=false;
		
		private var xml:XML;
		
		private static var FOCUS:Number;
		private static var MIN_FOCUS:Number;
		private static var MAX_FOCUS:Number;
		private static var MIN_TILT_ANGLE:Number;
		private static var MAX_TILT_ANGLE:Number;
		private static var PAN_ANGLE:Number;
		private static var TILT_ANGLE:Number;
		
		private static var MOVE_SPEED:Number;
		private static var AUTOROTATE_SPEED:Number;
		private static var UPDOWN_SPEED:Number;
		private static var ZOOM_SPEED:Number;
		private static var WHEEL_SPEED:Number;
		
		public function Flare3DPanorama()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		private function onadd(e:Event):void
		{
			setUI();
		}
		private function setUI():void
		{
			ui = new UI();
			ui.container.scaleX = 2;
			ui.container.scaleY = 2;
			
			ui.btn.gotoAndStop(1);
//			ui.container.visible = false;
			
			var logo:logogif = new logogif();
			this.addChild(logo);
			logo.scaleX = 0.25;
			logo.scaleY = 0.25;
			logo.x = stage.stageWidth - logo.width + 140;
			logo.y = stage.stageHeight - logo.height - 100;
			
			loadXML();
		}
		
		private function loadXML():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest("panorama.xml");
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, loadXMLCompleteHandler);
		}
		
		private function loadXMLCompleteHandler(e:Event):void
		{
			ui.loading.stop();
			ui.removeChild(ui.loading);
			
			xml = new XML(e.target.data);
			
			FOCUS = xml.node.camera.focus;
			MIN_FOCUS = xml.node.camera.minFocus;
			MAX_FOCUS = xml.node.camera.maxFocus;
			MIN_TILT_ANGLE = xml.node.camera.minTiltAngle;
			MAX_TILT_ANGLE = xml.node.camera.maxTiltAngle;
			PAN_ANGLE = xml.node.camera.panAngle;
			TILT_ANGLE = xml.node.camera.tiltAngle;
			
			MOVE_SPEED = xml.node.controlSpeed.move;
			AUTOROTATE_SPEED = xml.node.controlSpeed.autoRotate;
			UPDOWN_SPEED = xml.node.controlSpeed.upDown;
			ZOOM_SPEED = xml.node.controlSpeed.zoom;
			WHEEL_SPEED = xml.node.controlSpeed.wheel;
			
			//			loadImage();
			initScene();
			mapSphere();
			initListeners();
			initMouse();
		}
		private function initScene():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
//			addChild(new Stats);
			ui.container.x = 20;
			ui.container.y = stage.stageHeight - ui.container.height / 2;
			ui.removeChild(ui.container);
			this.addChild(ui.container);
//			ui.mask = sprite;
			// creates and load the scene.
			scene = new Scene3D( this );
			scene.antialias = 2;
			scene.camera = new Camera3D( "myOwnCamera" );
			scene.camera.zoom = 1.3;
			
			// we can manipulate the camera just like any 3d object.
			scene.camera.setPosition( 0, 10, -000 );
			scene.camera.lookAt( 0, 0, 0 );
			
			scene.play();
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}
		private function mapSphere():void
		{
			var mat:Shader3D = new Shader3D();
			var tf:TextureFilter = new TextureFilter(new Texture3D("assets/pics/scene.jpg"));
//			tf.repeatX = 1;
//			tf.repeatY = 1;
			mat.twoSided = true;
			mat.enableLights = false;
			mat.filters = [tf];
			
			earth = new Sphere("earth",radius,segments,mat);
			earth.setMaterial(mat);
			scene.addChild(earth);
		}
		private function updateEvent(e:Event):void 
		{
			var speedX:Number = 0;
			var speedY:Number = 0;
			var downflag:Boolean = false;
			if ( Input3D.mouseDown ) {
				downflag = true;
				speedX = Input3D.mouseX - lastMouseX;
				speedY = Input3D.mouseY - lastMouseY;
				if(lastMouse == false)
				{
					speedX = 0;
					speedY = 0;
				}
				trace("a:", Input3D.mouseX, Input3D.mouseY);
				trace("b:", Input3D.mouseXSpeed, Input3D.mouseYSpeed);
				trace("c", speedX, speedY);
				lastMouseX = Input3D.mouseX;
				lastMouseY = Input3D.mouseY;
			}
			lastMouse = downflag;
			if(isAutorotate)
			{
				speedX = 0.5;
			}
			spinX += speedX * 0.035;
			spinY += speedY * 0.015;
			
			var delta:Number = Input3D.delta;
			if(zoomIn)
			{
				delta = 3;
			}
			if(zoomOut)
			{
				delta = -3;
			}
			if(isLeft)
			{
				spinX -= 0.3;
			}
			if(isRight)
			{
				spinX += 0.3;
			}
			if(isUp)
			{
				spinY -= 0.3;
			}
			if(isDown)
			{
				spinY += 0.3;
			}
			
			// apply some easing to the user rotations.
			spinX *= 0.93;
			spinY *= 0.93;
			angleY += spinX;
			angleX += spinY;
			
			deltaSpeed += delta / deltaValue;
			deltaSpeed *= 0.93;
			distance += deltaSpeed;
			if ( distance < zoomMin ) distance = zoomMin;
			else if ( distance > zoomMax ) distance = zoomMax;
			//trace(distance);
			
			// clamp ther camera with angles.
//			if ( angleY < MIN_TILT_ANGLE ) angleY = MIN_TILT_ANGLE;
//			else if ( angleY > MAX_TILT_ANGLE ) angleY = MAX_TILT_ANGLE;
			
			if ( angleX < MIN_TILT_ANGLE ) angleX = MIN_TILT_ANGLE;
			else if ( angleX > MAX_TILT_ANGLE ) angleX = MAX_TILT_ANGLE;
			
			// set the camera final result.
			lookAt.setRotation( angleX, angleY, 0 );
			scene.camera.copyTransformFrom( lookAt );
			scene.camera.translateZ( distance );
			
			if (mouseX > plusX + panWidth || mouseX < plusX || mouseY > plusY + panHeight || mouseY < plusY)
			{
				onMouseUp();
			}
		}		
		private function initListeners():void
		{
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//			this.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			ui.addEventListener(MouseEvent.MOUSE_OVER, arrowMouseOverHandler);
			ui.addEventListener(MouseEvent.MOUSE_OUT, arrowMouseOutHandler);
//			ui.container.addEventListener(MouseEvent.MOUSE_OVER, containerMouseOverHandler);
//			ui.container.addEventListener(MouseEvent.MOUSE_OUT, containerMouseOutHandler);
			
			ui.container.autorotate.addEventListener(MouseEvent.CLICK, autorotateClickHandler);
			ui.container.panleft.addEventListener(MouseEvent.MOUSE_DOWN, panleftDownHandler);
			ui.container.panleft.addEventListener(MouseEvent.MOUSE_UP, panleftUpHandler);
			ui.container.panright.addEventListener(MouseEvent.MOUSE_DOWN, panrightDownHandler);
			ui.container.panright.addEventListener(MouseEvent.MOUSE_UP, panrightUpHandler);
			ui.container.tiltup.addEventListener(MouseEvent.MOUSE_DOWN, panupDownHandler);
			ui.container.tiltup.addEventListener(MouseEvent.MOUSE_UP, panupUpHandler);
			ui.container.tiltdown.addEventListener(MouseEvent.MOUSE_DOWN, pandownDownHandler);
			ui.container.tiltdown.addEventListener(MouseEvent.MOUSE_UP, pandownUpHandler);
			ui.container.zoomin.addEventListener(MouseEvent.MOUSE_DOWN, zoominDownHandler);
			ui.container.zoomin.addEventListener(MouseEvent.MOUSE_UP, zoominUpHandler);
			ui.container.zoomout.addEventListener(MouseEvent.MOUSE_DOWN, zoomoutDownHandler);
			ui.container.zoomout.addEventListener(MouseEvent.MOUSE_UP, zoomoutUpHandler);
		}
		
		private function initMouse():void
		{
//			cursor = new Bitmap(new Cursor_MouseUp().bitmapData);
//			addChild(cursor);
//			
//			Mouse.hide();
		}
		private function onMouseDown(event:MouseEvent):void
		{
//			cursor.bitmapData = new Cursor_MouseDown().bitmapData;
			
			
			move = true;
			//isAutorotate = false;
			
			//stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			
			if (ui.introPanel.visible)
			{
				ui.introPanel.visible = false;
				ui.container.visible = true;
			}
		}
		private function onMouseUp(event:MouseEvent = null):void
		{
//			cursor.bitmapData = new Cursor_MouseUp().bitmapData;
			move = false;
		}
		
		private function arrowMouseOverHandler(e:MouseEvent):void
		{
//			Mouse.show();
//			cursor.visible = false;
		}
		
		private function arrowMouseOutHandler(e:MouseEvent):void
		{
//			Mouse.hide();
//			cursor.visible = true;
		}
		
		
		private function autorotateClickHandler(event:MouseEvent):void
		{
			if (isAutorotate == true)
			{
				isAutorotate = false;
//				material.smooth = true;
				//this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			else
			{
				isAutorotate = true;
//				material.smooth = false;
				//this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
		}
		
		private function panleftDownHandler(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			isLeft = true;
			move = false;
		}
		
		private function panleftUpHandler(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			isLeft = false;
			move = true;
//			material.smooth = true;
		}
		
		private function panrightDownHandler(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			isRight = true;
			move = false;
		}
		
		private function panrightUpHandler(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			isRight = false;
			move = true;
//			material.smooth = true;
		}
		
		private function panupDownHandler(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			isUp = true;
			move = false;
		}
		
		private function panupUpHandler(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			isUp = false;
			move = true;
//			material.smooth = true;
		}
		
		private function pandownDownHandler(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			isDown = true;
			move = false;
		}
		
		private function pandownUpHandler(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			isDown = false;
			move = true;
//			material.smooth = true;
		}
		
		private function zoominDownHandler(event:MouseEvent):void
		{
			zoomIn = true;
		}
		
		private function zoominUpHandler(event:MouseEvent):void
		{
			zoomIn = false;
//			material.smooth = true;
		}
		
		private function zoomoutDownHandler(event:MouseEvent):void
		{
			zoomOut = true;
		}
		
		private function zoomoutUpHandler(event:MouseEvent):void
		{
			zoomOut = false;
//			material.smooth = true;
		}
	}
}