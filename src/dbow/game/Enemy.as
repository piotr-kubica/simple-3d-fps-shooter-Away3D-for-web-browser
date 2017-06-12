package dbow.game
{
	import away3d.animators.VertexAnimator;
	import away3d.entities.Mesh;
	
	import dbow.ai.AIEvent;
	import dbow.ai.ICommand;
	import dbow.assets.MD2Asset;
	import dbow.collision.ICollidable;
	import dbow.util.UtilVector3D;
	
	import flash.geom.Vector3D;

	public class Enemy extends Figure implements Intelligent
	{
		private var _aiState:String = null;
//		private var _aiCollision:Boolean = false;
		private var _aiCommand:Vector.<ICommand> = null;

		private var _scareCondition:Function = null;
		private var _scareConditionArgs:Array = null;
				
		private var _model:Mesh = null;
		private var _animator:VertexAnimator = null;
		private var _animState:String = null;
		
		// animation
		private var _animStand:String = "stand";
		private var _animRun:String = "run";
		private var _animDeath:String = "death";
		
		public function Enemy(md2Asset:MD2Asset, size:Number = 10, addToCollisionSystem:Boolean = true, 
							  offBound:Number = 50, offGround:Number = 50) {
			super(size, addToCollisionSystem, offBound, offGround);
			
			if(md2Asset == null){
				throw new ArgumentError("Argument md2asset must not be null");
			}
			_model = md2Asset.mesh;
			_animator = md2Asset.animator;
			addChild(_model);
			_aiCommand = new Vector.<ICommand>();
			_aiState = AIEvent.AI_UNCARING;
		}
		
		public function get animState():String
		{
			return _animState;
		}
		
		public function set animState(value:String):void
		{
			if(value != _animRun && value != _animStand && value != _animDeath){
				throw new Error("unknown anim state assigned");
			}
			
			if(_animState != value) {
				_animator.stop();
				_animState = value;
				_animator.play(_animState);
			}
		}
		
		public function get animDeath():String
		{
			return _animDeath;
		}
		
		public function set animDeath(value:String):void
		{
			_animDeath = value;
		}
		
		public function get animRun():String
		{
			return _animRun;
		}
		
		public function set animRun(value:String):void
		{
			_animRun = value;
		}
		
		public function get animStand():String
		{
			return _animStand;
		}
		
		public function set animStand(value:String):void
		{
			_animStand = value;
		}
		
		public function get scareCondition():Function
		{
			return _scareCondition;
		}
		
		public function set scareCondition(value:Function):void
		{
			_scareCondition = value;
		}
		
		public function get scareConditionArgs():Array
		{
			return _scareConditionArgs;
		}
		
		public function set scareConditionArgs(value:Array):void
		{
			_scareConditionArgs = value;
		}
		
		public function get animator():VertexAnimator
		{
			return _animator;
		}

		public function resetVelocities():void {
			_rotVel = new Vector3D();
			_linVel = new Vector3D();
		}
		
		override protected function updatePhysics():void {
			// update linear velocity
			_linVel = UtilVector3D.limitAbs(_linVel, _maxLinVel);
			_position.incrementBy(_linVel);
			
			// update radial velocity
			_rotVel = UtilVector3D.limitAbs(_rotVel, _maxRotVel);
			_rotation.incrementBy(_rotVel);
		}
		
		override public function onCollision(c:ICollidable):void {
			super.onCollision(c);

			if(c is Enemy) {
				var e:Enemy = c as Enemy;
				var d:Vector3D = this.position.subtract(e.position);
				d.y = 0;
				var v:Vector3D = _linVel.clone();
				v.negate();
				
				if(v.lengthSquared <= 0 || (Vector3D.angleBetween(d, v) * UtilVector3D.TO_DEG) <= 60) {
					_position.decrementBy(_linVel);
				}
			} else if(c is Missile) {
				_aiState = AIEvent.AI_DEAD;
				dispatchEvent(new AIEvent(AIEvent.AI_DEAD));
			}
		}
		
		public function processAI():void {
			if(_aiState == AIEvent.AI_DEAD) {
				return;
			}
			if(_scareCondition != null && _scareCondition.apply(null, _scareConditionArgs) 
				&& (_aiState != AIEvent.AI_SCARED || _aiCommand.length <= 0)) {
				_aiState = AIEvent.AI_SCARED;
				dispatchEvent(new AIEvent(AIEvent.AI_SCARED));	
			} else if(_aiCommand.length <= 0) {
				_aiState = AIEvent.AI_UNCARING;
				dispatchEvent(new AIEvent(AIEvent.AI_UNCARING));
			}	
		}
		
		public function resetAI():void {
			_aiState = AIEvent.AI_UNCARING;
		}
		
		override public function update():void {
			updatePhysics();
			processCollisions();
			processAI();
			processAICommand();
			updatePosition();
			
			for(var i:int = 0; i < this.numChildren; i++) {
				if(this.getChildAt(i) is GameObject) {
					(this.getChildAt(i) as GameObject).update();
				}
			}
		}
		
		public function addCommand(c:ICommand):uint {
			return _aiCommand.unshift(c);
		}
		
		public function clearCommands():void {
			_aiCommand = new Vector.<ICommand>();
		}
		
		private function processAICommand():void {
			if(_aiCommand.length > 0) {
				if(_aiCommand[_aiCommand.length - 1].completed()) {
					_aiCommand.pop();
				}
			}
		}
	}
}