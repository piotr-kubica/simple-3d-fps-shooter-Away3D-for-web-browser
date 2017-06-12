package dbow.input
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	
	public class KeyboardInput
	{
		private static const PREFIX:String = "KI_";
		private var _stage:Stage;
		private var _dispatcher:EventDispatcher;
		
		public function KeyboardInput(stage:Stage){
			_stage = stage;
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);	
			_dispatcher = new EventDispatcher();
		}
		
		public function registerListener(keyCode:uint, listener:Function):void {
			_dispatcher.addEventListener(PREFIX + keyCode, listener);
		}
		
		public function removeListener(keyCode:uint, listener:Function):void {
			_dispatcher.removeEventListener(PREFIX + keyCode, listener);
		}
				
		private function keyDownHandler(event:KeyboardEvent):void {
			//trace("key down");
			_dispatcher.dispatchEvent(new KeyInputEvent(PREFIX + event.keyCode, true));
		}
		
		private function keyUpHandler(event:KeyboardEvent):void {
			//trace("key up");
			_dispatcher.dispatchEvent(new KeyInputEvent(PREFIX + event.keyCode, false));
		}
	}
}