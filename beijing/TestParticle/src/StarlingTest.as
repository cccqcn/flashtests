package 
{
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.extensions.PDParticleSystem;
	import starling.textures.Texture;
	
	public class StarlingTest extends Sprite
	{
		[Embed(source="particle.pex", mimeType="application/octet-stream")]
		private var FireConfig:Class;
		[Embed(source = "texture.png")]
		private var FireParticle:Class;
		
		public function StarlingTest()
		{
			test();
		}
		public function test():void
		{
			var psConfig:XML = XML(new FireConfig());
			var psTexture:Texture = Texture.fromBitmap(new FireParticle());
			
			// create particle system
			var ps:PDParticleSystem = new PDParticleSystem(psConfig, psTexture);
			ps.x = 160;
			ps.y = 240;
			
			// add it to the stage and the juggler
			addChild(ps);
			Starling.juggler.add(ps);
			
			// change position where particles are emitted
			ps.emitterX = 20;
			ps.emitterY = 40;
			
			// start emitting particles
			ps.start();
			
			// emit particles for two seconds, then stop
			ps.start(2.0);
			
			// stop emitting particles; the existing particles will continue to animate.
//			ps.stop();
			
			// stop emitting particles; the existing particles will be removed.
//			ps.stop(true);
		}
	}
}