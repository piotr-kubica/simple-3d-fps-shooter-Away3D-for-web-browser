package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.extrusions.Elevation;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.methods.FogMethod;
	import away3d.materials.methods.ShadingMethodBase;
	
	import dbow.ai.AICommand;
	import dbow.ai.AIEvent;
	import dbow.assets.GameAssetEvent;
	import dbow.assets.GameAssetLibrary;
	import dbow.assets.GameAssetLoader;
	import dbow.assets.MD2Asset;
	import dbow.collision.CollisionSystem;
	import dbow.game.Enemy;
	import dbow.game.GameObject;
	import dbow.game.Missile;
	import dbow.game.MissileEvent;
	import dbow.game.Player;
	import dbow.game.Terrain;
	import dbow.input.KeyboardInput;
	import dbow.input.MouseInput;
	import dbow.particle.Explosion;
	import dbow.particle.ParticleEvent;
	import dbow.util.FPPCam;
	import dbow.util.Randomizer;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Vector3D;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.ui.Keyboard;
	import flash.utils.Timer;
	
	public class GameEngine extends Sprite
	{
		// loader progress
		private var _loader:MovieClip = null;
		private var _progressMask:MovieClip = null;
		
		// head up display
		private var _hud:GameHUD = null;
		
		// countdown timer
		private var _timer:Timer = null;
				
		// assets
		private var _gal:GameAssetLoader = null;
		private var _gil:GameAssetLibrary = null;
				
		// game objects
		private var _camera:FPPCam = null;
		private var _keyInput:dbow.input.KeyboardInput = null;
		private var _mouseInput:MouseInput = null;
		private var _view:View3D = null;
		
		// world objects
		private var _world:Terrain = null;
		private var _player:Player = null;
		private var _enemies:Vector.<Enemy> = null;
		private var _ammo:Vector.<Missile> = null;
		private var _explosions:Vector.<Explosion> = null;
		
		// effects
		private var _fog:ShadingMethodBase = new FogMethod(GameConfig.FOG_DISTANCE, GameConfig.BG_COLOR);

		public function GameEngine() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			_gil = new GameAssetLibrary();
			_gal = new GameAssetLoader();
			_gal.addToLoad(GameAssetEvent.MOVIECLIP, 'assets/loader.swf', initLoader, "assetloader");
			_gal.load(null);
		}
		
		private function initLoader(e:GameAssetEvent):void {
			initScene();
			
			_loader = (e.gameAsset as MovieClip);
			_loader.scaleX = _loader.scaleY = 0.6;
			centerDisplayObj(_loader);
			stage.addChild(_loader);
			
			var ldrmc:MovieClip = _loader.getChildAt(1) as MovieClip;
			_progressMask = ldrmc.getChildByName("bbar") as MovieClip;
			_progressMask.scaleX = 0;
			
			loadGameAssets();
		}
		
		private function loadGameAssets():void {
			_gal.addToLoad(GameAssetEvent.MOVIECLIP, 'assets/hud_menu.swf', onAssetLoaded, "menu");
			_gal.addToLoad(GameAssetEvent.MOVIECLIP, 'assets/hud_game.swf', onAssetLoaded, "status");
			_gal.addToLoad(GameAssetEvent.MOVIECLIP, 'assets/hud_pause.swf', onAssetLoaded, "pause");
			_gal.addToLoad(GameAssetEvent.MOVIECLIP, 'assets/hud_end.swf', onAssetLoaded, "end");
			
			_gal.addToLoad(GameAssetEvent.MP3, 'assets/bgwind.mp3', onAssetLoaded, "bgmusic");
			_gal.addToLoad(GameAssetEvent.MP3, 'assets/explode.mp3', onAssetLoaded, "explosion");
			
			_gal.addToLoad(GameAssetEvent.IMAGE, 'assets/terrain.jpg', onAssetLoaded, "terrain");
			_gal.addToLoad(GameAssetEvent.IMAGE, 'assets/ground.jpg', onAssetLoaded, "ground");
			_gal.addToLoad(GameAssetEvent.IMAGE, 'assets/explosion.png', onAssetLoaded, "expl");
			_gal.addToLoad(GameAssetEvent.IMAGE, 'assets/cr.png', onAssetLoaded, "cross");
			
			_gal.addToLoad(GameAssetEvent.IMAGE, 'assets/igdosh.jpg', onAssetLoaded, "ogre_tex");
			_gal.addToLoad(GameAssetEvent.IMAGE, 'assets/abarlith.jpg', onAssetLoaded, "tris_tex");
			
			var i:int = 0;
			
			// load tris enemies
			for(i = 0; i < GameConfig.TRIS_ENEMY_CNT; i++) {
				_gal.addToLoad(GameAssetEvent.MD2, 'assets/tris.md2', onAssetLoaded, "tris" + i);	
			}
			
			// load ogre enemies
			for(i = 0; i < GameConfig.OGRE_ENEMY_CNT; i++) {
				_gal.addToLoad(GameAssetEvent.MD2, 'assets/ogre.md2', onAssetLoaded, "ogre" + i);	
			}
			
			// load rocket
			for(i = 0; i < GameConfig.ROCKET_CNT; i++) {
				_gal.addToLoad(GameAssetEvent.MAX, 'assets/missile.3ds', onAssetLoaded, "rocket" + i);
			}
			_gal.load(initGame);
//			trace(_gal.resourceToLoadCnt());
		}
		
		private function onAssetLoaded(e:GameAssetEvent):void {
//			trace(_gal.resoucesLoaded());
			_progressMask.scaleX = _gal.resoucesLoaded() / _gal.resourceToLoadCnt();
			_gil.addAsset(e);
		}
		
		private function initGame(e:Event):void {
			stage.removeChild(_loader);

			initWorld();
			initPlayer();
			initAmmo();
			initModels();
			initExplosionBuffer();
			initControls();
			
			// head up display
			_hud = new GameHUD(
				stage, _keyInput, _mouseInput,
				_gil.getAsset(GameAssetEvent.IMAGE, "cross") as BitmapData,
				_gil.getAsset(GameAssetEvent.MOVIECLIP, "menu") as MovieClip,
				_gil.getAsset(GameAssetEvent.MOVIECLIP, "status") as MovieClip,
				_gil.getAsset(GameAssetEvent.MOVIECLIP, "end") as MovieClip,
				_gil.getAsset(GameAssetEvent.MOVIECLIP, "pause") as MovieClip,
				_enemies.length
			);
			_hud.addEventListener(HUDEvent.GAME_RESTART, onRestart);
			_hud.addEventListener(HUDEvent.GAME_PLAY, onPlay);
			_hud.addEventListener(HUDEvent.GAME_PAUSE, onPause);
			_hud.addEventListener(HUDEvent.GAME_RESUME, onResume);
			
			// play background sound
			var s:Sound = _gil.getAsset(GameAssetEvent.MP3, "bgmusic") as Sound;
			var sc:SoundChannel = s.play(0, int.MAX_VALUE);
			var st:SoundTransform = sc.soundTransform;
			st.volume = 0.3;
			sc.soundTransform = st;
			
			// timer
			_timer = new Timer(1000);
			_timer.addEventListener(TimerEvent.TIMER, onTimerTick);
			
			// start game
			onRestart(null);
			_hud.init();
			
			// notify window resize 
			stage.addEventListener(Event.RESIZE, resizeHandler);
			stage.addEventListener(Event.RESIZE, _hud.resizeHandler);
			
			trace("sorter");
			trace(_view.renderer.renderableSorter);
			
			// rendering loop
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function resizeHandler(e:Event):void {
			_view.width = stage.stageWidth;
			_view.height = stage.stageHeight;
		}
		
		private function onEnterFrame(event:Event): void {
			GameObject.collisionSystem.detectCollisions();
			_world.update();
			_view.render();
		}
		
		private function onRestart(e:Event):void {
			if(e == null) {
				resetEnemies(false);	
			} else {
				resetEnemies(true);
			}
			_player.setPhysicsPosition(new Vector3D());
			_hud.fragCnt = 0;
		}
		
		private function onPlay(e:Event):void {
			_timer.reset();
			_hud.updateTimeDisplay(GameConfig.GAME_TIME - _timer.currentCount);
			_timer.start();
			enableControls();
		}
		
		private function onPause(e:Event):void {
			disableControls();
			_player.resetMovement();
			_timer.stop();
		}
		
		private function onResume(e:Event):void {
			enableControls();
			_timer.start();
		}

		private function onTimerTick(te:TimerEvent):void {
			var d:int = GameConfig.GAME_TIME - _timer.currentCount;
			_hud.updateTimeDisplay(d);
			
			// lose
			if(d <= 0) {
				_timer.stop();
				disableControls();
				_player.resetMovement();
				_hud.displayLose();
			}
		}
		
		private function enemyKilled():void {
			_hud.fragCnt++;
			
			// win
			if(_hud.fragCnt >= _enemies.length) {
				_timer.stop();
				disableControls();
				_player.resetMovement();
				_hud.displayWin();
			}
		}
		
		private function resetEnemies(remove:Boolean = true):void {
			if(remove){
				for(var i:int = 0; i < _enemies.length; i++){
					if(_world.containsChild(_enemies[i])) {
						_world.removeChild(_enemies[i]);
					}
					if(CollisionSystem.getInstance().hasCollidable(_enemies[i])) {
						CollisionSystem.getInstance().removeCollidable(_enemies[i]);					
					}
				}	
			}
			
			// set position of enemies
			for each(var en:Enemy in _enemies) {
				var maxX:Number = _world.maxX - GameConfig.FIGURE_OFF_BOUND;
				var maxZ:Number = _world.maxZ - GameConfig.FIGURE_OFF_BOUND;
				var minX:Number = _world.minX + GameConfig.FIGURE_OFF_BOUND;
				var minZ:Number = _world.minZ + GameConfig.FIGURE_OFF_BOUND;
				en.setPhysicsPosition(new Vector3D(Randomizer.getRand(maxX, minX), 0, 
					Randomizer.getRand(maxZ, minZ)));
				
				_world.addChild(en);
				CollisionSystem.getInstance().addCollidable(en);
				en.resetAI();
			}
		}

		private function enableControls():void {
			_mouseInput.addEventListener(MouseEvent.MOUSE_MOVE, _player.updateMouseCoords);
			_mouseInput.addEventListener(MouseEvent.MOUSE_UP, fireMissile);
			
			_keyInput.registerListener(Keyboard.A, _player.strafeLeft);
			_keyInput.registerListener(Keyboard.D, _player.strafeRight);
			_keyInput.registerListener(Keyboard.W, _player.moveFwd);
			_keyInput.registerListener(Keyboard.S, _player.moveRwd);
		}
		
		private function disableControls(): void {
			_mouseInput.removeEventListener(MouseEvent.MOUSE_MOVE, _player.updateMouseCoords);
			_mouseInput.removeEventListener(MouseEvent.MOUSE_UP, fireMissile);
			
			_keyInput.removeListener(Keyboard.A, _player.strafeLeft);
			_keyInput.removeListener(Keyboard.D, _player.strafeRight);
			_keyInput.removeListener(Keyboard.W, _player.moveFwd);
			_keyInput.removeListener(Keyboard.S, _player.moveRwd);
		}
		
		private function initScene(): void {
			_view = new View3D();
			_view.antiAlias = 4;
			_view.backgroundColor = GameConfig.BG_COLOR;
			this.addChild(_view);
		}
		
		private function initWorld():void {
			var mat:BitmapMaterial = new BitmapMaterial(_gil.getAsset(GameAssetEvent.IMAGE, "ground") as BitmapData);
			mat.addMethod(_fog);
			var elev:Elevation = new Elevation(mat, _gil.getAsset(GameAssetEvent.IMAGE, "terrain")  as BitmapData, 2000);
			
			_world = new Terrain(elev);
			_world.name = "world";
			_view.scene.addChild(_world);
		}
		
		private function initPlayer():void {
			_camera = new FPPCam(this.stage);
			_view.camera = _camera;
			_player = new Player(_camera, GameConfig.FIGURE_SIZE, true, 
								GameConfig.FIGURE_OFF_BOUND, GameConfig.PLAYER_OFF_GROUD);
			_player.maxLinVel = new Vector3D(GameConfig.PLAYER_MAX_SPEED, 0, 
											 GameConfig.PLAYER_MAX_SPEED);		
			_player.name = "player";
			_world.addChild(_player);
		}
		
		private function initAmmo():void {
			_ammo = new Vector.<Missile>();

			for(var i:int = 0; i < GameConfig.ROCKET_CNT; i++) {
				var rocket:ObjectContainer3D = ObjectContainer3D(_gil.getAsset(GameAssetEvent.MAX, "rocket" + i));
				rocket.scale(0.5);
				var m:Missile = new Missile(rocket, 10, false); // !!
				m.linVelDapming = new Vector3D();
				m.addEventListener(MissileEvent.MISSILE_HIT, onMissileHit);
				m.addEventListener(MissileEvent.MISSILE_MISSED, onMissileMissed);
				_ammo.push(m);
			}
		}
		
		private function initModels():void {
			_enemies = new Vector.<Enemy>();
			var i:int = 0;
			
			// create tris enemies
			for(i = 0; i < GameConfig.TRIS_ENEMY_CNT; i++) {
				var trisMat:BitmapMaterial = new BitmapMaterial(BitmapData(_gil.getAsset(GameAssetEvent.IMAGE, "tris_tex")));
				trisMat.addMethod(_fog);
				var tris:MD2Asset = MD2Asset(_gil.getAsset(GameAssetEvent.MD2, "tris" + i));
				tris.mesh.material = trisMat;
				var e:Enemy = new Enemy(tris, GameConfig.FIGURE_SIZE, false, 
					GameConfig.FIGURE_OFF_BOUND, GameConfig.ENEMY_OFF_GROUD);
				e.maxLinVel = new Vector3D(GameConfig.TRIS_MAX_SPEED, 0, GameConfig.TRIS_MAX_SPEED); 
				_enemies.push(e);	
			}
			
			// create ogre enemies
			for(i = 0; i < GameConfig.OGRE_ENEMY_CNT; i++) {
				var ogreMat:BitmapMaterial = new BitmapMaterial(BitmapData(_gil.getAsset(GameAssetEvent.IMAGE, "ogre_tex")));
				ogreMat.addMethod(_fog);
				var ogre:MD2Asset = MD2Asset(_gil.getAsset(GameAssetEvent.MD2, "ogre" + i));
				ogre.mesh.material = ogreMat;
				var e:Enemy = new Enemy(ogre, GameConfig.FIGURE_SIZE, false,
					GameConfig.FIGURE_OFF_BOUND, GameConfig.ENEMY_OFF_GROUD);
				e.animDeath = "deatha";
				e.maxLinVel = new Vector3D(GameConfig.OGRE_MAX_SPEED, 0, GameConfig.OGRE_MAX_SPEED); 
				_enemies.push(e);
			}
			
			for each(var en:Enemy in _enemies) {
				en.scareConditionArgs = [_player, en];
				en.scareCondition = function(p:Player, en:Enemy) {
					return Vector3D.distance(p.position, en.position) < GameConfig.SCARE_DISTANCE;
				}
				
				en.maxRotVel = new Vector3D(0, GameConfig.ENEMY_ROT_SPEED, 0);
				en.linVelDapming = new Vector3D();
				
				en.addEventListener(AIEvent.AI_SCARED, onAIScared);
				en.addEventListener(AIEvent.AI_DEAD, onAIDead);
				en.addEventListener(AIEvent.AI_UNCARING, onAIUncaring);
			}
		}
		
		private function initExplosionBuffer():void {
			_explosions = new Vector.<Explosion>();
			var x:Explosion = null;
			
			for(var i:int = 0; i < GameConfig.EXPLOSION_BUFFER; i++) {
				x = new Explosion(50, BitmapData(_gil.getAsset(GameAssetEvent.IMAGE, "expl")));
				x.addEventListener(ParticleEvent.PARTICLES_INACTIVE, removeExplosion);
				_explosions.push(x);
			}
		}
		
		private function initControls(): void {
			_mouseInput = new MouseInput(this.stage);
			_keyInput = new dbow.input.KeyboardInput(this.stage);
		}
		
		private function centerDisplayObj(m:MovieClip):void {
			m.x = (stage.width - m.width) / 2;
			m.y = (stage.height - m.height) / 2;
		}

		private function fireMissile(e:Event):void {
			if(_ammo.length <= 0) {
//				trace("missile not ready");
				return;
			} else {
//				trace("missile ammo: " + _ammo.length);
			}
			
			var hd:Vector3D = _player.headingDirection();
			var m:Missile = _ammo.pop();
			var mVel:Vector3D = hd.clone();
			var mPos:Vector3D = hd.clone();
			
			mVel.scaleBy(GameConfig.ROCKET_SPEED);
			mPos.scaleBy(GameConfig.ROCKET_OFFSET);
			mPos = _player.position.add(mPos);
			
			// add to world & collision sys
			_world.addChild(m);
			CollisionSystem.getInstance().addCollidable(m);
			
			// set missile position and direction
			m.setPhysicsPosition(mPos);
			m.lookAt(mPos.add(hd));
			m.linVel = mVel;
		}
		
		private function onMissileHit(e:MissileEvent):void {
			var m:Missile = e.target as Missile;
			resetMissile(m);
			
			var explosion:Explosion = null;
			
			if(_explosions.length == 0) { // create explosion effect
				explosion = new Explosion(50, BitmapData(_gil.getAsset(GameAssetEvent.IMAGE, "expl")));
				explosion.addEventListener(ParticleEvent.PARTICLES_INACTIVE, removeExplosion);
			} else {
				explosion = _explosions.pop();	
			}
//			trace(_player.position);
//			var playerPosNorm:Vector3D = _player.position.clone();
//			playerPosNorm.normalize();
			
			explosion.emit(m.position.add(new Vector3D(0, 20, 0)));
			explosion.lookAt(_player.position);
			_world.addChild(explosion);
			
			// play explosion sound
			(_gil.getAsset(GameAssetEvent.MP3, "explosion") as Sound).play(0, 1);
			
//			trace("missile hit");
//			trace("explosion buffer: " + _explosions.length);
		}
		
		private function onMissileMissed(e:MissileEvent):void {
			var m:Missile = e.target as Missile;
			resetMissile(m);
//			trace("missile missed");
		}
		
		private function resetMissile(m:Missile):void {
			CollisionSystem.getInstance().removeCollidable(m);
			
			try {
				_world.removeChild(m);
				_ammo.push(m);
			} catch (e:Error){
//				trace("couldn't remove child");
			}
		}
		
		private function removeExplosion(e:ParticleEvent):void {
			if(e.target is Explosion) {
				var expl:Explosion = e.target as Explosion; 
				_world.removeChild(expl);
				_explosions.push(expl);
//				trace("remove explosion");
			}
		}
		
		private function onAIUncaring(e:AIEvent):void {
//			trace(e.type);
			var en:Enemy = (e.target as Enemy);
			en.clearCommands();
			en.resetVelocities();

			var paramObjRotate:Object = new Object();
			paramObjRotate.angle = Randomizer.getRand(180, -180);
			en.addCommand(new AICommand(rotateByAngle, [paramObjRotate, en]));

			var paramObjRun:Object = new Object();
			paramObjRun.iter = Randomizer.getRand(GameConfig.RUNAWAY_MAX_ITER, 
												  GameConfig.RUNAWAY_MIN_ITER);
			en.addCommand(new AICommand(runAway, [paramObjRun, en, headingDirection]));
		}
		
		private function onAIScared(e:AIEvent):void {
//			trace(e.type);
			
			var en:Enemy = (e.target as Enemy);
			en.clearCommands();
			en.resetVelocities();
			
			var paramObjRotate:Object = new Object();
			paramObjRotate.angle = _player.alienFigureAngle(en) 
								   + Randomizer.getRand(GameConfig.ROT_MAX_RAND, 
									   					-GameConfig.ROT_MAX_RAND);
			en.addCommand(new AICommand(rotateByAngle, [paramObjRotate, en]));
		
			var paramObjRun:Object = new Object();
			paramObjRun.iter = Randomizer.getRand(GameConfig.RUNAWAY_MAX_ITER, 
												  GameConfig.RUNAWAY_MIN_ITER);
			en.addCommand(new AICommand(runAway, [paramObjRun, en, headingDirection]));
		}
		
		private function onAIDead(e:AIEvent):void {
//			trace(e.type + " " + (e.target is Enemy));
			var en:Enemy = e.target as Enemy;
			en.clearCommands();
			en.resetVelocities();
			
			// remove enemy
			CollisionSystem.getInstance().removeCollidable(en);
			_world.removeChild(en);
			
			// updates frag count
			enemyKilled();
			
			// XXX
//			en.animState = en.animDeath;
		}
		
		private function rotateByAngle(p:Object, en:Enemy):Boolean {
			const rotSpeed:Number = 8; 
			
			if(Math.abs(p.angle) > rotSpeed) {
				if(p.angle < 0) {
					en.rotVel = new Vector3D(0, -GameConfig.ENEMY_ROT_SPEED, 0);
					p.angle += rotSpeed;
				} else {
					en.rotVel = new Vector3D(0, GameConfig.ENEMY_ROT_SPEED, 0);
					p.angle -= rotSpeed;
				}
				
				en.animState = en.animStand;
				return false;
			} else {
				en.rotVel = new Vector3D();
				return true;							
			}
		}
		
		private function runAway(p:Object, en:Enemy, runDir:Function):Boolean {
			if(p.iter-- > 0) {
				en.linVel = runDir.call(null, en);
				en.linVel.scaleBy(4);
				en.animState = en.animRun;
				return false;
			} else {
				en.linVel = new Vector3D();
				en.animState = en.animStand;
				return true;							
			}
		}
		
		private function headingDirection(e:Enemy):Vector3D {
			var d:Vector3D = e.transform.transformVector(Vector3D.X_AXIS);
			d.decrementBy(e.position);
			return d;
		}
	}
}