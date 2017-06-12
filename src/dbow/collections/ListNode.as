package dbow.collections
{
	public class ListNode
	{
		private var _next:ListNode = null;
		private var _value:Object = null;
		
		public function ListNode(value:Object){
			if(value == null) {
				throw new ArgumentError("Argument can not be null. Argument 'value' requries object");
			}
			this._value = value;
		}

		internal function get next():ListNode {
			return _next;
		}

		internal function set next(value:ListNode):void {
			_next = value;
		}

		internal function get value():Object {
			return _value;
		}

		internal function set value(value:Object):void {
			_value = value;
		}
	}
}