package dbow.game
{
	import dbow.collision.ICollidable;
	import dbow.util.UtilVector3D;
	
	import flash.geom.Vector3D;

	public class Figure extends PhysicsObject
	{
		protected var _offBound:Number = 0; // margin to x,z positive and negative bounds
		protected var _offGround:Number = 0; // level over ground (value on y axis)
		
		public function Figure(size:Number=10, addToCollisionSystem:Boolean=true, 
							   offBound:Number = 50, offGround:Number = 50) {
			super(size, addToCollisionSystem);
			_offBound = offBound;
			_offGround = offGround;
		}
		
		override public function onCollision(c:ICollidable): void {
			if(c is Terrain) {
				var t:Terrain = c as Terrain;
				var max:Vector3D = new Vector3D(t.maxX - _offBound, 0, t.maxZ - _offBound);
				var min:Vector3D = new Vector3D(t.minX + _offBound, 0, t.minZ + _offBound);
				_position = UtilVector3D.limitMax(_position, max);
				_position = UtilVector3D.limitMin(_position, min);
				_position.y = t.getHeightAt(_position.x, _position.z) + _offGround;
			}
		}
		
		public function figureAngle(f:Figure):Number {
			// face pointing direction
			var vx:Vector3D = this.transform.transformVector(Vector3D.X_AXIS);
			vx.decrementBy(this.position);
			vx.y = 0;
			
			// parallel pointing direction
			var vz:Vector3D = this.transform.transformVector(Vector3D.Z_AXIS);
			vz.decrementBy(this.position);
			
			// this direction
			var d:Vector3D = this.position.subtract(f.position);
			d.y = 0;
			d.normalize();
			
			return ((d.dotProduct(vz) >= 0) ? -UtilVector3D.TO_DEG : UtilVector3D.TO_DEG) 
					* Vector3D.angleBetween(d, vx); 
		}
		
		public function alienFigureAngle(f:Figure):Number {
			// face pointing direction
			var vx:Vector3D = f.transform.transformVector(Vector3D.X_AXIS);
			vx.decrementBy(f.position);
			vx.y = 0;
			
			// parallel pointing direction
			var vz:Vector3D = f.transform.transformVector(Vector3D.Z_AXIS);
			vz.decrementBy(f.position);
			
			// figure direction
			var d:Vector3D = f.position.subtract(this.position);
			d.y = 0;
			d.normalize();
			
			return ((d.dotProduct(vz) >= 0) ? -UtilVector3D.TO_DEG : UtilVector3D.TO_DEG) 
					* Vector3D.angleBetween(d, vx); 
		}
	}
}