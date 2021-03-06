package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	import mx.collections.*;
	import mx.core.*;
	
	public class GameObjectManager
	{
		// double buffer
		public var backBuffer:BitmapData;
		// colour to use to clear backbuffer with 
		public var clearColor:uint = 0;//0xFF0043AB;
		// static instance 
		protected static var instance:GameObjectManager = null;
		// the last frame time 
		protected var lastFrame:Date;
		// a collection of the GameObjects 
		protected var gameObjects:Array = new Array();
		// a collection where new GameObjects are placed, to avoid adding items 
		// to gameObjects while in the gameObjects collection while it is in a loop
		protected var newGameObjects:Array = new Array();
		// a collection where removed GameObjects are placed, to avoid removing items 
		// to gameObjects while in the gameObjects collection while it is in a loop
		protected var removedGameObjects:Array = new Array();
		protected var collisionMap:Dictionary = new Dictionary();
		
		static public function get Instance():GameObjectManager
		{
			if ( instance == null )
			instance = new GameObjectManager();
			return instance;
		}
		
		public function GameObjectManager()
		{
			if ( instance != null )
				throw new Error( "Only one Singleton instance should be instantiated" ); 
				
			backBuffer = new BitmapData(Application.application.width, Application.application.height, true, 0x00000000);
		}
		
		public function startup():void
		{
			lastFrame = new Date();			
		}
		
		public function shutdown():void
		{
			shutdownAll();
		}
		
		public function enterFrame():void
		{
			// Calculate the time since the last frame
			var thisFrame:Date = new Date();
			var seconds:Number = (thisFrame.getTime() - lastFrame.getTime())/1000.0;
	    	lastFrame = thisFrame;
	    	
	    	removeDeletedGameObjects();
	    	insertNewGameObjects();
	    	
	    	GameManager.Instance.enterFrame(seconds);
	    	
	    	checkCollisions();
	    	
	    	// now allow objects to update themselves
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) 
					gameObject.enterFrame(seconds);
			}
	    	
	    	drawObjects();
		}
		
		public function click(event:MouseEvent):void
		{
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) gameObject.click(event);
			}
		}
		
		public function mouseDown(event:MouseEvent):void
		{
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) gameObject.mouseDown(event);
			}
		}
		
		public function mouseUp(event:MouseEvent):void
		{
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) gameObject.mouseUp(event);
			}
		}
		
		public function mouseMove(event:MouseEvent):void
		{
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) gameObject.mouseMove(event);
			}
		}
		
		protected function drawObjects():void
		{
			backBuffer.fillRect(backBuffer.rect, clearColor);
			
			// draw the objects
			for each (var gameObject:GameObject in gameObjects)
			{
				if (gameObject.inuse) 
					gameObject.copyToBackBuffer(backBuffer);
			}
		}
				
		public function addGameObject(gameObject:GameObject):void
		{
			newGameObjects.push(gameObject);
		}
		
		public function removeGameObject(gameObject:GameObject):void
		{
			removedGameObjects.push(gameObject);
		}
		
		protected function shutdownAll():void
		{
			// don't dispose objects twice
			for each (var gameObject:GameObject in gameObjects)
			{
				var found:Boolean = false;
				for each (var removedObject:GameObject in removedGameObjects)
				{
					if (removedObject == gameObject)
					{
						found = true;
						break;
					}
				}
				
				if (!found)
					gameObject.shutdown();
			}
		}
		
		protected function insertNewGameObjects():void
		{
			for each (var gameObject:GameObject in newGameObjects)
			{
				for (var i:int = 0; i < gameObjects.length; ++i)
				{
					if (gameObjects[i].zOrder > gameObject.zOrder ||
						gameObjects[i].zOrder == -1)
						break;
				}

				gameObjects.splice(i,0,gameObject);
			}
			
			newGameObjects.splice(0, newGameObjects.length);
		}
		
		protected function removeDeletedGameObjects():void
		{
			// insert the object acording to it's z position
			for each (var removedObject:GameObject in removedGameObjects)
			{
				var i:int = 0;
				for (i = 0; i < gameObjects.length; ++i)
				{
					if (gameObjects[i] == removedObject)
					{
						gameObjects.splice(i, 1);
						break;
					}
				}
				
			}
			
			removedGameObjects.splice(0, removedGameObjects.length);
		}
		
		public function addCollidingPair(collider1:String, collider2:String):void
		{
			if (collisionMap[collider1] == null)			
				collisionMap[collider1] = new Array();
				
			if (collisionMap[collider2] == null)
				collisionMap[collider2] = new Array();
								
			collisionMap[collider1].push(collider2);
			collisionMap[collider2].push(collider1);
		}
		
		protected function checkCollisions():void
		{
	    	for (var i:int = 0; i < gameObjects.length; ++i)
			{
				var gameObjectI:GameObject = GameObject(gameObjects[i]);
				
				for (var j:int = i + 1; j < gameObjects.length; ++j)
				{
					var gameObjectJ:GameObject = GameObject(gameObjects[j]);
					
					// early out for non-colliders
					var collisionNameNotNothing:Boolean = gameObjectI.collisionName != CollisionIdentifiers.NONE;
					// objects can still exist in the gameObjects collection after being disposed, so check
					var bothInUse:Boolean = gameObjectI.inuse && gameObjectJ.inuse;
					// make sure we have an entry in the collisionMap
					var collisionMapEntryExists:Boolean = collisionMap[gameObjectI.collisionName] != null;
					// make sure the two objects are set to collide
					var testForCollision:Boolean = collisionMapEntryExists && collisionMap[gameObjectI.collisionName].indexOf(gameObjectJ.collisionName) != -1
					
					if ( collisionNameNotNothing &&					
						 bothInUse &&		
						 collisionMapEntryExists &&
						 testForCollision)
					{
						if (gameObjectI.CollisionArea.intersects(gameObjectJ.CollisionArea))
						{
							gameObjectI.collision(gameObjectJ);
							gameObjectJ.collision(gameObjectI);
						}
					}			
				}
			}
		}
	}
}