package
{
	import dbow.input.KeyInputEvent;
	import dbow.input.KeyboardInput;
	import dbow.input.MouseInput;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.ui.Keyboard;

	public class GameHUD extends EventDispatcher
	{
		private var _stage:Stage = null;
		private var _keyInput:KeyboardInput = null;
		private var _mouseInput:MouseInput = null;
		
		// gunpoint
		private var _gunpoint:Bitmap = null;
		
		// start game menu
		private var _menu:MovieClip = null;
		
		// top hud menu
		private var _status:MovieClip = null;
		
		// win / lose menu
		private var _end:MovieClip = null;
		
		// pause menu
		private var _pause:MovieClip = null;
		
		// textfield msg on win 
		private var _wonMsg:Object = null;
		
		// textfield msg on lose
		private var _lostMsg:Object = null;
		
		// texfield frags shot
		private var _frags:Object = null;
		
		// time left textfield
		private var _time:Object = null;
		private var _fragCnt:int = 0;
		private var _enemyCnt:int = 0;
		
		public function GameHUD(stage:Stage, ki:KeyboardInput, mi:MouseInput, gunpoint:BitmapData, menu:MovieClip, status:MovieClip,
								end:MovieClip, pause:MovieClip, enemyCnt:int) {
			super();
			_stage = stage;
			_keyInput = ki;
			_mouseInput = mi;
			_gunpoint = new Bitmap(gunpoint);
			_menu = menu;
			_status = status;
			_end = end;
			_pause = pause;
			_enemyCnt = enemyCnt;
			_stage.addChild(_gunpoint);
			_stage.addChild(_menu);
			_stage.addChild(_status);
			_stage.addChild(_end);
			_stage.addChild(_pause);
			initGunpoint();
			initMenu();
			initStatus();
			initPause();
			initEnd();
		}
		
		public function get fragCnt():int {
			return _fragCnt;
		}

		public function set fragCnt(value:int):void {
			_fragCnt = value;
			_frags.text = _fragCnt + "/" + _enemyCnt;
		}
		
		public function updateTimeDisplay(secLeft:int):void {
			var r:int = secLeft % 60;
			_time.text = Math.floor(secLeft / 60) + ":" + (r < 10 ? "0" : "") + r;
		}
		
		public function displayWin():void {
			_keyInput.removeListener(Keyboard.ESCAPE, pauseResumeGame);
			_status.visible = false;
			_gunpoint.visible = false;
			_end.visible = true;
			_lostMsg.visible = false;
			_wonMsg.visible = true;
		}
		
		public function displayLose():void {
			_keyInput.removeListener(Keyboard.ESCAPE, pauseResumeGame);
			_status.visible = false;
			_gunpoint.visible = false;
			_end.visible = true;
			_wonMsg.visible = false;
			_lostMsg.visible = true;
		}
		
		public function init():void {
			_menu.visible = true;
			_gunpoint.visible = false;
			_status.visible = false;
			_pause.visible = false;
			_end.visible = false;
		}
		
		public function resizeHandler(e:Event):void {
			centerDisplayObj(_gunpoint);
			centerDisplayObj(_menu);
			centerDisplayObj(_pause);
			centerDisplayObj(_end);
		}
		
		private function initGunpoint():void {
			_gunpoint.scaleX = _gunpoint.scaleY = 0.6;
			centerDisplayObj(_gunpoint);
			_gunpoint.bitmapData.colorTransform(_gunpoint.bitmapData.rect, new ColorTransform(1, 0, 0, 1));
		}
		
		private function initMenu():void {
			centerDisplayObj(_menu);
			var btnPlay:SimpleButton = (_menu.getChildAt(1) as MovieClip)
				.getChildByName("btnplay") as SimpleButton;
			btnPlay.addEventListener(MouseEvent.CLICK, playGame);
		}
		
		private function initStatus():void {
			_frags = (_status.getChildAt(1) as MovieClip).getChildByName("tffrags");
			_time = (_status.getChildAt(1) as MovieClip).getChildByName("tftime");
		}
		
		private function initPause():void {
			centerDisplayObj(_pause);
			var btnResume:SimpleButton = (_pause.getChildAt(1) as MovieClip)
				.getChildByName("btnresume") as SimpleButton;
			var btnRestart:SimpleButton = (_pause.getChildAt(1) as MovieClip)
				.getChildByName("btnrestart") as SimpleButton;
			btnResume.addEventListener(MouseEvent.CLICK, pauseResumeGame);
			btnRestart.addEventListener(MouseEvent.CLICK, restartGame);
		}
		
		private function initEnd():void {
			centerDisplayObj(_end);
			_wonMsg = (_end.getChildAt(1) as MovieClip)
				.getChildByName("tfwon");
			_lostMsg = (_end.getChildAt(1) as MovieClip)
				.getChildByName("tflost");
			var btnPlayAgain:SimpleButton = (_end.getChildAt(1) as MovieClip)
				.getChildByName("btnrestart") as SimpleButton;
			btnPlayAgain.addEventListener(MouseEvent.CLICK, restartGame);
		}
		
		private function playGame(e:Event):void {
			_menu.visible = false;
			_gunpoint.visible = true;
			_status.visible = true;
			_fragCnt = 0;
			_frags.text = _fragCnt + "/" + _enemyCnt;
			_keyInput.registerListener(Keyboard.ESCAPE, pauseResumeGame);

			dispatchEvent(new HUDEvent(HUDEvent.GAME_PLAY));
		}
		
		private function pauseResumeGame(e:Event):void {
			if(e is KeyInputEvent && !(e as KeyInputEvent).isPressed) {
				return;
			}
			
			if(_pause.visible) {
				_gunpoint.visible = true;
				dispatchEvent(new HUDEvent(HUDEvent.GAME_RESUME));
			} else {
				_gunpoint.visible = false;
				dispatchEvent(new HUDEvent(HUDEvent.GAME_PAUSE));		
			}
			_pause.visible = !_pause.visible;
		}
		
		private function restartGame(e:Event):void {
			_menu.visible = true;
			_gunpoint.visible = false;
			_status.visible = false;
			_pause.visible = false;
			_end.visible = false;
			
			_keyInput.removeListener(Keyboard.ESCAPE, pauseResumeGame);
			dispatchEvent(new HUDEvent(HUDEvent.GAME_RESTART));
		}
		
		private function centerDisplayObj(m:DisplayObject):void {
			m.x = (_stage.width - m.width) / 2;
			m.y = (_stage.height - m.height) / 2;
		}
	}
}