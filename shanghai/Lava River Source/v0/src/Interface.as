/**
 * Tomislav Podhraški
 * http://www.justpinegames.com
 */

// Interface.as handles graphical interface for debugging.

package  
{
	import feathers.controls.Button;
	import feathers.controls.HSlider;
	import feathers.controls.ScrollContainer;
	import feathers.controls.Slider;
	import feathers.controls.text.TextFieldTextRenderer;
	import feathers.core.ITextRenderer;
	import feathers.layout.VerticalLayout;
	import flash.text.TextFormat;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.core.Starling;
	import starling.events.Event;

	public class Interface extends Sprite
	{
		public static const THICKNESS_CHANGED:String = "thicknessChanged";
		public static const SPEED_CHANGED:String = "speedChanged";
		
		private const COLOR_UP_STATE:uint = 0x555555;
		private const COLOR_HOVER_STATE:uint = 0x666666;
		private const COLOR_DOWN_STATE:uint = 0x777777;
		
		private var _showButton:Button;

		public function Interface() 
		{
			/// Create a button, with plain skin
			_showButton = new Button();
			_showButton.label = "+";
			_showButton.width = 30;
			_showButton.height = 30;
			_showButton.x = 5;
			_showButton.y = Starling.current.nativeStage.stageHeight - _showButton.height - 5;
			_showButton.stateToSkinFunction = function(target:Object, state:Object, oldValue:Object = null):Object
			{
				// Select color for the state: down, up or hover
				var color:uint = state == Button.STATE_UP ? COLOR_UP_STATE : (state == Button.STATE_DOWN ? COLOR_DOWN_STATE : COLOR_HOVER_STATE);
				
				// Button border with background
				var container:Sprite = new Sprite();
				var border:Quad = new Quad(target.width, target.height, 0xaaaaaa);
				container.addChild(border);
				var inner:Quad = new Quad(target.width - 2, target.height - 2, color);
				inner.x = 1;
				inner.y = 1;
				container.addChild(inner);
				
				return container;
			}
			_showButton.labelFactory = function():ITextRenderer
			{
				return createSimpleLabel("");
			};
			_showButton.onRelease.add(function(button:Button):void
			{
			});
			this.addChild(_showButton);
			
		}
		
		// Helper function for creating labels
		private function createSimpleLabel(text:String = ""):TextFieldTextRenderer
		{
			var label:TextFieldTextRenderer = new TextFieldTextRenderer();
			label.textFormat = new TextFormat("Verdana", 14, 0xffffff);
			label.text = text;
			return label;
		}
		
		// Helper function for sliders
		private function createSlider(minimum:Number, maximum:Number, defaultValue:Number, event:Function):HSlider
		{
			var slider:HSlider = new HSlider();
			slider.width = 100;
			slider.height = 20;
			slider.minimum = minimum;
			slider.maximum = maximum;

			slider.thumbProperties.defaultSkin = new Quad(10, 20, 0xcccccc);
			slider.minimumTrackProperties.defaultSkin = new Quad(10, 10, COLOR_UP_STATE);
			
			slider.value = defaultValue;
			
			slider.onChange.add(event);
			
			return slider;
		}

	}
}