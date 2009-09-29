package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.mesh.TriangleFace;
	import asgl.renderers.shaders.IShader;

	public class ShaderRenderer implements IRenderer {
		public var shaders:Vector.<IShader>;
		public function ShaderRenderer(shaders:Vector.<IShader>=null):void {
			this.shaders = shaders;
		}
		public function get facesType():String {
			return null;
		}
		public function complete():void {
		}
		public function destroy():void {
			shaders = null;
		}
		public function render(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFunction:Function):void {
			var shaderList:Vector.<IShader> = shaders == null ? new Vector.<IShader>() : shaders;
			var totalShaders:int = shaderList.length;
			var totalFaces:int = faces.length;
			for (var i:int = 0; i<totalShaders; i++) {
				shaderList[i].init(driver);
			}
			for (i = 0; i<totalFaces; i++) {
				var face:TriangleFace = faces[i];
				var shader:IShader = face.shader;
				if (shader != null) shader.render(face);
			}
			for (i = 0; i<totalShaders; i++) {
				shaderList[i].complete();
			}
			completeFunction();
		}
	}
}