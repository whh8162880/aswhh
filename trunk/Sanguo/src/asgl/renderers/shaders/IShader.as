package asgl.renderers.shaders {
	import asgl.drivers.AbstractRenderDriver;
	import asgl.mesh.TriangleFace;
	
	public interface IShader {
		function complete():void;
		function destroy():void;
		function init(driver:AbstractRenderDriver):void;
		function render(face:TriangleFace):void;
	}
}