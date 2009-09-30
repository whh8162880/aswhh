package asgl.animation {
	import __AS3__.vec.Vector;
	
	import asgl.mesh.MeshObject;
	public class KeyFrame {
		public var name:String;
		public var meshObjects:Vector.<MeshObject> = new Vector.<MeshObject>();
		public function KeyFrame(name:String=null):void {
			this.name = name;
		}
	}
}