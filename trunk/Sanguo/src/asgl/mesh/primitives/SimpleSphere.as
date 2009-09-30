package asgl.mesh.primitives {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.math.Coordinates3D;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	public class SimpleSphere {
		public static function create(radius:Number, segments:int=4, generateUV:Boolean=true):MeshObject {
			var meshObject:MeshObject = new MeshObject();
			if (radius<0) radius = 0;
			if (segments<4) segments = 4;
			var numV:int = int((segments-4)/2)+1;
			var d:Number = radius*2;
			var coordX:Coordinates3D = new Coordinates3D();
			var coordY:Coordinates3D = new Coordinates3D();
			coordY.addChild(coordX, false);
			var v:Vertex3D = new Vertex3D();
			coordX.addVertex(v, false);
			var angleX:Number = 180/(numV+1);
			var angleY:Number = 360/segments;
			var vertexArray:Vector.<Vertex3D> = meshObject.vertices;
			var uvArray:Vector.<UV>;
			var max:int;
			if (generateUV) {
				meshObject.uvs = new Vector.<UV>();
				uvArray = meshObject.uvs;
				uvArray[0] = new UV(0.5);
				max = numV+1;
			}
			vertexArray.push(new Vertex3D(0, radius));
			var j:int;
			var currentV:Number;
			for (var i:int = 1; i<=numV; i++) {
				v.localY = radius;
				coordX.autoRefreshEnabled = false;
				coordX.localRotationX = angleX;
				coordX.autoRefreshEnabled = true;
				coordY.reset();
				if (generateUV) currentV = i/max;
				for (j = 0; j<=segments; j++) {
					if (j == segments) {
						coordY.autoRefreshEnabled = false;
						coordY.reset();
						coordY.autoRefreshEnabled = true;
					}
					coordY.localRotationY = angleY;
					vertexArray.push(new Vertex3D(v.worldX, v.worldY, v.worldZ));
					if (generateUV) uvArray.push(new UV(j/segments, currentV));
				}
			}
			vertexArray.push(new Vertex3D(0, -radius));
			if (generateUV) uvArray.push(new UV(0.5, 1));
			
			var faceVertexIndexArray:Vector.<FaceVertexIndex> = meshObject.faceVertexIndices;
			for (i = 1; i<=segments; i++) {
				faceVertexIndexArray.push(new FaceVertexIndex(0, i, i+1));
			}
			numV--;
			for (i = 0; i<numV; i++) {
				var h1:int = 1+i*(segments+1);
				var h2:int = h1+segments+1;
				for (j = 0; j<segments; j++) {
					var index1:int = h1+j;
					var index2:int = h2+j;
					var index3:int = index1+1;
					var index4:int = index2+1;
					faceVertexIndexArray.push(new FaceVertexIndex(index3, index1, index4));
					faceVertexIndexArray.push(new FaceVertexIndex(index1, index2, index4));
				}
			}
			var last:int = vertexArray.length-1;
			var index:int = last-segments-2;
			for (i = 1; i<=segments; i++) {
				j = index+i;
				faceVertexIndexArray.push(new FaceVertexIndex(last, j+1, j));
			}
			
			return meshObject;
		}
	}
}