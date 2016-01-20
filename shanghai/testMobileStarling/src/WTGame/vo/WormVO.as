package WTGame.vo
{
	public class WormVO
	{
		public var color:uint;
		public var size:int;
		public var speed:Number;
		public var asset:String;
		public var frames:int;
		
		public function WormVO(color:uint, size:int, speed:Number, asset:String, frames:int = 1)
		{
			this.color = color;
			this.size = size;
			this.speed = speed;
			this.asset = asset;
			this.frames = frames;
		}
	}
}