package dbow.game
{
	import away3d.errors.AbstractMethodError;
	import away3d.extrusions.Elevation;
	
	import dbow.collision.ICollidable;
	
	// TODO override all Elevation methods and constructor
	// init/define material externally as in Elevation constructor
	public class Terrain extends GameObject
	{
		private var _terrain:Elevation;
		
		public function Terrain(terrain:Elevation = null, addToCollisionSystem:Boolean = true)
		{
			super(0, addToCollisionSystem);
			
			if(terrain == null) {
				throw new AbstractMethodError("constructor requires parameter");
			}
			_terrain = terrain;
			addChild(_terrain);
			this.size = _terrain.bounds.max.length;
//			this.size = new Vector3D(500, 100, 500).length;
		}
		
		override public function onCollision(c:ICollidable):void {
			//super.onCollision(c);
		}
		
		override public function get maxX():Number {
			return _terrain.maxX;
		}
		
		override public function get maxY():Number {
			return _terrain.maxY;
		}
		
		override public function get maxZ():Number {
			return _terrain.maxZ;
		}
		
		override public function get minX():Number {
			return _terrain.minX;
		}
		
		override public function get minY():Number {
			return _terrain.minY;
		}
		
		override public function get minZ():Number {
			return _terrain.minZ;
		}
		
		public function getHeightAt(x:Number, y:Number):Number {
			return _terrain.getHeightAt(x, y);
		}
	}
}