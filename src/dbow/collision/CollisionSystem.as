package dbow.collision
{
	import dbow.collections.List;
	import dbow.collections.ListIterator;

	public class CollisionSystem
	{
		private var _collidables:List;
		private static var _instanceGuard:Boolean = true;
		private static var _instance:CollisionSystem = null;
		
		public function CollisionSystem() {
			if(_instanceGuard) {
				throw new Error("CollisionSystem can be instantiated only once!");
			}
			_collidables = new List();
		}
		
		public static function getInstance():CollisionSystem {
			_instanceGuard = false;
			
			if(_instance == null) {
				_instance = new CollisionSystem();
			}
			_instanceGuard = true;
			return _instance;
		}
		
		public function addCollidable(c:ICollidable):Boolean {
			if(c == null) {
				throw new ArgumentError("parameter cannot be null");
			}
			if(!_collidables.contains(c)) {
				_collidables.add(c);
				return true
			}
			return false;
		}
		
		public function removeCollidable(c:ICollidable):Boolean {
			if(c == null) {
				throw new ArgumentError("parameter cannot be null");
			}
			return _collidables.remove(c) != null;
		}
		
		public function hasCollidable(c:ICollidable):Boolean {
			if(c == null) {
				throw new ArgumentError("parameter cannot be null");
			}
			return _collidables.contains(c);
		}
		
		public function detectCollisions():void {
			var ita:ListIterator = _collidables.getIterator();
			var c1:ICollidable = null;
			var c2:ICollidable = null;

			while(ita.hasNext()) {
				c1 = ICollidable(ita.next());// as ICollidable;
				var itb:ListIterator = ita.colne();
				
				while(itb.hasNext()) {
					c2 = ICollidable(itb.next());// as ICollidable;
					
					if(c1.position.subtract(c2.position).length <= c1.size + c2.size) {
						 c1.addCollision(c2);
						 c2.addCollision(c1);
					}
				}
			}
		}
	}
}