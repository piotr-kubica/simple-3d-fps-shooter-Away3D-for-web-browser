package dbow.game
{
	import dbow.collision.ICollidable;
	import dbow.input.KeyInputEvent;
	import dbow.util.FPPCam;
	import dbow.util.UtilVector3D;
	
	import flash.events.Event;
	import flash.geom.Vector3D;

	public class Player extends Figure
	{
		private var _cam:FPPCam = null; // FPP camera object
		
		private var _leftVel:Vector3D = new Vector3D(); // left nad opposite (right) velocity
		private var _forwardVel:Vector3D = new Vector3D(); // forward nad opposite (backward) velocity
		
		private var _moveForward:int = 0; // value indicating player moving direction forward/backward
		private var _moveLeft:int = 0; // value indicating player moving direction left/right
		
		public function Player(camera:FPPCam, size:Number = 10, addToCollisionSystem:Boolean = true, 
							   offBound:Number = 50, offGround:Number = 50) {
			super(size, addToCollisionSystem);
			this._cam = camera;
			this.bounds.fromSphere(new Vector3D(), 10);
			_acc = new Vector3D(0.1, 0.1, 0.1);
			_offBound = offBound;
			_offGround = offGround;
		}
		
		public function resetMovement():void {
			_moveForward = _moveLeft = 0;
		}
		
		override protected function updatePhysics(): void {
			_cam.updateRotation();
			var leftDir:Vector3D = _cam.leftVectorDir;
			var forwardDir:Vector3D = _cam.forwardVectorDir;
			
			// FORWARD <-> BACKWARD (+/- Z-axis) movement 
			// accelerate forward
			if(_moveForward > 0) { 
				_forwardVel.incrementBy(UtilVector3D.vectorZ(_acc));
				_forwardVel = UtilVector3D.limitAbs(_forwardVel, _maxLinVel); 
				forwardDir.scaleBy(_forwardVel.length);

			// accelerate backward
			} else if(_moveForward < 0) {
				_forwardVel.decrementBy(UtilVector3D.vectorZ(_acc));
				_forwardVel = UtilVector3D.limitAbs(_forwardVel, _maxLinVel);
				forwardDir.scaleBy(-_forwardVel.length);
				
			// deaccelerate
			} else {
				_forwardVel = UtilVector3D.limitZero(_forwardVel, _linVelDapming);
				forwardDir.scaleBy(_forwardVel.length * (_forwardVel.z >= 0 ? 1 : -1));
			}
			
			// LEFT <-> RIGHT (+/- X-axis) movement
			// accelerate left
			if(_moveLeft > 0) { 
				_leftVel.incrementBy(UtilVector3D.vectorX(_acc));
				_leftVel = UtilVector3D.limitAbs(_leftVel, _maxLinVel);
				leftDir.scaleBy(-_leftVel.length);
				
			// accelerate right
			} else if(_moveLeft < 0) {
				_leftVel.decrementBy(UtilVector3D.vectorX(_acc));
				_leftVel = UtilVector3D.limitAbs(_leftVel, _maxLinVel);
				leftDir.scaleBy(_leftVel.length);
				
			// deaccelerate
			} else {
				_leftVel = UtilVector3D.limitZero(_leftVel, _linVelDapming);
				leftDir.scaleBy(_leftVel.length * (_leftVel.x >= 0 ? -1 : 1));
			}

			// resultant velocity vector
			_linVel = leftDir.add(forwardDir);
			_position.incrementBy(_linVel);
		}
		
		override public function onCollision(c:ICollidable):void {
			super.onCollision(c);
			
			if(c is Enemy) {
				var e:Enemy = c as Enemy;
				var d:Vector3D = this._cam.position.subtract(e.position);
				d.y = 0;
				var v:Vector3D = _linVel.clone();
				v.negate();
				
				if(v.lengthSquared <= 0 || (Vector3D.angleBetween(d, v) * UtilVector3D.TO_DEG) <= 60) {
					_position.decrementBy(_linVel);
				}
			}
		}
		
		public function headingDirection():Vector3D {
			return _cam.transform.transformVector(Vector3D.Z_AXIS).subtract(_cam.position);
		}
		
		override protected function updatePosition():void {
			this.position = _position;
		}
		
		override public function get x():Number {
			return _cam.x;
		}
		
		override public function set x(value:Number):void {
			_cam.x = value;
		}
		
		override public function get y():Number {
			return _cam.y;
		}
		
		override public function set y(value:Number):void {
			_cam.y = value;
		}
		
		override public function get z():Number {
			return _cam.z;
		}
		
		override public function set z(value:Number):void {
			_cam.z = value;
		}
		
		override public function get position():Vector3D {
			return _cam.position;
		}
		
		override public function set position(value:Vector3D):void {
			_cam.position = value;
		}
		
		public function updateMouseCoords(e:Event): void {
			_cam.updateMouseCoords(e);
		}

		public function moveFwd(e:KeyInputEvent): void {
			_moveForward = e.isPressed ? 1 : 0;
		}
		
		public function moveRwd(e:KeyInputEvent): void {
			_moveForward = e.isPressed ? -1 : 0;
		}
		
		public function strafeLeft(e:KeyInputEvent): void {
			_moveLeft = e.isPressed ? 1 : 0;
		}
		
		public function strafeRight(e:KeyInputEvent): void {
			_moveLeft = e.isPressed ? -1 : 0;
		}
	}
}