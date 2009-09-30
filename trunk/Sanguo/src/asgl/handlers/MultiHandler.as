package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.mesh.TriangleFace;

	public class MultiHandler implements IHandler {
		public var handlers:Vector.<IHandler>;
		public var multiFaces:Vector.<Vector.<TriangleFace>>;
		public function MultiHandler(multiFaces:Vector.<Vector.<TriangleFace>>=null, handlers:Vector.<IHandler>=null):void {
			this.multiFaces = multiFaces;
			this.handlers = handlers;
		}
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			if (multiFaces == null) {
				completeFucntion(faces);
			} else {
				var length:int = multiFaces.length;
				if (length == 0) {
					completeFucntion(faces);
				} else {
					var totalHandlers:int = handlers == null ? 0 : handlers.length;
					if (totalHandlers == 0) {
						_completeFucntion(new Vector.<Vector.<TriangleFace>>(), completeFucntion);
					} else {
						var total:int = length*totalHandlers;
						var count:int = 0;
						var currentIndex:int;
						var list:Vector.<Vector.<TriangleFace>> = multiFaces.concat();
						var func:Function = function (faces:Vector.<TriangleFace>):void {
							list[currentIndex++] = faces;
							if (++count == total) _completeFucntion(list, completeFucntion);
						}
						for (var i:int = 0; i<totalHandlers; i++) {
							var handler:IHandler = handlers[i];
							currentIndex = 0;
							for (var j:int = 0; j<length; j++) {
								handler.handle(driver, list[j], func);
							}
						}
					}
				}
			}
		}
		private function _completeFucntion(list:Vector.<Vector.<TriangleFace>>, func:Function):void {
			var out:Vector.<TriangleFace> = new Vector.<TriangleFace>();
			var length:int = list.length;
			for (var i:int = 1; i<length; i++) {
				out = out.concat(list[i]);
			}
			func(out);
		}
	}
}