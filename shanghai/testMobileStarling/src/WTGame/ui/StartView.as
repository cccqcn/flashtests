package WTGame.ui
{
	import WTGame.utils.GraphicsUtils;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class StartView extends Sprite
	{
		public var startBtn:Button;
		public var settingBtn:Button;
		
		public function StartView()
		{
			super();
			startBtn = new Button(Texture.fromBitmapData(GraphicsUtils.getButton()), "Start");
			startBtn.x = 200;
			startBtn.y = 200;
			addChild(startBtn);
			settingBtn = new Button(Texture.fromBitmapData(GraphicsUtils.getButton()), "Setting");
			settingBtn.x = 200;
			settingBtn.y = 300;
			addChild(settingBtn);
		}
	}
}