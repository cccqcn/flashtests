package WTGame.roles
{
	import WTGame.Constant;
	import WTGame.utils.GameRule;
	import WTGame.utils.GraphicsUtils;
	import WTGame.vo.HoleVO;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Image;
	import starling.textures.Texture;

	public class Hole extends Role
	{
		public var image:Image;
		public var type:int;
		public var prop:HoleVO;
		
		public function Hole(x:int, y:int, type:int)
		{
			super();
			this.x = x;
			this.y = y;
			this.type = type;
			this.prop = GameRule.getHoleProps(type);
		}
		public function init(texture:Texture):void
		{
//			var texture:Texture = Texture.fromBitmapData(GraphicsUtils.getHole(prop.color));
			//			line = new starling.display.Shape;
			//			addChild(line);
			image = new Image(texture);
			addChild(image);
			this.collisionArea = new Rectangle(x, y, texture.width, texture.height);
		}
		override public function enterFrame():void
		{
			super.enterFrame();
		}
		
		public function canEnterHole(p:Point, lastPoint:Point):Boolean
		{
			if(this.collisionArea.containsPoint(p))
			{
				if(this.type == Constant.HOLE_A)
				{
					if(lastPoint.y < this.collisionArea.y && 
						lastPoint.x > this.collisionArea.x + this.collisionArea.width / 2 && 
						lastPoint.x < this.collisionArea.x + this.collisionArea.width)
					{
						return true;
					}
					return false;
				}
				else
				{
					return true;
				}
			}
			return false;
		}
	}
}