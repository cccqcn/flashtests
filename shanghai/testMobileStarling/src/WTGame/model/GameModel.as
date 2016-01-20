package WTGame.model
{
	import WTGame.Constant;
	import WTGame.Main;
	import WTGame.roles.Hole;
	import WTGame.roles.Role;
	
	import flash.events.Event;
	
	import nape.constraint.PivotJoint;
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Circle;
	import nape.shape.Polygon;
	import nape.space.Space;
	import nape.util.ShapeDebug;
	
	import org.robotlegs.mvcs.Actor;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.utils.AssetManager;
	
	public class GameModel extends Actor
	{
		public var stage:Sprite;
		public var gameStatus:int;
		public var assets:AssetManager;
		
		public var space:Space;
		public var debug:ShapeDebug;
		public var mouse:Body;
		public var handJoint:PivotJoint;
		
		private var roleSprite:Sprite;
		public var roles:Array = [];
		public var holetest:Hole;
		
		public var wormTimer:int = 5000;
		public var score:int;
		public var highscore:int;
		
		public function GameModel()
		{
			super();
		}
		
		public function init(stage:Sprite):void
		{
			this.stage = stage;
			roleSprite = new Sprite;
			stage.addChild(roleSprite);
			
			space = new Space();
			debug = new ShapeDebug(Main.stage.stageWidth, Main.stage.stageHeight);
			Main.stage.addChild(debug.display);
			
			mouse = new Body(BodyType.DYNAMIC, new Vec2(50, 50));
			mouse.shapes.add(new Circle(2));
			mouse.space = space;
			handJoint = new PivotJoint(space.world, null, Vec2.weak(), Vec2.weak());
			handJoint.space = space;
			handJoint.active = false;
			handJoint.stiff = false;
		}
		
		public function addScore(n:int):void
		{
			score += n;
			this.dispatch(new flash.events.Event(Constant.EVENT_WORM_ENTER));
		}
		
		public function addRole(r:Role):void
		{
			roleSprite.addChild(r);
			roles.push(r);
		}
		public function removeRole(r:Role):void
		{
			r.dispose();
			if(r.parent == roleSprite)
			{
				roleSprite.removeChild(r);
			}
			var index:int = roles.indexOf(r);
			if(index != -1)
			{
				roles.splice(index, 1);
			}
		}
		public function removeAllRole():void
		{
			var r:Role;
			for each(r in roles)
			{
				r.dispose();
				if(r.parent == roleSprite)
				{
					roleSprite.removeChild(r);
				}
			}
			roles.splice(0, roles.length);
		}
	}
}