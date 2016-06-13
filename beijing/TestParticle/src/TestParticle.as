package
{
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import starling.core.Starling;
	
	[SWF(width="1050", height="700", frameRate="60", backgroundColor="#000000", wmode="direct")]
	public class TestParticle extends Sprite
	{
		public function TestParticle()
		{
			addEventListener(Event.ADDED_TO_STAGE, onadd);
		}
		
		protected function onadd(event:Event):void
		{
			// TODO Auto-generated method stub
			var sp:Sprite = new Sprite;
			sp.graphics.beginFill(0xFFF000, 1);
			sp.graphics.drawRect(0, 0, 500, 300);
			sp.graphics.endFill();
			addChild(sp);
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			var s:Starling = new Starling(StarlingTest, stage);
			s.start();
		}
	}
}