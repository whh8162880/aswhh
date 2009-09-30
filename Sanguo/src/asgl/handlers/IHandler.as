package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.mesh.TriangleFace;
	
	public interface IHandler {
		function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void;
	}
}