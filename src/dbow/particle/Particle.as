package dbow.particle
{
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Plane;
	
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	
	public class Particle extends Plane
	{
		private var _acc:Vector3D = new Vector3D();
		private var _vel:Vector3D = new Vector3D();
		private var _energy:Number = 0;
		private var _energyDelta:Number = 0;
		private var _sizeDelta:Number = 0;
		private var _colorDelta:ColorTransform = new ColorTransform();
		
		public function Particle(material:BitmapMaterial, size:Number = 10) {
			super(material, size, size, 1, 1, true);
			material.colorTransform = new ColorTransform();
			material.bothSides = true;
			
			if(material == null) {
				throw new Error("Material must not be null");
			}
		}
		
		public function get acceleration():Vector3D
		{
			return _acc;
		}

		public function set acceleration(value:Vector3D):void
		{
			_acc = value;
		}

		public function get velocity():Vector3D
		{
			return _vel;
		}

		public function set velocity(value:Vector3D):void
		{
			_vel = value;
		}

		public function get energy():Number
		{
			return _energy;
		}

		public function set energy(value:Number):void
		{
			_energy = value;
		}
		
		public function get energyDelta():Number
		{
			return _energyDelta;
		}
		
		public function set energyDelta(value:Number):void
		{
			_energyDelta = value;
		}
		
		public function get sizeDelta():Number
		{
			return _sizeDelta;
		}

		public function set sizeDelta(value:Number):void
		{
			_sizeDelta = value;
		}

		public function set size(value:Number):void {
			width = value;
			height = value;
		}
		
		public function get size():Number {
			return width; // or height
		}
		
		public function get color():ColorTransform
		{
			return (this.material as BitmapMaterial).colorTransform;
		}
		
		public function set color(value:ColorTransform):void
		{
			(this.material as BitmapMaterial).colorTransform = value;
		}
		
		public function get colorDelta():ColorTransform
		{
			return _colorDelta;
		}
		
		public function set colorDelta(value:ColorTransform):void
		{
			_colorDelta = value;
		}
	}
}