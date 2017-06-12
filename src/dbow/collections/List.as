package dbow.collections
{
	public class List
	{
		private var _head:ListNode = null;
		
		public function List(collection:Array = null){
			if(collection != null) {
				for each (var value:Object in collection) {
					add(value);
				}	
			}
		}
		
		internal function getHead():ListNode {
			return _head;
		}
		
		public function getIterator():ListIterator {
			return new ListIterator(this);
		}
		
		public function add(o:Object):void {
			if(_head == null) {
				_head = new ListNode(o);
			} else {
				var node:ListNode = new ListNode(o);
				node.next = _head;
				_head = node;
			}
		}
		
		public function addAt(index:int, o:Object):void {
			if(index <= 0 || isEmpty()) {
				add(o);
			} else {
				var it:ListNode = _head;
				
				while(it.next != null && --index > 0) {
					it = it.next;
				}
				
				if(it.next == null) {
					it.next = new ListNode(o);	
				} else {
					var tmp:ListNode = it.next;
					it.next = new ListNode(o);
					it.next.next = tmp;
				}
			}
		}
		
		public function getAt(index:int):Object {
			if(index < 0){
				return null;	
			}
			var it:ListNode = _head;
			var last:ListNode = null;
			
			while(it != null && index-- >= 0) {
				last = it;
				it = it.next;
			}
			return index >=0 ? null : last.value;
		}
				
		public function remove(o:Object):Object {
			if(isEmpty()) {
				return null;
			}
			var it:ListNode = _head;
			var last:ListNode = null;
			
			while(it.value != o && it.next != null) {
				last = it;
				it = it.next;
			}
			
			if(it.value == o){
				if(it == _head) {
					_head = _head.next;
				} else {
					last.next = it.next;
				}
				it.next = null;
				var val:Object = it.value;
				it.value = null;
				return val;
			}
			return null;
		}
		
		public function removeAt(index:int):Object {
			if(isEmpty() || index < 0) {
				return null;
			}
			var it:ListNode = _head;
			var last:ListNode = null;
			
			while(it.next != null && index-- > 0) {
				last = it;
				it = it.next;
			}
			
			if(it == _head) {
				_head = _head.next;
			} else {
				last.next = it.next;
			}
			it.next = null;
			var val:Object = it.value;
			it.value = null;
			return val;
		}
		
		public function contains(o:Object):Boolean {
			var it:ListNode = _head;
			
			while(it != null) {
				if(it.value == o) {
					return true;
				}
				it = it.next;
			}
			return false;
		}
		
		public function size():int {
			var it:ListNode = _head;
			var cnt:int = 0;
			
			while(it != null) {
				cnt++;
				it = it.next;
			}
			return cnt;
		}
		
		public function clear():void {
			var last:ListNode = null;
			
			while(_head != null) {
				last = _head;
				_head = _head.next;
				last.next = null;
				last.value = null;
			}
		}
		
		public function isEmpty():Boolean {
			return _head == null;
		}
		
		public function toString():String {
			var it:ListNode = _head;
			var s:String = "";
			
			while(it != null){
				s += it.value.toString() + "," ;
				it = it.next;
			}
			return (s == "" ? "empty" : s);
		}
		
		// indexOf
		// set
		// toArray
	}
}