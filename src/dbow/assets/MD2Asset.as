package dbow.assets
{
	import away3d.animators.VertexAnimator;
	import away3d.entities.Mesh;

	public class MD2Asset
	{
		private var _animator:VertexAnimator = null;
		private var _mesh:Mesh = null
		
		public function MD2Asset(mesh:Mesh = null, animator:VertexAnimator = null) {
			_mesh = mesh;
			_animator = animator;
		}

		public function get mesh():Mesh
		{
			return _mesh;
		}

		public function set mesh(value:Mesh):void
		{
			_mesh = value;
		}

		public function get animator():VertexAnimator
		{
			return _animator;
		}

		public function set animator(value:VertexAnimator):void
		{
			_animator = value;
		}
	}
}