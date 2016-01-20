package WTGame.ui
{
	import WTGame.Main;
	import WTGame.utils.GraphicsUtils;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class EndView extends Sprite
	{
		public var endTxt:TextField;
		public var replayBtn:Button;
		public var backBtn:Button;
		
		public function EndView()
		{
			super();
			endTxt = new TextField(350, 50, "GAME OVER", "Verdana", 22, 0x00FFFF, true);
			endTxt.x = (Main.starling.stage.stageWidth - endTxt.width) / 2;
			endTxt.y = (Main.starling.stage.stageHeight - endTxt.height) / 2 - 100;
			addChild(endTxt);
			replayBtn = new Button(Texture.fromBitmapData(GraphicsUtils.getButton()), "Replay");
			replayBtn.x = (Main.starling.stage.stageWidth - replayBtn.width) / 2;
			replayBtn.y = (Main.starling.stage.stageHeight - replayBtn.height) /2;
			addChild(replayBtn);
			backBtn = new Button(Texture.fromBitmapData(GraphicsUtils.getButton()), "Back");
			backBtn.x = (Main.starling.stage.stageWidth - backBtn.width) / 2;
			backBtn.y = (Main.starling.stage.stageHeight - backBtn.height) /2 + 100;
			addChild(backBtn);
		}
	}
}