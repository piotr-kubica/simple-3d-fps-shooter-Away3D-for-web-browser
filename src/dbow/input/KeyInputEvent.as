package dbow.input
{
	import flash.events.KeyboardEvent;
	
	public class KeyInputEvent extends KeyboardEvent
	{
		private var _isPressed:Boolean = false;
		
		public function KeyInputEvent(type:String, isPressed:Boolean, bubbles:Boolean=true, cancelable:Boolean=false, charCodeValue:uint=0, keyCodeValue:uint=0, keyLocationValue:uint=0, ctrlKeyValue:Boolean=false, altKeyValue:Boolean=false, shiftKeyValue:Boolean=false)
		{
			super(type, bubbles, cancelable, charCodeValue, keyCodeValue, keyLocationValue, ctrlKeyValue, altKeyValue, shiftKeyValue);
			_isPressed = isPressed;
		}

		public function get isPressed():Boolean
		{
			return _isPressed;
		}
	}
}