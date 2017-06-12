package dbow.ai
{
	public class AICommand implements ICommand
	{
		private var _f:Function = null;
		private var _arg:Array = null;
		
		public function AICommand(func:Function = null, arg:Array = null){
			_f = func;
			_arg = arg;
		}
		
		// override
		public function completed():Boolean {
			if(_f != null) {
				return _f.apply(null, _arg);
			} else {
				return true;
			}
		}
	}
}