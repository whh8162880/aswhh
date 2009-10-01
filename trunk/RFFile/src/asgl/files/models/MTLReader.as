package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.materials.Material;
	public class MTLReader extends AbstractFile {
		public var materials:Vector.<Material>;
		public function MTLReader(data:String=null):void {
			if (data == null) {
				clear();
			} else {
				read(data);
			}
		}
		public override function clear():void {
			super.clear();
			materials = new Vector.<Material>();
		}
		public function read(data:String):void {
			clear();
			try {
				var fileList:Array = data.split('\n');
				var line:String;
				var length:int = fileList.length;
				for (var i:int = 0; i<length; i++) {
					line = fileList[i];
					if (line.indexOf('newmtl ') != -1) {
						materials.push(new Material(line.substr(7)));
					}
				}
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
	}
}