package WTGame.ui
{
	import WTGame.Main;
	import WTGame.utils.GraphicsUtils;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	
	public class InGameView extends Sprite
	{
		public var wormNums:TextField;
		public var highNums:TextField;
		private var items:Sprite;
		public var pauseBtn:Button;
		
		public function InGameView()
		{
			super();
			wormNums = new TextField(150, 20, "Worms:0", "Verdana", 12, 0xFFFFFF, true);
			wormNums.hAlign = HAlign.LEFT;
			addChild(wormNums);
			highNums = new TextField(150, 20, "HIGH:0", "Verdana", 12, 0xFFFFFF, true);
			highNums.x = Main.starling.stage.stageWidth - highNums.width;
			highNums.hAlign = HAlign.RIGHT;
			addChild(highNums);
			pauseBtn = new Button(Texture.fromBitmapData(GraphicsUtils.getButton()), "Pause");
			pauseBtn.x = Main.starling.stage.stageWidth - pauseBtn.width;
			pauseBtn.y = Main.starling.stage.stageHeight - pauseBtn.height;
			addChild(pauseBtn);
		}
	}
}