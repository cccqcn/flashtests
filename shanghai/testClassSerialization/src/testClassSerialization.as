package
{
	import flash.display.Sprite;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import pak.Test2VO;
	import pak.aa.TestVO;
	
	public class testClassSerialization extends Sprite
	{
		public function testClassSerialization()
		{
			var a:Test2VO = new Test2VO;
			registerClassAlias("pak.aa.TestVO", TestVO);
			registerClassAlias("pak.Test2VO", Test2VO);
			var barr:ByteArray = new ByteArray;
			barr.writeObject(a);
			barr.position = 0;
			var b:Object = barr.readObject();
			var barr2:ByteArray = new ByteArray;
		}
	}
}