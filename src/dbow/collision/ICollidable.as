package dbow.collision
{
	import flash.geom.Vector3D;

	public interface ICollidable
	{	
		function addCollision(c:ICollidable):void
		function clearCollisions():void
		function processCollisions():void;
		function onCollision(c:ICollidable):void;
		
		function get size():Number;
		function set size(value:Number):void;
		
		function get position():Vector3D;
		
		function get name():String;
		function set name(value:String):void;
	}
}