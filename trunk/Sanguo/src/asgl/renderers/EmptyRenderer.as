package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.mesh.TriangleFace;
	
	public class EmptyRenderer implements IRenderer {
		public function get facesType():String {
			return null;
		}
		public function destroy():void {
		}
		public function render(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFunction:Function):void {
			completeFunction();
		}
	}
}