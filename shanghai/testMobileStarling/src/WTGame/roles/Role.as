package WTGame.roles
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Sprite;
	
	public class Role extends Sprite
	{
		public var collisionArea:Rectangle;
		public var touchStatus:int;
		public var nearRoles:Array = [];
		
		public function Role()
		{
			super();
		}
		
		public function get posX():Number
		{
			return 0;
		}
		public function get posY():Number
		{
			return 0;
		}
		
		public function enterFrame():void
		{
			
		}
		
		public function containsRole(role:Role):void
		{
			
		}
		public function containedByRole(role:Role):void
		{
			
		}
	}
}