package dbow.game
{
	import dbow.util.UtilVector3D;
	
	import flash.geom.Vector3D;

	public class PhysicsObject extends GameObject {
		
		protected var _acc:Vector3D = null;
		protected var _linVel:Vector3D = null;
		protected var _rotVel:Vector3D = null;
		
		protected var _maxLinVel:Vector3D = null;
		protected var _maxRotVel:Vector3D = null;
		
		protected var _linVelDapming:Vector3D = null;
		
		protected var _position:Vector3D = null;
		protected var _rotation:Vector3D = null;
		
		public function PhysicsObject(size:Number = 10, addToCollisionSystem:Boolean = true) {
			super(size, addToCollisionSystem);
			_acc = new Vector3D();
			_linVel = new Vector3D();
			_rotVel = new Vector3D();
			_maxLinVel = new Vector3D(1,1,1);
			_maxRotVel = new Vector3D(1,1,1);
			_linVelDapming = new Vector3D(0.2, 0.2, 0.2);
			_position = new Vector3D();
			_rotation = new Vector3D();
		}
		
		public function get acc():Vector3D
		{
			return _acc;
		}
		
		public function set acc(value:Vector3D):void
		{
			_acc = value;
		}
		
		public function get linVel():Vector3D
		{
			return _linVel;
		}

		public function set linVel(value:Vector3D):void
		{
			_linVel = value;
		}

		public function get rotVel():Vector3D
		{
			return _rotVel;
		}

		public function set rotVel(value:Vector3D):void
		{
			_rotVel = value;
		}

		public function get maxRotVel():Vector3D
		{
			return _maxRotVel;
		}

		public function set maxRotVel(value:Vector3D):void
		{
			_maxRotVel = value;
		}

		public function get maxLinVel():Vector3D
		{
			return _maxLinVel;
		}

		public function set maxLinVel(value:Vector3D):void
		{
			_maxLinVel = value;
		}

		public function get linVelDapming():Vector3D
		{
			return _linVelDapming;
		}

		public function set linVelDapming(value:Vector3D):void
		{
			_linVelDapming = value;
		}

		public function getPhysicsPosition():Vector3D {
			return _position;
		}
		
		public function setPhysicsPosition(value:Vector3D):void {
			_position = value;
			updatePosition();
		}
		
		public function getPhysicsRotation():Vector3D {
			return _rotation;
		}
		
		public function setPhysicsRotation(value:Vector3D):void {
			_rotation = value;
			updatePosition();
		}
		
		override public function update():void {
			updatePhysics();
			processCollisions();
			updatePosition();
			
			for(var i:int = 0; i < this.numChildren; i++) {
				if(this.getChildAt(i) is GameObject) {
					(this.getChildAt(i) as GameObject).update();
				}
			}
		}
		
		// override
		protected function updatePhysics():void {
			// update linear velocity
			if(_acc.lengthSquared > 0){
				_linVel.incrementBy(_acc);
				_linVel = UtilVector3D.limitAbs(_linVel, _maxLinVel);
			} else {
				_linVel = UtilVector3D.limitZero(_linVel, _linVelDapming);
			}
			
			_position.incrementBy(_linVel);
			
			// update radial velocity
			_rotVel = UtilVector3D.limitAbs(_rotVel, _maxRotVel);
			_rotation.incrementBy(_rotVel);
		}
		
		// update x,y,z object position and rotation
		protected function updatePosition():void {
			this.position = _position;
			this.rotateTo(_rotation.x, _rotation.y, _rotation.z);
		}
	}
}
