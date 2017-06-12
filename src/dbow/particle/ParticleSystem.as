package dbow.particle
{
	import away3d.materials.BitmapMaterial;
	
	import dbow.game.GameObject;
	
	import flash.display.BitmapData;
	import flash.geom.Vector3D;
	
	public class ParticleSystem extends GameObject
	{
		private var _maxParticles:int = 0;
		protected var _activeParticles:int = 0;
						
		public function ParticleSystem(maxParticles:int, bitmapData:BitmapData) {
			super(0, false);
			
			if(maxParticles <= 0 || bitmapData == null) {
				throw new Error("ParticleSystem parameters not valid");	
			}
			_maxParticles = maxParticles;
			
			for(var i:int = 0; i < _maxParticles; i++) {
				var p:Particle = new Particle(new BitmapMaterial(bitmapData));
				p.rotationX = -90;
				this.addChild(p);
			}
		}
		
		public function get maxParticles():int {
			return _maxParticles;
		}

		override public function update():void {
			throw new Error("update is abstract and must be implemented in subclass");
		}
		
		public function emit(origin:Vector3D):void {
			this.position = origin;
			
			for(var i:int = 0; i < numChildren; i++) {
				initializeParticle(getChildAt(i) as Particle);
			}
			_activeParticles = _maxParticles;
		}
		
		public function isActive():Boolean {
			return _activeParticles > 0;
		}
		
		protected function updateParticle(p:Particle):Boolean {
			throw new Error("updateParticle is abstract and must be implemented in subclass");
		}
		
		protected function initializeParticle(p:Particle):void {
			throw new Error("initializeParticle is abstract and must be implemented in subclass");
		}
	}
}