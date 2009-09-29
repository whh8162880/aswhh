package asgl.mesh.primitives {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	public class SimplePyramid {
		public static function create(width:Number, depth:Number, height:Number, widthSegs:int=1, depthSegs:int=1, heightSegs:int=1, generateUV:Boolean=true):MeshObject {
			var meshObject:MeshObject = new MeshObject();
			if (widthSegs<1) widthSegs = 1;
			if (depthSegs<1) depthSegs = 1;
			if (heightSegs<1) heightSegs = 1;
			var halfWidth:Number = width/2;
			var halfDepth:Number = depth/2;
			var vertexArray:Vector.<Vertex3D> = meshObject.vertices;
			vertexArray[0] = new Vertex3D();
			vertexArray[1] = new Vertex3D(-halfWidth, 0, -halfDepth);
			var uvArray:Vector.<UV>;
			if (generateUV) {
				meshObject.uvs = new Vector.<UV>();
				uvArray = meshObject.uvs;
				uvArray[0] = new UV(0.5, 0.5);
				uvArray[1] = new UV();
			}
			for (var i:int = 1; i<widthSegs; i++) {
				vertexArray.push(new Vertex3D(width*i/widthSegs-halfWidth, 0, -halfDepth));
				if (generateUV) uvArray.push(new UV(i/widthSegs));
			}
			vertexArray.push(new Vertex3D(halfWidth, 0, -halfDepth));
			if (generateUV) uvArray.push(new UV(1));
			var faceVertexIndexArray:Vector.<FaceVertexIndex> = meshObject.faceVertexIndices;
			for (i = 1; i<=widthSegs; i++) {
				faceVertexIndexArray[i-1] = new FaceVertexIndex(0, i, i+1);
			}
			var index:int = vertexArray.length-1;
			vertexArray.push(new Vertex3D(-halfWidth, 0, halfDepth));
			if (generateUV) uvArray.push(new UV(0, 1));
			for (i = 1; i<widthSegs; i++) {
				vertexArray.push(new Vertex3D(width*i/widthSegs-halfWidth, 0, halfDepth));
				if (generateUV) uvArray.push(new UV(i/widthSegs, 1));
			}
			vertexArray.push(new Vertex3D(halfWidth, 0, halfDepth));
			if (generateUV) uvArray.push(new UV(1, 1));
			for (i = 1; i<=widthSegs; i++) {
				faceVertexIndexArray.push(new FaceVertexIndex(0, index+i+1, index+i));
			}
			index = vertexArray.length-1;
			vertexArray.push(new Vertex3D(-halfWidth, 0, -halfDepth));
			if (generateUV) uvArray.push(new UV());
			for (i = 1; i<depthSegs; i++) {
				vertexArray.push(new Vertex3D(-halfWidth, 0, depth*i/depthSegs-halfDepth));
				if (generateUV) uvArray.push(new UV(0, i/depthSegs));
			}
			vertexArray.push(new Vertex3D(-halfWidth, 0, halfDepth));
			if (generateUV) uvArray.push(new UV(0, 1));
			for (i = 1; i<=depthSegs; i++) {
				faceVertexIndexArray.push(new FaceVertexIndex(0, index+i+1, index+i));
			}
			index = vertexArray.length-1;
			vertexArray.push(new Vertex3D(halfWidth, 0, -halfDepth));
			if (generateUV) uvArray.push(new UV(1, 0));
			for (i = 1; i<depthSegs; i++) {
				vertexArray.push(new Vertex3D(halfWidth, 0, depth*i/depthSegs-halfDepth));
				if (generateUV) uvArray.push(new UV(1, i/depthSegs));
			}
			vertexArray.push(new Vertex3D(halfWidth, 0, halfDepth));
			if (generateUV) uvArray.push(new UV(1, 1));
			for (i = 1; i<=depthSegs; i++) {
				faceVertexIndexArray.push(new FaceVertexIndex(0, index+i, index+i+1));
			}
			vertexArray.push(new Vertex3D(0, height));
			if (generateUV) uvArray.push(new UV(0.5));
			index = vertexArray.length-1;
			var start:int;
			var k:Number;
			var x:Number;
			var y:Number;
			var z:Number;
			var j:int;
			var index1:int;
			var index2:int;
			var index3:int;
			var index4:int;
			var v:Number;
			for (var m:int = 0; m<2; m++) {
				start = vertexArray.length-1;
				for (i = 1; i<=heightSegs; i++) {
					k = i/heightSegs;
					x = halfWidth*k;
					var x2:Number = x*2;
					y = height*(1-k);
					z = halfDepth*k*(m == 0 ? -1 : 1);
					vertexArray.push(new Vertex3D(-x, y, z));
					if (generateUV) {
						v = k;
						uvArray.push(new UV(0.5*(1+k*(m == 0 ? -1 : 1)), v));
					}
					for (j = 1; j<widthSegs; j++) {
						var tx:Number = x2*j/widthSegs-x;
						vertexArray.push(new Vertex3D(tx, y, z));
						if (generateUV) {
							if (tx<0) tx = -tx;
							uvArray.push(new UV(0.5*(1+(m == 0 ? -1 : 1)*tx/halfWidth), v));
						}
					}
					vertexArray.push(new Vertex3D(x, y, z));
					if (generateUV) uvArray.push(new UV(0.5*(1+k*(m == 0 ? 1 : -1)), v));
					if (i == 1) {
						for (j = 1; j<=widthSegs; j++) {
							if (m == 0) {
								faceVertexIndexArray.push(new FaceVertexIndex(index, start+j+1, start+j));
							} else {
								faceVertexIndexArray.push(new FaceVertexIndex(index, start+j, start+j+1));
							}
						}
					} else {
						for (j = 0; j<widthSegs; j++) {
							index3 = vertexArray.length-1-widthSegs+j;
							index1 = index3-1-widthSegs;
							index2 = index1+1;
							index4 = index3+1;
							if (m == 0) {
								faceVertexIndexArray.push(new FaceVertexIndex(index1, index2, index3), new FaceVertexIndex(index2, index4, index3));
							} else {
								faceVertexIndexArray.push(new FaceVertexIndex(index1, index3, index2), new FaceVertexIndex(index2, index3, index4));
							}
						}
					}
				}
			}
			for (m = 0; m<2; m++) {
				start = vertexArray.length-1;
				for (i = 1; i<=heightSegs; i++) {
					k = i/heightSegs;
					x = halfWidth*k*(m == 0 ? -1 : 1);
					y = height*(1-k);
					z = halfDepth*k;
					var z2:Number = z*2;
					vertexArray.push(new Vertex3D(x, y, -z));
					if (generateUV) {
						v = k;
						uvArray.push(new UV(0.5*(1+k*(m == 0 ? 1 : -1)), v));
					}
					for (j = 1; j<depthSegs; j++) {
						var tz:Number = z2*j/depthSegs-z;
						vertexArray.push(new Vertex3D(x, y, tz));
						if (generateUV) {
							if (tz<0) tz = -tz;
							uvArray.push(new UV(0.5*(1+(m == 0 ? 1 : -1)*tz/halfDepth), v));
						}
					}
					vertexArray.push(new Vertex3D(x, y, z));
					if (generateUV) uvArray.push(new UV(0.5*(1+k*(m == 0 ? -1 : 1)), v));
					if (i == 1) {
						for (j = 1; j<=depthSegs; j++) {
							if (m == 0) {
								faceVertexIndexArray.push(new FaceVertexIndex(index, start+j, start+j+1));
							} else {
								faceVertexIndexArray.push(new FaceVertexIndex(index, start+j+1, start+j));
							}
						}
					} else {
						for (j = 0; j<depthSegs; j++) {
							index3 = vertexArray.length-1-depthSegs+j;
							index1 = index3-1-depthSegs;
							index2 = index1+1;
							index4 = index3+1;
							if (m == 0) {
								faceVertexIndexArray.push(new FaceVertexIndex(index1, index3, index2), new FaceVertexIndex(index2, index3, index4));
							} else {
								faceVertexIndexArray.push(new FaceVertexIndex(index1, index2, index3), new FaceVertexIndex(index2, index4, index3));
							}
						}
					}
				}
			}
			
			return meshObject;
		}
	}
}