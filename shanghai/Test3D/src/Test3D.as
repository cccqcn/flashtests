package
{
	import flare.basic.Scene3D;
	import flare.basic.Viewer3D;
	import flare.core.Camera3D;
	import flare.core.Label3D;
	import flare.core.Pivot3D;
	import flare.loaders.Flare3DLoader;
	import flare.loaders.Flare3DLoader1;
	import flare.loaders.Flare3DLoader2;
	import flare.materials.Material3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.AlphaMaskFilter;
	import flare.materials.filters.TextureFilter;
	import flare.primitives.Cube;
	import flare.system.ILibraryExternalItem;
	import flare.system.Input3D;
	import flare.utils.Pivot3DUtils;
	import flare.utils.Vector3DUtils;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	[SWF(frameRate = 60, backgroundColor = 0xFF0000)]
	public class Test3D extends Sprite
	{
		private var body:Pivot3D;
		private var run:Pivot3D;
		private var scene:Scene3D;
		public var distance:Number = 0;
		public var deltaSpeed:Number = 0;
		private var centerProxy:Pivot3D = new Pivot3D();
		private var centerPivot:Pivot3D = new Pivot3D();
		private var cameraOri:Vector3D;
		
		private var currentAction:String;
		
		/*[Embed(source = "assets/role/female-animation.f3d", mimeType = "application/octet-stream")]
		private var female-animation:Class;
		[Embed(source = "assets/role/femail_body_default-animation.f3d", mimeType = "application/octet-stream")]
		private var femail_body_default:Class;*/
		
		public function Test3D()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var sp:Sprite = new Sprite;
			sp.graphics.beginFill(0xFFF000);
			sp.graphics.drawCircle(0, 0, 50);
			sp.graphics.endFill();
			addChild(sp);
			sp.x = 450;
			sp.y = 50;
			sp.addEventListener(MouseEvent.CLICK, onAdd);
			
			var stats:Stats = new Stats;
			addChild(stats);
			var fps:EkoFPS = new EkoFPS;
			fps.x = 100;
			addChild(fps);
			
			scene = new Viewer3D( this );
//			scene.addChild( new Cube() );
			scene.camera.setPosition( 0, 0, -20 );
			
			scene.camera=new Camera3D();
			scene.registerClass(Flare3DLoader1);
			scene.registerClass(Flare3DLoader2);
			//			scene.registerClass(Flare3DLoader3);
			scene.camera.z=400;
			scene.camera.y=150;
			scene.camera.lookAt(0,0,-150);
			scene.registerClass(AlphaMaskFilter);
			
			run = new Flare3DLoader("assets/female-animation.f3d");
			
			scene.library.push(run as Flare3DLoader);
			scene.pause();
			
			var bgmodel:Pivot3D = new Flare3DLoader("assets/background.f3d");//scene.addChildFromFile("assets/background.f3d");
			scene.addChild(bgmodel);
			scene.library.push(bgmodel as Flare3DLoader);
			
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
			scene.addEventListener(Scene3D.COMPLETE_EVENT, onBg);
		}
		protected function onBg(e:Event):void
		{
			scene.resume();
		}
		private function onAdd(e:MouseEvent):void
		{
			loadRole();
		}
		public function loadRole():void
		{
//			scene.removeChild(body);
//			body.dispose();
			body = new Pivot3D;
			body = new Flare3DLoader("assets/female_body_default.f3d");
			scene.library.push(body as ILibraryExternalItem);
			
			scene.addEventListener(Scene3D.COMPLETE_EVENT, onCom);
		}
		protected function onCom(e:Event):void
		{
			scene.removeEventListener(Scene3D.COMPLETE_EVENT, onCom);
			body.setPosition(Math.random() * 200, Math.random() * 100, Math.random() * 200);
			addLabel(body);
			scene.addChild(body);
			body.setLayer(2);
//			this["body" + i].setLayer(2);
			var shader:Material3D = body.getMaterialByName("body");
			if (shader)
			{
//				((shader as Shader3D).filters[0] as TextureFilter).alpha = 0;
			}
			Pivot3DUtils.appendAnimation(body, run);
			if(currentAction == null)
			{
				currentAction = STAND_MOVEMENT;
			}
			body.gotoAndPlay(WALK_MOVEMENT);
		}
		private function resetCenterPivot():void
		{
			// 更新 centerPivot 的朝向
			var centerOri:Vector3D = centerPivot.getDir();
			if (centerOri.y != 0)
			{
				centerOri.y = 0;
				centerPivot.setOrientation(centerOri);
			}
		}
		private function updateEvent(e:Event):void 
		{
			if ( Input3D.mouseDown && Input3D.mouseMoved && Input3D.keyDown(Input3D.SHIFT) == false)
			{
				scene.camera.rotateY( Input3D.mouseXSpeed, false, Vector3DUtils.ZERO );
				scene.camera.rotateX( Input3D.mouseYSpeed, true, Vector3DUtils.ZERO );
			}
			deltaSpeed += Input3D.delta / 20;
			deltaSpeed *= 0.93;
			distance += deltaSpeed;
			scene.camera.translateZ( Input3D.delta );
		}
		
		
		public static const WALK_MOVEMENT:String = "行走";
		public static const TIRED_MOVEMENT:String = "弯腰走";
		public static const WAVE_MOVEMENT:String = "挥手";
		public static const EAT_MOVEMENT:String = "吃饭";
		public static const BOW_MOVEMENT:String = "鞠躬";
		public static const ABUSE_MOVEMENT:String = "咒骂";
		public static const SLEEP_MOVEMENT:String = "睡觉";
		public static const SIT_MOVEMENT:String = "坐";
		public static const SIT_DOWN_MOVEMENT:String = "坐下";
		public static const DANCE_MOVEMENT:String = "跳舞";
		public static const CHAT_MOVEMENT:String = "聊天";
		public static const HUG_MOVEMENT:String = "拥吻";
		public static const TALK_MOVEMENT:String = "耳语";
		public static const LAUGH_MOVEMENT:String = "捂嘴笑";
		public static const SLAP_MOVEMENT:String = "耳光";
		public static const COVERFACE_MOVEMENT:String = "捂脸";
		public static const KICK_MOVEMENT:String = "踢人";
		public static const COVERBELLY_MOVEMENT:String = "捂肚子";
		public static const WASH_MOVEMENT:String = "洗澡";
		public static const KISS_MOVEMENT:String = "亲";
		public static const STAND_MOVEMENT:String = "站立";
		public static const MUSIC_MOVEMENT:String = "音乐";
		public static const WRITE_MOVEMENT:String = "写作";
		public static const COOK_MOVEMENT:String = "烹饪";
		public static const PAINT_MOVEMENT:String = "绘画";
		public static const GARDEN_MOVEMENT:String = "园艺";
		public static const CLAP_MOVEMENT:String = "鼓掌";
		public static const BATH_MOVEMENT:String = "躺着洗澡";
		public static const CLEAN_MOVEMENT:String = "清理";
		public static const SIT_GROUND_MOVEMENT:String = "坐地上";
		public static const WASH2_MOVEMENT:String = "擦洗";
		public static const MEND_MOVEMENT:String = "修理";
		public static const AMAZING_MOVEMENT:String = "惊讶";
		private function addLabel(model:Pivot3D):void
		{
			model.addLabel(new Label3D(WALK_MOVEMENT, 2, 28));
			model.addLabel(new Label3D(STAND_MOVEMENT, 29, 69));
			model.addLabel(new Label3D(WAVE_MOVEMENT, 70, 113));
			model.addLabel(new Label3D(BOW_MOVEMENT, 114, 149));
			model.addLabel(new Label3D(ABUSE_MOVEMENT, 150, 194));
			model.addLabel(new Label3D(EAT_MOVEMENT, 195, 232));
			model.addLabel(new Label3D(SIT_MOVEMENT, 233, 285));
			model.addLabel(new Label3D(SIT_DOWN_MOVEMENT, 1186, 1262));
			model.addLabel(new Label3D(SLAP_MOVEMENT, 286, 309));
			model.addLabel(new Label3D(COVERFACE_MOVEMENT, 310, 333));
			model.addLabel(new Label3D(TALK_MOVEMENT, 334, 367));
			model.addLabel(new Label3D(CHAT_MOVEMENT, 368, 398));
			model.addLabel(new Label3D(SLEEP_MOVEMENT, 399, 462));
			model.addLabel(new Label3D(LAUGH_MOVEMENT, 463, 506));
			model.addLabel(new Label3D(HUG_MOVEMENT, 507, 554));
			model.addLabel(new Label3D(KISS_MOVEMENT, 555, 593));
			model.addLabel(new Label3D(KICK_MOVEMENT, 594, 624));
			model.addLabel(new Label3D(COVERBELLY_MOVEMENT, 625, 658));
			model.addLabel(new Label3D(WASH_MOVEMENT, 1376, 1464));
			model.addLabel(new Label3D(DANCE_MOVEMENT, 659, 757));
			model.addLabel(new Label3D(MUSIC_MOVEMENT, 793, 837));
			model.addLabel(new Label3D(WRITE_MOVEMENT, 838, 868));
			model.addLabel(new Label3D(COOK_MOVEMENT, 869, 931));
			model.addLabel(new Label3D(PAINT_MOVEMENT, 932, 991));
			model.addLabel(new Label3D(GARDEN_MOVEMENT, 992, 1017));
			model.addLabel(new Label3D(TIRED_MOVEMENT, 762, 792));
			model.addLabel(new Label3D(CLAP_MOVEMENT, 1093, 1133));
			model.addLabel(new Label3D(BATH_MOVEMENT, 1264, 1374));
			model.addLabel(new Label3D(CLEAN_MOVEMENT, 1466, 1493));
			model.addLabel(new Label3D(SIT_GROUND_MOVEMENT, 1495, 1535));
			model.addLabel(new Label3D(WASH2_MOVEMENT, 1537, 1569));
			model.addLabel(new Label3D(MEND_MOVEMENT, 1570, 1604));
			model.addLabel(new Label3D(AMAZING_MOVEMENT, 1605, 1712));
		}
		
	}
}