package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
    import Box2D.Dynamics.Joints.*;
	
	
	/**
	 * ...
	 * @author ...
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
            mousePVec = new b2Vec2();
			
			// Add event for main loop
			addEventListener(Event.ENTER_FRAME, Update, false, 0, true);
			
			// Creat world AABB
			var worldAABB:b2AABB = new b2AABB();
			worldAABB.lowerBound.Set(-100.0, -100.0);
			worldAABB.upperBound.Set(100.0, 100.0);
			
			// Define the gravity vector
			var gravity:b2Vec2 = new b2Vec2(0.0, 10.0);
			
			// Allow bodies to sleep
			var doSleep:Boolean = true;
			
			// Construct a world object
			m_world = new b2World(worldAABB, gravity, doSleep);
			// Vars used to create bodies
			var body:b2Body;
			var bodyDef:b2BodyDef;
			var boxDef:b2PolygonDef;
			var circleDef:b2CircleDef;
			
			var s:Sprite = new Sprite;
			s.graphics.beginFill(0x0000FF, 1);
			s.graphics.lineStyle(1, 0xFF0000);
			s.graphics.moveTo(-10, -10);
			s.graphics.lineTo(10, -10);
			s.graphics.lineTo(10, 10);
			s.graphics.lineTo(-10, 10);
			s.graphics.lineTo(-10, -10);			
			s.graphics.endFill();
			
			
			// Add ground body
			bodyDef = new b2BodyDef();
			//bodyDef.position.Set(15, 19);
			bodyDef.position.Set(10, 14);
			//bodyDef.angle = 0.1;
			boxDef = new b2PolygonDef();
			boxDef.SetAsBox(30, 3);
			boxDef.friction = 0.3;
			boxDef.density = 0; // static bodies require zero density
			/*circleDef = new b2CircleDef();
			circleDef.radius = 10;
			circleDef.restitution = 0.2*/
			// Add sprite to body userData
			bodyDef.userData = new PhysGround;
			//bodyDef.userData = new PhysCircle();
			bodyDef.userData.width = 30 * 2 * 60; 
			bodyDef.userData.height = 30 * 2 * 3; 
			addChild(bodyDef.userData);
			body = m_world.CreateBody(bodyDef);
			body.CreateShape(boxDef);
			//body.CreateShape(circleDef);
			body.SetMassFromShapes();
			
			
			var arr:Array = new Array([12,12], [12,24],[12,36],[12,48],[24,12]);
			
			var k:int = 4;
			var l:int = 1;
			// Add some objects
			for (var i:int = 1; i <= 1; i++){
				bodyDef = new b2BodyDef();
				if (i > 10)
				{
					bodyDef.position.x = i;
					bodyDef.position.y = 7;				
				}
				else
				{
					bodyDef.position.x = (5 - k);// Math.random() * 15 + 5;
					bodyDef.position.y = (l)+(5-k)*0.4 + 1;// Math.random() * 10;
					trace(k, l);
					l++;
					if (l > k)
					{
						l = 1;
						k--;
					}
				}
				var rX:Number = Math.random() + 0.5;
				var rY:Number = Math.random() + 0.5;
				// Box
				if (0){
					/*boxDef = new b2PolygonDef();
					//boxDef.SetAsBox(rX, rY);
					boxDef.SetAsBox(0.2, 1);
					boxDef.density = 1.0;
					boxDef.friction = 0.5;
					boxDef.restitution = 0.2;
					bodyDef.userData = new PhysBox();
					//bodyDef.userData.width = rX * 2 * 30; 
					//bodyDef.userData.height = rY * 2 * 30; 
					bodyDef.userData.width = 0.2 * 2 * 30; 
					bodyDef.userData.height = 1 * 2 * 30; 
					body = m_world.CreateBody(bodyDef);
					body.CreateShape(boxDef);*/
				} 
				// Circle
				else {
					rX = 0.4;
					circleDef = new b2CircleDef();
					circleDef.radius = rX;
					circleDef.density = 5.5;
					circleDef.friction = 1.0;
					circleDef.restitution = 0.8
					bodyDef.userData = new PhysCircle();
					bodyDef.userData.width = rX * 2 * 30; 
					bodyDef.userData.height = rX * 2 * 30; 
					body = m_world.CreateBody(bodyDef);
					body.CreateShape(circleDef);
				body.SetMassFromShapes();
				addChild(bodyDef.userData);
				}
			}
			
			
            stage.addEventListener(MouseEvent.MOUSE_DOWN, on_mouse_down);
            stage.addEventListener(MouseEvent.MOUSE_UP, on_mouse_up);
			
		}
		

        public function on_mouse_down(param1:MouseEvent) : void
        {
            var _loc_2:b2Body;
            var _loc_3:b2MouseJointDef;
            _loc_2 = GetBodyAtMouse();
            if (_loc_2)
            {
                _loc_3 = new b2MouseJointDef();
                _loc_3.body1 = m_world.GetGroundBody();
                _loc_3.body2 = _loc_2;
                _loc_3.target.Set(mouseX / pixels_in_a_meter, mouseY / pixels_in_a_meter);
                _loc_3.maxForce = 1000;
                _loc_3.timeStep = 1 / 30;
                mouseJoint = m_world.CreateJoint(_loc_3) as b2MouseJoint;
            }// end if
            return;
        }// end function

        public function on_mouse_up(param1:MouseEvent) : void
        {
            if (mouseJoint != null)
            {
                m_world.DestroyJoint(mouseJoint);
                mouseJoint = null;
            }// end if
            return;
        }// end function

        public function GetBodyAtMouse(param1:Boolean = false) : b2Body
        {
            var _loc_2:b2AABB;
            var _loc_3:int;
            var _loc_4:Array;
            var _loc_5:int;
            var _loc_6:b2Body;
            var _loc_7:int;
            var _loc_8:b2Shape;
            var _loc_9:Boolean;
            real_x_mouse = stage.mouseX / pixels_in_a_meter;
            real_y_mouse = stage.mouseY / pixels_in_a_meter;
            mousePVec.Set(real_x_mouse, real_y_mouse);
            _loc_2 = new b2AABB();
            _loc_2.lowerBound.Set(real_x_mouse - 0.001, real_y_mouse - 0.001);
            _loc_2.upperBound.Set(real_x_mouse + 0.001, real_y_mouse + 0.001);
            _loc_3 = 10;
            _loc_4 = new Array();
            _loc_5 = m_world.Query(_loc_2, _loc_4, _loc_3);
            _loc_6 = null;
            _loc_7 = 0;
            while (_loc_7 < _loc_5)
            {
                // label
                if (_loc_4[_loc_7].GetBody().IsStatic() == false || param1)
                {
                    _loc_8 = _loc_4[_loc_7] as b2Shape;
                    _loc_9 = (_loc_4[_loc_7] as b2Shape).TestPoint(_loc_8.GetBody().GetXForm(), mousePVec);
                    if (_loc_9)
                    {
                        _loc_6 = _loc_8.GetBody();
                        break;
                    }// end if
                }// end if
                _loc_7++;
            }// end while
            return _loc_6;
        }// end function
		
		private var xx:Number;
		public function Update(e:Event):void {
			//trace(xx);
			if(xx-x>200)
			x = -xx+20;
            var _loc_3:*;
            var _loc_4:*;
            var _loc_5:b2Vec2;
            if (mouseJoint)
            {
                _loc_3 = mouseX / pixels_in_a_meter;
                _loc_4 = mouseY / pixels_in_a_meter;
                _loc_5 = new b2Vec2(_loc_3, _loc_4);
                mouseJoint.SetTarget(_loc_5);
            }// end if
			
			m_world.Step(m_timeStep, m_iterations);
			
			// Go through body list and update sprite positions/rotations
			for (var bb:b2Body = m_world.m_bodyList; bb; bb = bb.m_next){
				if (bb.m_userData is Sprite){
					bb.m_userData.x = bb.GetPosition().x * 30;
					bb.m_userData.y = bb.GetPosition().y * 30;
					if (bb.m_userData.x != 300)
					{
						trace(bb, bb.m_userData.x, bb.m_userData.y);
						xx = bb.m_userData.x;
						//y = -bb.m_userData.y;
					}
					bb.m_userData.rotation = bb.GetAngle() * (180/Math.PI);
				}
			}
			
		}
		
		public var m_world:b2World;
		public var m_iterations:int = 10;
		public var m_timeStep:Number = 1.0/30.0;
        public var pixels_in_a_meter:Number = 30;
        private var mouseJoint:b2MouseJoint;
        public var real_x_mouse:Number;
        public var real_y_mouse:Number;
        public var mousePVec:b2Vec2;
	}
	
}