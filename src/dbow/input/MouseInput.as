package dbow.input
{	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	
	public class MouseInput extends EventDispatcher
	{
		private var _stage:Stage = null;
		private var _lastX:Number = 0;
		private var _lastY:Number = 0;
		private var _dx:Number = 0;
		private var _dy:Number = 0;
		
		public function MouseInput(stage:Stage) {
			_stage = stage;
		}
		
		public function get dy():Number
		{
			return _dy;
		}
		
		public function get dx():Number
		{
			return _dx;
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, 
												  priority:int=0, useWeakReference:Boolean=false):void {
			super.addEventListener(type, listener);
			
			if(type == MouseEvent.MOUSE_MOVE) {
				_stage.addEventListener(type, dispatchMouseMove);	
			} else {
				_stage.addEventListener(type, dispatchMouseClick);
			}
		}
		
		override public function hasEventListener(type:String):Boolean {
			return _stage.hasEventListener(type);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			super.removeEventListener(type, listener);
			
			if(type == MouseEvent.MOUSE_MOVE) {
				_stage.removeEventListener(type, dispatchMouseMove);	
			} else {
				_stage.removeEventListener(type, dispatchMouseClick);
			}
		}
		
		protected function dispatchMouseMove(e:Event):void {
			updateCoords();
			dispatchEvent(e);
		}
		
		protected function dispatchMouseClick(e:Event):void {
			dispatchEvent(e);
		}
		
		private function updateCoords(): void {
			_dx = _lastX - _stage.mouseX;
			_dy = _lastY - (_stage.height - _stage.mouseY);
			_lastX = _stage.mouseX;
			_lastY = _stage.height - _stage.mouseY;
		}
	}
}