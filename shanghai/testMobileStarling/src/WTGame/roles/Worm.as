package WTGame.roles
{
	import WTGame.Constant;
	import WTGame.Main;
	import WTGame.utils.DashedLine;
	import WTGame.utils.GameRule;
	import WTGame.utils.GraphicsUtils;
	import WTGame.utils.MathUtils;
	import WTGame.vo.WormVO;
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.motionPaths.LinePath2D;
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.flash_proxy;
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.BlendMode;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.textures.RenderTexture;
	import starling.textures.Texture;
	
	public class Worm extends Role
	{
		public var image:Sprite;
		private var mc:MovieClip;
//		private var image1:Image;
		public var type:int;
		public var prop:WormVO;
		
		public var pArr:Array;
		private var path:LinePath2D;
		private var tween:TweenMax;
//		private var line2:flash.display.Shape;
		public var totalPoints:int;
		private var lastPosition:Point = new Point;
		
		private var line2:DashedLine;
		private var lineAlpha:Number = 0;
		
		public var isPaused:Boolean;
		public var isInHole:Boolean;
		
		public function Worm(type:int)
		{
			super();
			if(type == -1)
			{
				type = 20000 + 1 + int(Math.random() * 6);
			}
			this.type = type;
			this.prop = GameRule.getWormProps(type);
		}
		public function init(texture:Vector.<Texture>):void
		{
//			var texture:Texture = Texture.fromBitmapData(GraphicsUtils.getWorm(prop.color, prop.size));
//			line = new starling.display.Shape;
//			addChild(line);
			image = new Sprite;
			mc = new MovieClip(texture, prop.frames);
			this.collisionArea = new Rectangle(x, y, mc.width, mc.height);
			mc.pivotX = mc.width  / 2.0;
			mc.pivotY = mc.height / 2.0;
			mc.rotation = Math.PI / 2;
			image.addChild(mc);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
//			image1 = new Image(texture);
//			image1.pivotX = texture.width  / 2.0;
//			image1.pivotY = texture.height / 2.0;
//			image1.rotation = Math.PI / 2;
//			image.addChild(image1);
			switch(int(Math.random() * 4))
			{
				case 0:
					image.x = 0;
					image.y = Math.random() * Main.starling.stage.stageHeight;
					break;
				case 1:
					image.x = Math.random() * Main.starling.stage.stageWidth;
					image.y = 0;
					break;
				case 2:
					image.x = Main.starling.stage.stageWidth;
					image.y = Math.random() * Main.starling.stage.stageHeight;
					break;
				case 3:
					image.x = Math.random() * Main.starling.stage.stageWidth;
					image.y = Main.starling.stage.stageHeight;
					break;
			}
			addChild(image);
			image.rotation = Math.random() * Math.PI * 2;
			autogo();
			line2 = new DashedLine(3, 0xFFFFFF, [15, 15]);
			Main.stage.addChild(line2);
		}
		override public function get posX():Number
		{
			return image.x;
		}
		override public function get posY():Number
		{
			return image.y;
		}
		private function onAddedToStage():void
		{
			Starling.juggler.add(mc);
		}
		
		private function onRemovedFromStage():void
		{
			Starling.juggler.remove(mc);
		}
		
		public function setLineStyle(start:Boolean):void
		{
			if(start == true)
			{
				line2.lineStyle(3, 0xFFFFFF);
				line2.lengthsArray = [15, 15];
			}
			else
			{
				lineAlpha = -0.15;
			}
		}
		private var deltaAngle:Number = 0;
		override public function enterFrame():void
		{
			if(isPaused)
			{
				return;
			}
			super.enterFrame();
			if(lineAlpha != 0)
			{
				line2.alpha += lineAlpha;
				if(line2.alpha <= 0.3)
				{
					line2.clear();
					line2.lineStyle(0.5, 0xAAAAAA);
					line2.lengthsArray = [15, 0];
					line2.alpha = 1;
					lineAlpha = 0;
				}
			}
			
			this.collisionArea.x = image.x;
			this.collisionArea.y = image.y;
			if(lastPosition.x != image.x || lastPosition.y != image.y)
			{
				var angle:Number = Math.atan((image.y - lastPosition.y) / (image.x - lastPosition.x));
//				trace(angle * 180 / Math.PI, (image.y - lastPosition.y), (image.x - lastPosition.x));
				if(image.x - lastPosition.x < 0)
				{
					angle += Math.PI;
				}
				deltaAngle = (angle - image.rotation);
				deltaAngle = deltaAngle % (Math.PI * 2);
				if(deltaAngle > Math.PI)
				{
					deltaAngle = deltaAngle - Math.PI * 2;
				}
				if(deltaAngle < -Math.PI)
				{
					deltaAngle = deltaAngle + Math.PI * 2;
				}
				deltaAngle *= 0.15;
//				trace(angle * 180 / Math.PI, image.rotation * 180 / Math.PI, deltaAngle * 180 / Math.PI);
			}
			else
			{
				deltaAngle = 0;
			}
			image.rotation += deltaAngle;
			lastPosition.x = image.x;
			lastPosition.y = image.y;
			
			if(type != Constant.WORM_F)
			{
				if(image.x + collisionArea.width < 0 || image.x - collisionArea.width > Main.stage.stageWidth)
				{
					image.rotation = Math.PI - image.rotation;
					autogo();
				}
				if(image.y + collisionArea.width < 0 || image.y - collisionArea.width > Main.stage.stageHeight)
				{
					image.rotation = - image.rotation;
					autogo();
				}
			}
			
			if(nearRoles.length != 0)
			{
				image.alpha = 0.5;
			}
			else
			{
				image.alpha = 1;
			}
		}
		
		private function pathUpdate():void
		{
//			trace(path.followers[0].progress, getPointIndexByProgress(path, path.followers[0].progress));
			if(path && path.followers.length > 0)
			{
				var index:int = MathUtils.getPointIndexByProgress(path, path.followers[0].progress);
				if(index != -1)
				{
					var xscale:Number = Main.starling.viewPort.width / Constant.STAGE_WIDTH;
					var yscale:Number = Main.starling.viewPort.height / Constant.STAGE_HEIGHT;
					var xx:Number = Main.starling.viewPort.x;
					var yy:Number = Main.starling.viewPort.y;
					var i:int;
					line2.clear();
//					line2.graphics.lineStyle(1);
					line2.moveTo(image.x * xscale + xx, image.y * yscale + yy);
					for(i=index;i<path.points.length;i++)
					{
						line2.lineTo(path.points[i].x * xscale + xx, path.points[i].y * yscale + yy);
		//				line2.graphics.drawCircle(path.points[i].x, path.points[i].y, 2);
					}
					if(totalPoints > 5)
					{
						for(i=0;i<pArr.length;i++)
						{
							line2.lineTo(pArr[i].x * xscale + xx, pArr[i].y * yscale + yy);
							//				line2.graphics.drawCircle(path.points[i].x, path.points[i].y, 2);
						}
					}
				}
			}
		}
		public function pathComplete():void
		{
			if(pArr && pArr.length > 1)
			{
				path = new LinePath2D(pArr);
				path.insertPoint(new Point(image.x, image.y));
				path.addFollower(image, path.getSegmentProgress(1, 0));
				var dis2:Number = path.totalLength;
				//						trace(dis2, dis2 / speed);
				//tween all of the squares through the path once (wrapping when they reach the end)
				tween = TweenMax.to(path, dis2 / prop.speed, {onUpdate:pathUpdate, onComplete:pathComplete, 
					progress:1, ease:Linear.easeNone});
				pArr.splice(0, pArr.length);
			}
			else if(image.filter != null)
			{
				isInHole = true;
				dispose();
			}
			else
			{
				autogo();
			}
		}
		
		public function autogo():void
		{
			clearPath();
			var xx:Number = 500 * Math.cos(image.rotation);
			var yy:Number = 500 * Math.sin(image.rotation);
			xx += image.x;
			yy += image.y;
			tween = TweenMax.to(image, 500 / prop.speed, {onComplete:pathComplete, x:xx, y:yy, ease:Linear.easeNone});
		}
		public function clearPath():void
		{
			if(path)
			{
				path.removeFollower(image);
				path = null;
			}
			if(tween)
			{
				tween.kill();
			}
		}
		
		override public function dispose():void
		{
			if(parent)
			{
				parent.removeChild(this);
			}
			super.dispose();
			this.image.dispose();
			if(path)
			{
				path.removeFollower(image);
				path = null;
			}
			if(tween)
			{
				tween.kill();
			}
			if(line2)
			{
				line2.clear();
				if(line2.parent)
				{
					line2.parent.removeChild(line2);
				}
			}
		}
		override public function containedByRole(role:Role):void
		{
			return;
			if(role is Hole && GameRule.isWormInHole(this.type, (role as Hole).type) && 
				image.filter != null)
			{
				this.dispatchEvent(new Event("dispose"));
				this.dispose();
			}
		}
		
		public function pause():void
		{
			isPaused = true;
			if(tween)
			{
				tween.pause();
			}
		}
		public function resume():void
		{
			if(tween)
			{
				tween.resume();
			}
			isPaused = false;
		}
	}
}