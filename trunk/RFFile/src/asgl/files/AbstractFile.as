package asgl.files {
	import flash.events.EventDispatcher;
	
	[Event(name="complete", type="asgl.events.FileEvent")]
	[Event(name="error", type="asgl.events.FileEvent")]
	
	public class AbstractFile extends EventDispatcher {
		public var characterSet:String = CharacterSet.UTF_8;
		protected namespace hide;
		protected var _list:Array;
		protected var _isCorrectFormat:Boolean = false;
		public function get isCorrectFormat():Boolean {
			return _isCorrectFormat;
		}
		public function clear():void {
			_isCorrectFormat = false;
		}
		hide function cloneList():Array {
			var list:Array = [];
			if (_list == null) return list;
			var length:int = _list.length;
			for (var i:int = 0; i<length; i++) {
				list[i] = _list[i];
			}
			return list;
		}
	}
}