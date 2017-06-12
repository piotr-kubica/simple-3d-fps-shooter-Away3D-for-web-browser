package dbow.ai
{
	import flash.events.Event;
	
	public class AIEvent extends Event
	{
		// AI states
		public static const AI_SCARED:String = "ai_scared";
		public static const AI_UNCARING:String = "ai_uncaring";
		public static const AI_DEAD:String = "ai_dead";
		
		public function AIEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}