package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.mesh.TriangleFace;
	
	public class ScreenSpaceFacesDepthSort implements IHandler {
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			var list:Array = [];
			for (var i:int = faces.length-1; i>=0; i--) {
				list[i] = faces[i];
			}
			list.sortOn('screenSpaceDepthSortValue', Array.DESCENDING|Array.NUMERIC);
			completeFucntion(Vector.<TriangleFace>(list));
		}
	}
}