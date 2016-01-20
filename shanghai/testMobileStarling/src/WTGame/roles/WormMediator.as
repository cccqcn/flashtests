package WTGame.roles
{
	import WTGame.Constant;
	import WTGame.Main;
	import WTGame.model.GameModel;
	import WTGame.utils.MathUtils;
	import WTGame.utils.Vector2D;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import nape.geom.Vec2;
	import nape.phys.Body;
	import nape.phys.BodyType;
	import nape.shape.Polygon;
	
	import org.robotlegs.mvcs.StarlingMediator;
	
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.filters.BlurFilter;
	
	public class WormMediator extends StarlingMediator
	{
		[Inject]
		public var view:Worm;
		
		[Inject]
		public var model:GameModel;
		
		private var enterHole:Boolean;
		
		
		override public function onRegister():void
		{
			view.init(model.assets.getTextures(view.prop.asset));
			if(view.type != Constant.WORM_F)
			{
				view.image.addEventListener(TouchEvent.TOUCH, onTouch);
//				var body:Body = new Body(BodyType.STATIC, new Vec2(view.collisionArea.x * Main.starling.viewPort.width / Main.starling.stage.stageWidth + Main.starling.viewPort.x, view.collisionArea.y * Main.starling.viewPort.height / Main.starling.stage.stageHeight + Main.starling.viewPort.y));
//				body.shapes.add(new Polygon(Polygon.rect(0, 0, view.collisionArea.width, view.collisionArea.height)));
//				body.space = model.space;
			}
		}
		private function onTouch(e:TouchEvent):void
		{
			//			trace(e.target, e.getTouch(this)?e.getTouch(this).phase:0);
			if(view.isPaused)
			{
				return;
			}
			var i:int;
			var touch:Touch = e.getTouch(this.view);
			if(touch)
			{
				switch(touch.phase)
				{
					case "began":
						view.setLineStyle(true);
						view.totalPoints = 0;
						view.pArr = new Array;
						view.pArr.push(new Point(touch.globalX, touch.globalY));
						view.image.filter = null;
						enterHole = false;
						model.mouse.position.setxy(Main.stage.mouseX, Main.stage.mouseY);
						model.handJoint.body2 = model.mouse;
						model.handJoint.anchor2.set(model.mouse.worldPointToLocal(model.mouse.position, true));
						model.handJoint.active = true;
						break;
					case "moved":
//						trace("1", model.mouse.position);
//						trace("2", touch.globalX, touch.globalY);
//						model.mouse.position.setxy(touch.globalX, touch.globalY);
//						model.space.step(1 / 60);
////						model.mouse.
						trace("3", model.mouse.position);
						var lastPoint:Point = view.pArr[view.pArr.length - 1];
						var p:Point = new Point(model.mouse.position.x * Main.starling.stage.stageWidth / Main.starling.viewPort.width - Main.starling.viewPort.x, model.mouse.position.y * Main.starling.stage.stageHeight / Main.starling.viewPort.height);
						
						/*if(lastPoint == null)
						{
							lastPoint = new Point(view.image.x, view.image.y);
						}
						var arr:Array = MathUtils.bresenhamLine(new Vector2D(lastPoint.x, lastPoint.y), new Vector2D(p.x, p.y));
						for(i=0;i<arr.length;i++)
						{
							if(model.holetest.collisionArea.contains(arr[i].x, arr[i].y))
							{
								break;
							}
						}
						if(i != arr.length)
						{
							if(i < 35)
							{
								p = null;
							}
							else
							{
								p = new Point(arr[i-35].x, arr[i-35].y);
							}
						}*/
						
						if(p)
						{
							if(lastPoint)
							{
								var hole:Hole;
								for(i=0;i<model.roles.length;i++)
								{
									hole = model.roles[i] as Hole;
									if(hole && hole.canEnterHole(p, lastPoint))
									{
										enterHole = true;
										view.pArr.push(p);
										view.totalPoints++;
										view.image.filter = BlurFilter.createGlow(0xFF0000, 1, 9);
									}
								}
								var dis1:Number = MathUtils.getLength(p, lastPoint);
							}
							var totalLength:int = MathUtils.getPointsLength(view.pArr);
							if(enterHole == false && totalLength < Constant.LINE_MAX_LENGTH && (lastPoint == null || dis1 > 15))
							{
								view.pArr.push(p);
								view.totalPoints++;
							}
							if(view.totalPoints == 3)
							{
								view.clearPath();
								view.pathComplete();
							}
						}
						break;
					case "ended":
						view.setLineStyle(false);
						model.handJoint.active = false;
						break;
				}
			}
		}
		override public function onRemove():void
		{
			view.image.removeEventListener(TouchEvent.TOUCH, onTouch);
			if(view.isInHole)
			{
				model.addScore(1);
				model.removeRole(view);
			}
		}
	}
}