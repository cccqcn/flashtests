package WTGame.ui
{
	import WTGame.Main;
	import WTGame.utils.GraphicsUtils;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	public class PausingView extends Sprite
	{
		public var resumeBtn:Button;
		public var pauseTxt:TextField;
		public var backBtn:Button;
		
		public function PausingView()
		{
			super();
			pauseTxt = new TextField(150, 50, "PAUSED", "Verdana", 22, 0xFF0000, true);
			pauseTxt.x = (Main.starling.stage.stageWidth - pauseTxt.width) / 2;
			pauseTxt.y = (Main.starling.stage.stageHeight - pauseTxt.height) / 2 - 100;
			addChild(pauseTxt);
			backBtn = new Button(Texture.fromBitmapData(GraphicsUtils.getButton()), "Back");
			backBtn.x = (Main.starling.stage.stageWidth - backBtn.width) / 2;
			backBtn.y = (Main.starling.stage.stageHeight - backBtn.height) /2 + 100;
			addChild(backBtn);
			resumeBtn = new Button(Texture.fromBitmapData(GraphicsUtils.getButton()), "Resume");
			resumeBtn.x = (Main.starling.stage.stageWidth - resumeBtn.width) / 2;
			resumeBtn.y = (Main.starling.stage.stageHeight - resumeBtn.height) /2;
			addChild(resumeBtn);
		}
	}
}