package
{
	import flash.events.Event;
	
	public class HUDEvent extends Event
	{
		public static const GAME_PAUSE:String = "game_pause";
		public static const GAME_RESUME:String = "game_resume";
		public static const GAME_RESTART:String = "game_restart";
		public static const GAME_PLAY:String = "game_play";
		
		public function HUDEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}