package dbow.game
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.partition.EntityNode;
	import away3d.entities.Entity;
	
	import dbow.collision.CollisionSystem;
	import dbow.collision.ICollidable;
	
	import flash.display3D.IndexBuffer3D;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import flashx.textLayout.utils.CharacterUtil;
	
	public class GameObject extends Entity implements ICollidable
	{
		private var _size:Number;
		private var _collisions:Vector.<ICollidable> = new Vector.<ICollidable>();
		
		public static var collisionSystem:CollisionSystem = CollisionSystem.getInstance();
		
		public function GameObject(size:Number = 10, addToCollisionSystem:Boolean = true){
			super();
			this._size = size;
			
			if(collisionSystem != null && addToCollisionSystem) {
				collisionSystem.addCollidable(this);
			}
		}
		
		public function get size():Number{
			return _size;
		}

		public function set size(value:Number):void{
			_size = value;
		}
		
		// override
		public function update():void {
			processCollisions();
			
			for(var i:int = 0; i < this.numChildren; i++) {
				if(this.getChildAt(i) is GameObject) {
					(this.getChildAt(i) as GameObject).update();
				}
			}
		}
		
		public function addCollision(c:ICollidable):void {
			_collisions.push(c);
		}
		
		public function clearCollisions(): void {
			_collisions = new Vector.<ICollidable>();
		}
		
		public function processCollisions(): void {
			while(_collisions.length > 0) {
				this.onCollision(_collisions.pop());
			}
		}
		
		// override
		public function onCollision(c:ICollidable): void {
			trace(this.name + " collided with " + c.name);
		}
		
		public function isRootGameObject():Boolean {
			return (this.parent != null && !(parent is GameObject));
		}
		
		public function hasChild():Boolean {
			return numChildren != 0;
		}
		
		public function containsChild(c:GameObject):Boolean {
			for(var i:int = 0; i < numChildren; i++){
				if(getChildAt(i) == c) {
					return true;
				}
			}
			return false;
		}

		// XXX
		override protected function updateBounds():void {
			// update size
			// parent bounds >= bounds of all children
		}
		
		override protected function createEntityPartitionNode():EntityNode {
			return new EntityNode(this);
		}
		
		override public function toString():String {
			return "[GameObject: " + this.name + "]";			
		}
	}
}