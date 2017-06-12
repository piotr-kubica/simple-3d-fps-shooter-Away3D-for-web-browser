package dbow.game
{
	import away3d.containers.ObjectContainer3D;
	
	import dbow.collision.ICollidable;

	public class Missile extends PhysicsObject
	{
		private var _model:ObjectContainer3D = null;
		private const _yMaxCollisionOffset:Number = 300;
		
		public function Missile(object3d:ObjectContainer3D, size:Number=10, addToCollisionSystem:Boolean=true) {
			super(size, addToCollisionSystem);
			_model = object3d;
			_model.rotationY = -90;
			addChild(_model);
		}
	
		override public function onCollision(c:ICollidable):void {
			if(c is Terrain) {
				var t:Terrain = c as Terrain;
				var h:Number = t.getHeightAt(this.x, this.z);
				
				if(this.z > t.maxZ || this.z < t.minZ || this.x > t.maxX ||
					this.x < t.minX || this.y > t.maxY + _yMaxCollisionOffset) {
					dispatchEvent(new MissileEvent(MissileEvent.MISSILE_MISSED));					
				} else if (this.y < h) {
					dispatchEvent(new MissileEvent(MissileEvent.MISSILE_HIT));
				}
			} else if(c is Enemy) {
				dispatchEvent(new MissileEvent(MissileEvent.MISSILE_HIT));
			}
		}
		
		override protected function updatePosition():void {
			this.position = _position;
		}
	}
}