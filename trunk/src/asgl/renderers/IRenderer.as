package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.mesh.TriangleFace;
	
	public interface IRenderer {
		function get facesType():String;
		function destroy():void;
		function render(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFunction:Function):void;
	}
}