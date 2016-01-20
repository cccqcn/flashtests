package WTGame.managers
{
	import WTGame.Constant;
	import WTGame.Main;
	import WTGame.model.EmbeddedAssets;
	import WTGame.model.GameModel;
	import WTGame.roles.Hole;
	import WTGame.roles.Role;
	import WTGame.roles.Worm;
	import WTGame.ui.UISprite;
	import WTGame.utils.MathUtils;
	
	import flash.events.Event;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	
	import org.robotlegs.mvcs.Actor;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.utils.AssetManager;
	
	public class GameManager extends Actor
	{
		[Inject]
		public var model:GameModel;
		
		private var wormInterval:uint;
		
		private var touching:int = -1;
		
		private var ui:UISprite;
				
		public function GameManager()
		{
			super();
		}
		
		public function init(stage:Sprite):void
		{
			stage.addEventListener(TouchEvent.TOUCH, onTouch);
			model.init(stage);
			model.assets = new AssetManager();
//			assets.verbose = Capabilities.isDebugger;
			model.assets.enqueue(EmbeddedAssets);
			model.assets.loadQueue(function(ratio:Number):void
			{
				if (ratio == 1)
					Starling.juggler.delayCall(function():void
					{
						showMainMenu();
					}, 0.15);
			});
		}
		
		private function showMainMenu():void
		{
			ui = new UISprite;
			model.stage.addChild(ui);
			this.dispatch(new flash.events.Event(Constant.EVENT_GAME_LOADED));
		}
		
		public function start():void
		{
			model.score = 0;
			var hole:Hole = new Hole(200, 300, Constant.HOLE_A);
			model.addRole(hole);
			var hole1:Hole = new Hole(100, 100, Constant.HOLE_B);
			model.addRole(hole1);
			model.holetest = hole1;
			var hole2:Hole = new Hole(400, 000, Constant.HOLE_C);
			model.addRole(hole2);
			newWorm();
			wormInterval = setInterval(newWorm, model.wormTimer);
			trace("Game Start");
			model.gameStatus = Constant.GAME_PLAYING;
			ui.startGame();
		}
		public function pause():void
		{
			if(model.gameStatus == Constant.GAME_PLAYING)
			{
				model.gameStatus = Constant.GAME_PAUSED;
				ui.pauseGame();
				clearInterval(wormInterval);
				var r:Role;
				for each(r in model.roles)
				{
					if(r is Worm)
					{
						(r as Worm).pause();
					}
				}
			}
		}
		public function gameover():void
		{
			model.gameStatus = Constant.GAME_OVER;
			ui.gameover();
			clearInterval(wormInterval);
			var r:Role;
			for each(r in model.roles)
			{
				if(r is Worm)
				{
					(r as Worm).pause();
				}
			}
		}
		public function resume():void
		{
			model.gameStatus = Constant.GAME_PLAYING;
			ui.resumeGame();
			wormInterval = setInterval(newWorm, model.wormTimer);
			var r:Role;
			for each(r in model.roles)
			{
				if(r is Worm)
				{
					(r as Worm).resume();
				}
			}
		}
		public function resetGame():void
		{
			stop();
			ui.resetGame();
		}
		public function stop():void
		{
			clearInterval(wormInterval);
			model.removeAllRole();
		}
		private function onTouch(e:TouchEvent):void
		{
			
		}
		private function newWorm():void
		{
			var worm:Worm = new Worm(-1);
			model.addRole(worm);
		}
		
		public function onEnterFrame(e:starling.events.Event):void
		{
			if(model.gameStatus != Constant.GAME_PLAYING)
			{
				return;
			}
			var i:int;
			var j:int;
			var r:Role;
			for each(r in model.roles)
			{
				if(r is Worm)
				{
					r.nearRoles.splice(0, r.nearRoles.length);
				}
			}
			var r2:Role;
			for(i=0;i<model.roles.length;i++)
			{
				r = model.roles[i];
				for(j=i+1;j<model.roles.length;j++)
				{
					r2 = model.roles[j];
					if(r != r2 && r.collisionArea != null && r2.collisionArea != null)
					{
						if(r.collisionArea.containsRect(r2.collisionArea))
						{
							r.containsRole(r2);
							r2.containedByRole(r);
						}
						if(r2.collisionArea.containsRect(r.collisionArea))
						{
							r2.containsRole(r);
							r.containedByRole(r2);
						}
					}
					if(r is Worm && r2 is Worm)
					{
						var dis:Number = MathUtils.getLength2(r.posX, r.posY, r2.posX, r2.posY);
						if(dis < Constant.WORM_NEAR_DISTANCE)
						{
							r.nearRoles.push(r2);
							r2.nearRoles.push(r);
						}
						if(dis < Constant.WORM_DEAD_DISTANCE)
						{
							gameover();
						}
					}
				}
			}
			for each(r in model.roles)
			{
				r.enterFrame();
			}
//			trace(touching);
		}
		
		public function toggleSetting():void
		{
			ui.toggleSetting();
		}
	}
}