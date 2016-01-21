package
{
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2World;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.TextField;
	
	public class TestBox2D extends Sprite
	{
		private var enableConsole:Boolean = false
		private var _tf:TextField
		private var inputContainer:DisplayObjectContainer
		
		private var gravity:b2Vec2;
		private var world:b2World;
		private var groundBodyDef:b2BodyDef;
		private var groundBodyDefPos:b2Vec2;
		private var groundBody:b2Body;
		private var groundBox:b2PolygonShape;
		private var boxes:Vector.<Box2DSprite> = new Vector.<Box2DSprite>()
			
		public function TestBox2D()
		{
			addEventListener(Event.ADDED_TO_STAGE, init)
		}
		
		private function init(e:Event):void
		{
			inputContainer = new Sprite()
			addChild(inputContainer)
			
			addEventListener(Event.ENTER_FRAME, enterFrame)
			
			stage.frameRate = 60
			stage.scaleMode = StageScaleMode.NO_SCALE
			
			if(enableConsole) {
				_tf = new TextField
				_tf.multiline = true
				_tf.width = stage.stageWidth
				_tf.height = stage.stageHeight 
				inputContainer.addChild(_tf)
			}
			
//			CModule.startAsync(this)
			
			// Define the gravity vector.
			gravity = new b2Vec2;
			gravity.Set(0.0, 10.0);
			
			// Construct a world object, which will hold and simulate the rigid bodies.
			world = new b2World(gravity, true)
				
//			world.SetWarmStarting(true);
			if(false)
			{
				var debug:Sprite = new Sprite;
				addChild(debug);
				var debugDraw:b2DebugDraw = new b2DebugDraw;
				debugDraw.SetSprite(debug);
				debugDraw.SetDrawScale(30.0);
				debugDraw.SetFillAlpha(1);
				debugDraw.SetLineThickness(1.0);
				debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
				world.SetDebugDraw(debugDraw);
			}
			
			// Define the ground body.
			groundBodyDef = new b2BodyDef;
			groundBodyDefPos = new b2Vec2()
			groundBodyDefPos.Set(0.0, 12.9);
			groundBodyDef.position = groundBodyDefPos;
			
			// Call the body factory which allocates memory for the ground body
			// from a pool and creates the ground box shape (also from a pool).
			// The body is also added to the world.
			groundBody = world.CreateBody(groundBodyDef);
//			groundBody.swigCPtr = world.CreateBody(groundBodyDef.swigCPtr);
			
			// Define the ground box shape.
			groundBox = new b2PolygonShape();
			
			// The extents are the half-widths of the box.
			groundBox.SetAsBox(15.0, 0.5);
			
			// Add the ground fixture to the ground body.
			groundBody.CreateFixture2(groundBox, 0.0);
			
			trace(1345);
			for(var i:int=0; i<200; i++) {
				var bs:Box2DSprite = new Box2DSprite(100 + random() * 200, 10 + random() * 3000, 10 + random()*50, 2 + random()*5, world);
				boxes.push(bs);
				addChild(bs);
			}
			
//			initTesting();
		}
		
		protected var timeStep:Number = 1.0 / 60.0;
		public function enterFrame(e:Event):void
		{
//			CModule.serviceUIRequests()
			var velocityIterations:int = 12;
			var positionIterations:int = 4;
			world.Step(timeStep, velocityIterations, positionIterations);
			world.ClearForces();
			
			if(false)
			{
				world.DrawDebugData();
			}
			
			for(var i:int=0; i<boxes.length; i++) {
				boxes[i].update()
			}
		}
		
		protected var _currentSeed:uint=1234;
		
		/**
		 * returns a number between 0-1 exclusive.
		 */
		public function random():Number {
			return (_currentSeed = (_currentSeed * 16807) % 2147483647)/0x7FFFFFFF+0.000000000233;
		}
	}
}