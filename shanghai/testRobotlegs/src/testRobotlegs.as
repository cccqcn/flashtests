package
{
	import flash.display.Sprite;
	
	public class testRobotlegs extends Sprite
	{
		public function testRobotlegs()
		{
			var context:Context = new Context(this);
			
			var testView1:TestView1 = new TestView1;
			addChild(testView1);
		}
	}
}