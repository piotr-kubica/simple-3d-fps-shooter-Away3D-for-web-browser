package dbow.particle
{
	import dbow.util.Randomizer;
	
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	public class Explosion extends ParticleSystem
	{
		private var _velocity:Vector3D = new Vector3D(0, 1, 0);
		private var _velocitVariation:Vector3D = new Vector3D(0.7, 0.7, 0.7);
		private var _acceleration:Vector3D = new Vector3D(0, -0.05, 0);
		private var _size:Number = 60;
		private var _sizeVariation:Number = 20;
		private var _positionSpread:Vector3D = new Vector3D(30, 30, 30);
		
		public function Explosion(maxParticles:int, bitmapData:BitmapData) {
			super(maxParticles, bitmapData);
		}
		
		override public function update():void {
			_activeParticles = maxParticles;
			
			for(var i:int = 0; i < numChildren; i++) {
				if(!updateParticle((getChildAt(i) as Particle))){
					_activeParticles--;
				}
			}
			
			if(!isActive()) {
				dispatchEvent(new ParticleEvent(ParticleEvent.PARTICLES_INACTIVE));				
			}
		}
		
		override protected function initializeParticle(p:Particle):void {
			// random particle location
			p.x = Randomizer.getRand(_positionSpread.x, -_positionSpread.x);
			p.y = Randomizer.getRand(_positionSpread.y, -_positionSpread.y);
			p.z = Randomizer.getRand(_positionSpread.z, -_positionSpread.z);
			
			// random particle size
			p.size = _size + Randomizer.getRand(_sizeVariation);
			
			// random velocity
			p.velocity = _velocity.add(
				new Vector3D(Randomizer.getRand(_velocitVariation.x, -_velocitVariation.x),
							Randomizer.getRand(_velocitVariation.y, -_velocitVariation.y),
							Randomizer.getRand(_velocitVariation.z, -_velocitVariation.z)));
			
			// acceleration
			p.acceleration = _acceleration;

			// color
			p.color.redMultiplier = 0.6 + Randomizer.getRand(0.4);
			p.color.greenMultiplier = 0.25;
			p.color.blueMultiplier = 0.01;
			p.color.alphaMultiplier = 1;
			
			// random energy (should corelate to frame rate)
			p.energy = Randomizer.getRand(60, 40);
			
			// color delta
			p.colorDelta.redMultiplier = -p.color.redMultiplier / 2.0 / p.energy;
			p.colorDelta.alphaMultiplier = -p.color.alphaMultiplier / p.energy;
			
			// size delta
			p.sizeDelta = -p.size / p.energy;
		}
		
		override protected function updateParticle(p:Particle):Boolean {
			if(p.energy <= 0) {
				return false;
			}
			p.x += p.velocity.x;
			p.y += p.velocity.y;
			p.z += p.velocity.z;
			
			p.velocity.incrementBy(p.acceleration);
			p.energy--;
			p.size += p.sizeDelta;
			
			p.color.alphaMultiplier += p.colorDelta.alphaMultiplier;
			p.color.redMultiplier += p.colorDelta.redMultiplier;
			return true;
		}
	}
}