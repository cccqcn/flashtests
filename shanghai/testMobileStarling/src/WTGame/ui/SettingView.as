package WTGame.ui
{
	import WTGame.utils.GraphicsUtils;
	
	import starling.display.Button;
	import starling.display.Sprite;
	import starling.textures.Texture;
	
	public class SettingView extends Sprite
	{
		public var backBtn:Button;
		
		public function SettingView()
		{
			super();
			backBtn = new Button(Texture.fromBitmapData(GraphicsUtils.getButton()), "Back");
			backBtn.x = 200;
			backBtn.y = 400;
			addChild(backBtn);
		}
	}
}