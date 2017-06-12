package dbow.particle
{
	import flash.events.Event;
	
	public class ParticleEvent extends Event
	{
		public static const PARTICLES_INACTIVE:String = "particles_inactive";
		
		public function ParticleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}