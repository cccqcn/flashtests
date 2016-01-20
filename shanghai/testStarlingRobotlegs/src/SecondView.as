package
{
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class SecondView extends Sprite
	{
		protected var theme:MetalWorksMobileTheme;
		protected var button:Button;
		
		public function SecondView()
		{
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected function addedToStageHandler(event:Event):void
		{
			this.theme = new MetalWorksMobileTheme(this.stage);
			
			//create a button and give it some text to display.
			this.button = new Button();
			this.button.label = "Click Me";
			
			//an event that tells us when the user has tapped the button.
			this.button.addEventListener(Event.TRIGGERED, button_triggeredHandler);
			
			//add the button to the display list, just like you would with any
			//other Starling display object. this is where the theme give some
			//skins to the button.
			this.addChild(this.button);
		}
		protected function button_triggeredHandler(event:Event):void
		{
			const label:Label = new Label();
			label.text = "Hi, I'm Feathers!\nHave a nice day.";
			Callout.show(label, this.button);
		}
	}
}