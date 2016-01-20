package
{
	import flare.basic.Scene3D;
	import flare.core.Boundings3D;
	import flare.core.Camera3D;
	import flare.core.Easing3D;
	import flare.core.Frame3D;
	import flare.core.Knot3D;
	import flare.core.Label3D;
	import flare.core.Light3D;
	import flare.core.Lines3D;
	import flare.core.Mesh3D;
	import flare.core.Particle3D;
	import flare.core.ParticleEmiter3D;
	import flare.core.Pivot3D;
	import flare.core.Poly3D;
	import flare.core.Shape3D;
	import flare.core.Spline3D;
	import flare.core.Surface3D;
	import flare.core.Texture3D;
	import flare.loaders.Flare3DLoader;
	import flare.loaders.Flare3DLoader1;
	import flare.loaders.Flare3DLoader2;
	import flare.loaders.Flare3DLoader3;
	import flare.materials.Material3D;
	import flare.materials.ParticleMaterial3D;
	import flare.materials.Shader3D;
	import flare.materials.flsl.FLSLFilter;
	import flare.modifiers.Modifier;
	import flare.modifiers.SkinModifier;
	import flare.modifiers.VertexAnimationModifier;
	import flare.system.ILibraryExternalItem;
	import flare.utils.Pivot3DUtils;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.registerClassAlias;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.setInterval;
	
	public class HelloWorldWorker extends Sprite
	{
		[Embed(source = "wunv.f3d", mimeType = "application/octet-stream")]
		private var MODEL3D:Class;
		[Embed(source = "map.f3d", mimeType = "application/octet-stream")]
		private var MAP:Class;
		
		
		private var scene:Scene3D;
		private var planet:Flare3DLoader;
		private var planet1:Flare3DLoader1;
		private var planet2:Flare3DLoader2;
		private var planet3:Flare3DLoader3;
		
		protected var mainToWorker:MessageChannel;
		protected var workerToMain:MessageChannel;
		
		protected var worker:Worker;
		
		public function HelloWorldWorker()
		{
			
			/** 
			 * Start Main thread
			 **/
			if(Worker.current.isPrimordial){
				
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP_LEFT;
				
				scene = new Scene3D( this );
				
				scene.clearColor.setTo( 0.8, 0.8, 0.8 );
				scene.antialias = 5;
				scene.camera = new Camera3D( "myOwnCamera" );
				
				// we can manipulate the camera just like any 3d object.
				scene.camera.setPosition( 0, 150, -250 );
				scene.camera.lookAt( 0, 110, 0 );
				
				// add global scene progress and complete events.
				
//				planet = new Flare3DLoader( MODEL3D );
//				planet.parent = scene;
////				//planet.load();scene.addChildFromFile(planet);
//				planet.addEventListener( Scene3D.PROGRESS_EVENT, progressEvent );
//				planet.addEventListener( Scene3D.COMPLETE_EVENT, completeEvent );
//				planet.load();
				completeEvent(null);
				stage.addEventListener(MouseEvent.CLICK, onClick);
				
				
				
				//Set an interval that will ask the worker thread to do some math
					
			} 
			/** 
			 * Start Worker thread 
			 **/
			else {
				
				//Inside of our worker, we can use static methods to 
				//access the shared messgaeChannel's
				mainToWorker = Worker.current.getSharedProperty("mainToWorker");
				workerToMain = Worker.current.getSharedProperty("workerToMain");
				//Listen for messages from the server
				mainToWorker.addEventListener(Event.CHANNEL_MESSAGE, onMainToWorker);
				
				trace(9999999999999);
				planet.parent = scene;
				scene.library.push(planet as ILibraryExternalItem);
//				var barr:ByteArray = Worker.current.getSharedProperty("map");
//				barr.position = 0;
//				var obj:Object = barr.readObject();
//				var abc:Pivot3D = new Flare3DLoader1( obj );
			}
		}
		private function progressEvent(e:Event):void 
		{
			// gets the global loading progress.
			trace( scene.loadProgress );
		}
		
		private function completeEvent(e:Event):void 
		{
			// once the scene has been loaded, resume the render.
			scene.resume();
			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
			
			
			//Create worker from our own loaderInfo.bytes
			worker = WorkerDomain.current.createWorker(this.loaderInfo.bytes);
			
			//Create messaging channels for 2-way messaging
			mainToWorker = Worker.current.createMessageChannel(worker);
			workerToMain = worker.createMessageChannel(Worker.current);
			
			//Inject messaging channels as a shared property
			worker.setSharedProperty("mainToWorker", mainToWorker);
			worker.setSharedProperty("workerToMain", workerToMain);
			
			//Listen to the response from our worker
			workerToMain.addEventListener(Event.CHANNEL_MESSAGE, onWorkerToMain);
			
			//Start worker (re-run document class)
			worker.start();
			onClick(null);
//			setInterval(function(){
//				//mainToWorker.send("HELLO");
//				//trace("[Main] HELLO");
//				
//				trace("[Main] ADD 2 + 2?");
//				mainToWorker.send(2);
//				mainToWorker.send(2);
//				
//			}, 1000);
		}
		private function updateEvent(e:Event):void 
		{
			
		}
		private var barr:ByteArray;
		private var ld:URLLoader;
		private function onClick(e:MouseEvent):void
		{
			ld = new URLLoader;
			ld.dataFormat = URLLoaderDataFormat.BINARY;
			ld.load(new URLRequest("male-body.f3d"));
			ld.addEventListener(Event.COMPLETE, onLoad);
//			mainToWorker.send("ADD");
		}
		private function onLoad(e:Event):void
		{
			barr = ld.data as  ByteArray;
			barr.shareable = true;
			worker.setSharedProperty("map", barr);
			trace(barr.length);
//			barr.position = 0;
//			var obj:Object = barr.readObject();
			registerClassAlias("flash.geom.Vector3D", Vector3D);
			registerClassAlias("flash.geom.Matrix3D", Matrix3D);
			registerClassAlias("flare.core.Pivot3D", Pivot3D);
			registerClassAlias("flare.core.Mesh3D", Mesh3D);
			registerClassAlias("flare.core.Boundings3D", Boundings3D);
			registerClassAlias("flare.modifier.SkinModifier", VertexAnimationModifier);
			registerClassAlias("flare.modifier.SkinModifier", SkinModifier);
			registerClassAlias("flare.modifier.Modifier", Modifier);
			registerClassAlias("flare.core.Camera3D", Camera3D);
			registerClassAlias("flare.core.Surface3D", Surface3D);
			registerClassAlias("flare.core.Frame3D", Frame3D);
			registerClassAlias("flare.core.Easing3D", Easing3D);
			registerClassAlias("flare.core.Knot3D", Knot3D);
			registerClassAlias("flare.core.Label3D", Label3D);
			registerClassAlias("flare.core.Light3D", Light3D);
			registerClassAlias("flare.core.Lines3D", Lines3D);
			registerClassAlias("flare.core.Particle3D", Particle3D);
			registerClassAlias("flare.core.ParticleEmiter3D", ParticleEmiter3D);
			registerClassAlias("flare.core.Poly3D", Poly3D);
			registerClassAlias("flare.core.Shape3D", Shape3D);
			registerClassAlias("flare.core.Spline3D", Spline3D);
			registerClassAlias("flare.materials.Material3D", Material3D);
			registerClassAlias("flare.materials.Shader3D", Shader3D);
			registerClassAlias("flare.materials.ParticleMaterial3D", ParticleMaterial3D);
			registerClassAlias("flare.materials.flsl.FLSLFilter", FLSLFilter);
			registerClassAlias("abc", int);
//			registerClassAlias("flare.core.Texture3D", Texture3D);
			planet = new Flare3DLoader( barr );
			planet.load();
			var p:Pivot3D = planet.clone();
			Pivot3DUtils.traceInfo(p, true);
			p.download();
			var children:* = p.children;
			var b2:ByteArray = new ByteArray;
			b2.writeObject(children);
			var b:ByteArray = new ByteArray;
			b.writeObject(p);
			b.position = 0;
			b2.position = 0;
			var a:Object = b.readObject();
//			var a2:Object = b2.readObject();
			var c:* = a;
			c.parent = scene;
//			mainToWorker.send(barr);
		}
				
		//Messages to the Main thread
		protected function onMainToWorker(event:Event):void {
			var msg:* = mainToWorker.receive();
			//When the main thread sends us HELLO, we'll send it back WORLD
			var barr:ByteArray = Worker.current.getSharedProperty("map");
			registerClassAlias("flash.geom.Vector3D", Vector3D);
			registerClassAlias("flash.geom.Matrix3D", Matrix3D);
			registerClassAlias("flare.core.Pivot3D", Pivot3D);
			registerClassAlias("flare.core.Mesh3D", Mesh3D);
			registerClassAlias("flare.core.Boundings3D", Boundings3D);
			registerClassAlias("flare.modifier.Modifier", Modifier);
			registerClassAlias("flare.core.Camera3D", Camera3D);
			registerClassAlias("flare.core.Surface3D", Surface3D);
			if(barr)
			{
				planet = new Flare3DLoader( barr );
				planet.addEventListener(Scene3D.COMPLETE_EVENT, function loadComplete(event:Event):void {
					planet1.removeEventListener(Scene3D.COMPLETE_EVENT, loadComplete);
					
				});
				planet.load();
			}
			//Return the result to the main thread
			var b:ByteArray = new ByteArray;
			var p:Pivot3D = planet.clone();
			b.writeObject(p.children);
			workerToMain.send(b);
		}
		
		//Messages to the worker thread
		protected function onWorkerToMain(event:Event):void {
			//Trace out whatever message the worker has sent us.
			var obj:ByteArray = workerToMain.receive();
			obj.position = 0;
			var p:Object = obj.readObject();
			trace("[Worker] " , obj);
		}
	}
}