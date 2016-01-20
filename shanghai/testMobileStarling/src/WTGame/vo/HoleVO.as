package WTGame.vo
{
	public class HoleVO
	{
		public var color:uint;
		public var size:int;
		public var asset:String;
		
		public function HoleVO(color:uint, size:int, asset:String)
		{
			this.color = color;
			this.size = size; 
			this.asset = asset;
		}
	}
}