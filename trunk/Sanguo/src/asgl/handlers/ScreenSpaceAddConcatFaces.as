package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	
	import flash.geom.Vector3D;
	
	public class ScreenSpaceAddConcatFaces implements IHandler {
		/**
		 * if the value is true, need faces normalizeNormal.
		 */
		public var ruleOutSameNormalFaces:Boolean;
		public function ScreenSpaceAddConcatFaces(ruleOutSameNormalFaces:Boolean=false):void {
			this.ruleOutSameNormalFaces = ruleOutSameNormalFaces;
		}
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			var length:int = faces.length;
			var map:Object = {};
			var face:TriangleFace;
			for (var i:int = 0; i<length; i++) {
				face = faces[i];
				if (face.concatFaces == null || face.concatFaces.length>0) face.concatFaces = new Vector.<TriangleFace>();
				var v1:Vertex3D = face.vertex0;
				var v2:Vertex3D = face.vertex1;
				var v3:Vertex3D = face.vertex2;
				var key1:int = int(v1.screenX*100000)*100+int(v1.screenY*100000)*10+int(v1.screenZ*100000);
				var key2:int = int(v2.screenX*100000)*100+int(v2.screenY*100000)*10+int(v2.screenZ*100000);
				var key3:int = int(v3.screenX*100000)*100+int(v3.screenY*100000)*10+int(v3.screenZ*100000);
				if (map[key1] == null) {
					map[key1] = [face];
				} else {
					map[key1].push(face);
				}
				if (map[key2] == null) {
					map[key2] = [face];
				} else {
					map[key2].push(face);
				}
				if (map[key3] == null) {
					map[key3] = [face];
				} else {
					map[key3].push(face);
				}
			}
			var j:int;
			var compareFace:TriangleFace;
			for each (var arr:Array in map) {
				length = arr.length;
				for (i = 0; i<length; i++) {
					face = arr[i];
					var faceArr:Vector.<TriangleFace> = face.concatFaces;
					for (j = 0; j<length; j++) {
						compareFace = arr[j];
						if (faceArr.indexOf(compareFace) == -1) faceArr.push(compareFace);
					}
					for (j = 0; j<length; j++) {
						compareFace = arr[j];
						if (faceArr.indexOf(compareFace) == -1) faceArr.push(compareFace);
					}
				}
			}
			if (ruleOutSameNormalFaces) {
				length = faces.length;
				var total:int;
				for (i = 0; i<length; i++) {
					face = faces[i];
					var concat:Vector.<TriangleFace> = face.concatFaces;
					if (concat == null || (total = concat.length) == 0) continue;
					var normal:Vector3D = face.vector;
					var nx:Number = normal.x;
					var ny:Number = normal.y;
					var nz:Number = normal.z;
					loop : for (j = 0; j<total; j++) {
						normal = concat[j].vector;
						var nx1:Number = normal.x;
						var ny1:Number = normal.y;
						var nz1:Number = normal.z;
						if (nx == nx1 && ny == ny1 && nz == nz1) {
							concat.splice(j, 1);
							total--;
							j--;
							continue;
						}
						for (var k:int = 0; k<j; k++) {
							normal = concat[k].vector;
							if (nx1 == normal.x && ny1 == normal.y && nz1 == normal.z) {
								concat.splice(j, 1);
								total--;
								j--;
								continue loop;
							}
						}
						for (k = j+1; k<total; k++) {
							normal = concat[k].vector;
							if (nx1 == normal.x && ny1 == normal.y && nz1 == normal.z) {
								concat.splice(j, 1);
								total--;
								j--;
								continue loop;
							}
						}
					}
				}
			}
			completeFucntion(faces);
		}
	}
}