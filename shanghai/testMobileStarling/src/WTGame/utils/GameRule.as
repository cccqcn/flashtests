package WTGame.utils
{
	import WTGame.Constant;
	import WTGame.vo.HoleVO;
	import WTGame.vo.WormVO;

	public class GameRule
	{
		public static function getWormProps(wormtype:int):WormVO
		{
			var vo:WormVO;
			switch(wormtype)
			{
				case Constant.WORM_A:
					vo = new WormVO(0xFF0000, 12, 20, "bee", 2);
					break;
				case Constant.WORM_B:
					vo = new WormVO(0xFFF000, 10, 40, "piaochong", 11);
					break;
				case Constant.WORM_C:
					vo = new WormVO(0x000000, 14, 60, "chong", 12);
					break;
				case Constant.WORM_D:
					vo = new WormVO(0x00FF00, 8, 80, "mayi1", 11);
					break;
				case Constant.WORM_E:
					vo = new WormVO(0x0000FF, 11, 100, "mayi2", 7);
					break;
				case Constant.WORM_F:
					vo = new WormVO(0x0000FF, 11, 100, "bird", 43);
					break;
			}
			return vo;
		}
		public static function getHoleProps(holetype:int):HoleVO
		{
			var vo:HoleVO;
			switch(holetype)
			{
				case Constant.HOLE_A:
					vo = new HoleVO(0xFF0000, 12, "hole1");
					break;
				case Constant.HOLE_B:
					vo = new HoleVO(0xFFFFFF, 12, "hole2");
					break;
				case Constant.HOLE_C:
					vo = new HoleVO(0xFFF000, 12, "hole30000");
					break;
			}
			return vo;
		}
		
		public static function isWormInHole(wormtype:int, holetype:int):Boolean
		{
			switch(holetype)
			{
				case Constant.HOLE_A:
					if(wormtype == Constant.WORM_A || wormtype == Constant.WORM_B)
					{
						return true;
					}
					break;
				case Constant.HOLE_B:
					if(wormtype == Constant.WORM_C || wormtype == Constant.WORM_D)
					{
						return true;
					}
					break;
				case Constant.HOLE_C:
					if(wormtype == Constant.WORM_E)
					{
						return true;
					}
					break;
			}
			return false;
		}
	}
}