package WTGame.roles
{
	import WTGame.Main;
	import WTGame.model.GameModel;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	public class HoleMediator extends StarlingMediator
	{
		[Inject]
		public var view:Hole;
		
		[Inject]
		public var model:GameModel;
		
		private var enterHole:Boolean;
		
		
		override public function onRegister():void
		{
			view.init(model.assets.getTexture(view.prop.asset));
			var body:Body = new Body(BodyType.STATIC, new Vec2(view.collisionArea.x * Main.starling.viewPort.width / Main.starling.stage.stageWidth + Main.starling.viewPort.x, view.collisionArea.y * Main.starling.viewPort.height / Main.starling.stage.stageHeight + Main.starling.viewPort.y));
			body.shapes.add(new Polygon(Polygon.rect(0, 0, view.collisionArea.width, view.collisionArea.height)));
			body.space = model.space;
		}
	}
}