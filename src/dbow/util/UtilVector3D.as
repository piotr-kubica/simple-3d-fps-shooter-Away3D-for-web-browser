package dbow.util
{
	import flash.geom.Vector3D;

	public class UtilVector3D
	{
		public static const TO_DEG:Number = 180 / Math.PI;
		
		public function UtilVector3D() {
			throw new Error("UtilVector3D cannot be instantiated");
		}

		public static function limitAbs(v:Vector3D, limiter:Vector3D): Vector3D {
			if(limiter.x < 0 || limiter.y < 0 || limiter.z < 0) {
				throw new ArgumentError("limiter values must not be negative");
			}
			
			if(v.x > limiter.x) {
				v.x = limiter.x;
			} else if(v.x < -limiter.x) {
				v.x = -limiter.x;
			}
			
			if(v.y > limiter.y) {
				v.y = limiter.y;
			} else if(v.y < -limiter.y) {
				v.y = -limiter.y;
			}
			
			if(v.z > limiter.z) {
				v.z = limiter.z;
			} else if(v.z < -limiter.z) {
				v.z = -limiter.z;
			}
			
			return v;
		}
		
		public static function limitMin(v:Vector3D, limiter:Vector3D): Vector3D {
			if(v.x < limiter.x) {
				v.x = limiter.x;
			}
			
			if(v.y < limiter.y) {
				v.y = limiter.y;
			}
			
			if(v.z < limiter.z) {
				v.z = limiter.z;
			}
			
			return v;
		}
		
		public static function limitMax(v:Vector3D, limiter:Vector3D): Vector3D {
			if(v.x > limiter.x) {
				v.x = limiter.x;
			}
			
			if(v.y > limiter.y) {
				v.y = limiter.y;
			}
			
			if(v.z > limiter.z) {
				v.z = limiter.z;
			}
			
			return v;
		}
		
		public static function limitZero(v:Vector3D, damping:Vector3D): Vector3D {
			if(damping.x < 0 || damping.y < 0 || damping.z < 0) {
				throw new ArgumentError("damping values must not be negative");
			}
			
			if(v.x > 0) {
				v.x -= damping.x;
				
				if(v.x < 0){
					v.x = 0;
				}
			} else if (v.x < 0) {
				v.x += damping.x;
				
				if(v.x > 0){
					v.x = 0;
				}
			}
			
			if(v.y > 0) {
				v.y -= damping.y;
				
				if(v.y < 0){
					v.y = 0;
				}
			} else if (v.y < 0) {
				v.y += damping.y;
				
				if(v.y > 0){
					v.y = 0;
				}
			}
			
			if(v.z > 0) {
				v.z -= damping.z;
				
				if(v.z < 0){
					v.z = 0;
				}
			} else if (v.z < 0) {
				v.z += damping.z;
				
				if(v.z > 0){
					v.z = 0;
				}
			}
			
			return v;
		}
		
		public static function vectorX(v:Vector3D): Vector3D {
			return new Vector3D(v.x);
		}
		
		public static function vectorY(v:Vector3D): Vector3D {
			return new Vector3D(0, v.y);
		}
		
		public static function vectorZ(v:Vector3D): Vector3D {
			return new Vector3D(0, 0, v.z);
		}
	}
}