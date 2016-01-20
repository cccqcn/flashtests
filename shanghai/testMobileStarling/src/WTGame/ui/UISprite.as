package WTGame.ui
{
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	
	public class UISprite extends Sprite
	{
		private var inGameView:InGameView;
		private var pausingView:PausingView;
		private var endView:EndView;
		private var startView:StartView;
		private var settingView:SettingView;
		private var testView:TestView;
		
		public function UISprite()
		{
			super();
			inGameView = new InGameView;
//			inGameView.flatten();
			pausingView = new PausingView;
			pausingView.flatten();
			endView = new EndView;
			endView.flatten();
			startView = new StartView;
			startView.flatten();
			settingView = new SettingView;
			settingView.flatten();
			testView = new TestView;
			testView.flatten();
			addView(startView);
			addView(testView);
		}
		
		public function toggleSetting():void
		{
			if(settingView.parent == null)
			{
				addView(settingView);
				removeView(startView);
			}
			else
			{
				addView(startView);
				removeView(settingView);
			}
		}
		
		public function startGame():void
		{
			addView(inGameView);
			removeView(startView);
			removeView(endView);
		}
		public function resetGame():void
		{
			addView(startView);
			removeView(inGameView);
			removeView(pausingView);
			removeView(endView);
		}
		
		public function pauseGame():void
		{
			addView(pausingView);
		}
		public function resumeGame():void
		{
			removeView(pausingView);
		}
		public function gameover():void
		{
			addView(endView);
		}
		
		private function addView(displayObject:DisplayObject):void
		{
			addChild(displayObject);
		}
		private function removeView(displayObject:DisplayObject):void
		{
			if(displayObject.parent)
			{
				displayObject.parent.removeChild(displayObject);
			}
		}
	}
}