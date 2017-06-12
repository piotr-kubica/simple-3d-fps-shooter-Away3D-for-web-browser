package dbow.collections
{
	public class ListIterator
	{
		private var _list:List = null;
		private var _node:ListNode = null
		
		public function ListIterator(list:List){
			if(list == null) {
				throw new ArgumentError("list cannot be null");
			}
			_list = list;
			reset();
		}
		
		public function reset():void {
			_node = new ListNode("iterator");
			_node.next = _list.getHead();
		}
		
		public function hasNext():Boolean {
			return _node.next != null;
		}
		
		public function next():Object {
			_node = _node.next;
			return _node.value;
		}
		
		public function colne():ListIterator {
			var li:ListIterator = new ListIterator(this._list);
			li._node = this._node;
			return li;
		}
	}
}