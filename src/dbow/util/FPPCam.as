package dbow.util
{
	import away3d.cameras.Camera3D;
	import away3d.cameras.lenses.LensBase;
	
	import dbow.input.MouseInput;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	public class FPPCam extends Camera3D
	{
		private var _stage:Stage;
		
		private var _sx:Number = 0;
		private var _sy:Number = 0;
		private var _rx:Number = 0;
		private var _ry:Number = 0;
		
		private var _sensitivity:Number;
		private var _pitchLimit:Number;
		private var _yawLimit:Number;
		
		private static const TO_RAD:Number = Math.PI / 180.0;

		public function FPPCam(stage:Stage, lens:LensBase=null) {
			super(lens);
			_stage = stage;
			_sensitivity = 1.0;
			_pitchLimit = 60;
			_yawLimit = Number.MAX_VALUE;
			this.lens.far += 25;
			this.lens.near -= 10;
			//trace("LF: " + this.lens.far + " LN: " + this.lens.near);
		}

		public function get yawLimit():Number
		{
			return _yawLimit;
		}

		public function set yawLimit(value:Number):void
		{
			_yawLimit = value;
		}

		public function get pitchLimit():Number
		{
			return _pitchLimit;
		}

		public function set pitchLimit(value:Number):void
		{
			_pitchLimit = value;
		}

		public function get sensitivity():Number
		{
			return _sensitivity;
		}

		public function set sensitivity(value:Number):void
		{
			_sensitivity = value;
		}
		
		public function updateMouseCoords(e:Event): void {
			if(e.target is MouseInput) {
				var mi:MouseInput = e.target as MouseInput;
				_sy += -mi.dx;
				_sx += mi.dy;
			}
		}
		
		public function updateRotation(): void {
			// update rotation
			_rx = (_sx + _stage.height / 2) * _sensitivity;
			_ry = (_sy - _stage.width / 2) * _sensitivity;

			// limit rotation
			if(_ry > _yawLimit) {
				rotationY = _yawLimit;
			} else if(_ry < -_yawLimit) {
				rotationY = -_yawLimit;
			} else {
				rotationY = _ry;
			}
			
			if(_rx > _pitchLimit) {
				rotationX = _pitchLimit
			} else if(_rx < -_pitchLimit) {
				rotationX = -_pitchLimit;
			} else {
				rotationX = _rx;
			}
		}
		
		public function get forwardVectorDir():Vector3D {
			var lv:Vector3D = new Vector3D(Math.cos((-_ry + 90) * TO_RAD), 0, Math.sin((-_ry + 90) * TO_RAD));
			lv.normalize();
			return lv;
		}
		
		public function get leftVectorDir():Vector3D {
			var lv:Vector3D = new Vector3D(Math.cos(-_ry * TO_RAD), 0, Math.sin(-_ry * TO_RAD));
			lv.normalize();
			return lv;
		}
	}
}