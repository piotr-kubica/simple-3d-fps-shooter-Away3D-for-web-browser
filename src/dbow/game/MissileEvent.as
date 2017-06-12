package dbow.game
{
	import flash.events.Event;
	
	public class MissileEvent extends Event
	{
		public static const MISSILE_HIT:String = "missile_hit";
		public static const MISSILE_MISSED:String = "missile_missed";
		
		public function MissileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}