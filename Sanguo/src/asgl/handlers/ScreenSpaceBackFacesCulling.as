package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	
	public class ScreenSpaceBackFacesCulling implements IHandler {
		private static const PI:Number = Math.PI;
		public var useParagraphs:Boolean = false;
		public var startIndex:int;
		public var endIndex:int;
		public function ScreenSpaceBackFacesCulling(useParagraphs:Boolean=false, startIndex:int=0, endIndex:int=0):void {
			this.useParagraphs = useParagraphs;
			this.startIndex = startIndex;
			this.endIndex = endIndex;
		}
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			var outFaceList:Vector.<TriangleFace> = new Vector.<TriangleFace>();
			var face:TriangleFace;
			var v0:Vertex3D;
			var v1:Vertex3D;
			var v2:Vertex3D;
			var i:int;
			var total:int;
			var end:int;
			var start:int;
			total = faces.length-1;
			if (total == -1) {
				completeFucntion(faces);
			} else {
				if (useParagraphs) {
					if (startIndex<0) {
						startIndex = 0;
					} else if (startIndex>total) {
						startIndex = total;
					}
					if (endIndex<startIndex) endIndex = startIndex;
					if (endIndex>total) endIndex = total;
					start = startIndex;
					end = endIndex;
					for (i = 0; i<start; i++) {
						outFaceList[i] = faces[i];
					}
				} else {
					start = 0;
					end = total;
				}
				for (i = start; i<=end; i++) {
					face = faces[i];
					v0 = face.vertex0;
					v1 = face.vertex1;
					v2 = face.vertex2;
					if ((v2.screenX-v0.screenX)*(v1.screenY-v0.screenY)>=(v2.screenY-v0.screenY)*(v1.screenX-v0.screenX)) outFaceList.push(face);
				}
				if (useParagraphs) {
					for (i = end+1; i<=total; i++) {
						outFaceList.push(faces[i]);
					}
				}
				completeFucntion(outFaceList);
			}
		}
	}
}