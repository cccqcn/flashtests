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
	import flash.geom.Point;
	import flash.text.TextFormat;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.core.Starling;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class Interface extends Sprite
	{
		public static const THICKNESS_CHANGED:String = "thicknessChanged";
		public static const SPEED_CHANGED:String = "speedChanged";
		public static const CURVE_CHANGED:String = "curveChanged";
		
		private const COLOR_UP_STATE:uint = 0x555555;
		private const COLOR_HOVER_STATE:uint = 0x666666;
		private const COLOR_DOWN_STATE:uint = 0x777777;
		
		private var _showButton:Button;
		private var _debugContainer:Sprite;
		private var _debugPanel:ScrollContainer;
		
		private var _curveToEdit:QuadricBezierCurve;

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
				// Show/hide debug interface
				_debugContainer.visible = !_debugContainer.visible;
				button.label = _debugContainer.visible ? "-" : "+";
			});
			this.addChild(_showButton);
			
			_debugContainer = new Sprite();
			_debugContainer.visible = false;
			this.addChild(_debugContainer);
			
			// Debug panel conaining sliders for changing example values
			var verticalLayout:VerticalLayout = new VerticalLayout();
			verticalLayout.paddingLeft = 5;
			verticalLayout.paddingTop = 5;
			verticalLayout.gap = 5;
			_debugPanel = new ScrollContainer();
			_debugPanel.width = 150;
			_debugPanel.height = Starling.current.nativeStage.stageHeight - _showButton.height - 10;
			_debugPanel.layout = verticalLayout;
			
			// Thickness slider
			_debugPanel.addChild(createSimpleLabel("Thickness"));
			_debugPanel.addChild(createSlider(10, 50, 35, function(slider:Slider):void
			{
				dispatchEvent(new Event(THICKNESS_CHANGED, false, { thickness: slider.value } ));
			}));
			
			// Speed slider
			_debugPanel.addChild(createSimpleLabel("Speed"));
			_debugPanel.addChild(createSlider(-10, 10, 1, function(slider:Slider):void
			{
				dispatchEvent(new Event(SPEED_CHANGED, false, { speed: slider.value } ));
			}));

			_debugContainer.addChild(_debugPanel);
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
		
		public function get curveToEdit():QuadricBezierCurve 
		{
			return _curveToEdit;
		}
		
		public function set curveToEdit(value:QuadricBezierCurve):void 
		{
			var self:Interface = this;
			
			_curveToEdit = value;
			
			for (var i:int = 0; i < _curveToEdit.nodes.length; i++)
			{
				var node:CurveNode = _curveToEdit.nodes[i];
				
				var editingPoint:Sprite = editorComponent(node.position.x, node.position.y, 0xf26522, 0x252525);
				_debugContainer.addChild(editingPoint);
				// Function returning a function right away, not nice... Used to deal with AS3 scope
				editingPoint.addEventListener(TouchEvent.TOUCH, function(closureNode:CurveNode):Function {
					return function(e:TouchEvent):void
					{
						var displayObject:DisplayObject = e.currentTarget as DisplayObject;
						var touchMoved:Touch = e.getTouch(displayObject, TouchPhase.MOVED);
						var touchEnded:Touch = e.getTouch(displayObject, TouchPhase.ENDED);

						if (touchMoved)
						{
							closureNode.position = new Point(
								touchMoved.globalX - touchMoved.previousGlobalX + closureNode.position.x,
								touchMoved.globalY - touchMoved.previousGlobalY + closureNode.position.y
							);
							displayObject.x = closureNode.position.x;
							displayObject.y = closureNode.position.y;
						}
						
						self.dispatchEvent(new Event(CURVE_CHANGED));
					};
				}(node));
				
				var editingControlPoint:Sprite = editorComponent(node.control.x, node.control.y, 0xebebeb, 0x464646);
				_debugContainer.addChild(editingControlPoint);
				editingControlPoint.addEventListener(TouchEvent.TOUCH, function(closureNode:CurveNode):Function {
					return function(e:TouchEvent):void
					{
						var displayObject:DisplayObject = e.currentTarget as DisplayObject;
						var touchMoved:Touch = e.getTouch(displayObject, TouchPhase.MOVED);
						var touchEnded:Touch = e.getTouch(displayObject, TouchPhase.ENDED);

						if (touchMoved)
						{
							closureNode.control = new Point(
								touchMoved.globalX - touchMoved.previousGlobalX + closureNode.control.x,
								touchMoved.globalY - touchMoved.previousGlobalY + closureNode.control.y
							);
							displayObject.x = closureNode.control.x;
							displayObject.y = closureNode.control.y;
						}
						
						self.dispatchEvent(new Event(CURVE_CHANGED));
					};
				}(node));
				if (i + 1 == _curveToEdit.nodes.length)
				{
					editingControlPoint.visible = false;
				}
			}
		}

		private function editorComponent(x:Number, y:Number, innerColor:uint, outerColor:uint):Sprite
		{
			var outer:Quad = new Quad(10, 10, outerColor);
			outer.pivotX = outer.width / 2; 
			outer.pivotY = outer.height / 2;
			
			var inner:Quad = new Quad(6, 6, innerColor);
			inner.pivotX = inner.width / 2; 
			inner.pivotY = inner.height / 2;
			
			var shadow:Quad = new Quad(10, 10, 0x000000);
			shadow.pivotX = shadow.width / 2;
			shadow.pivotY = shadow.height / 2;
			shadow.x = -1;
			shadow.y = 1;
			shadow.alpha = 0.4;
			
			var component:Sprite = new Sprite();
			component.x = x;
			component.y = y;
			component.addChild(shadow);
			component.addChild(outer);
			component.addChild(inner);

			return component;
		}
		
	}
}