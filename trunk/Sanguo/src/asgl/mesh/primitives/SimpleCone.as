package asgl.mesh.primitives {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.math.Coordinates3D;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	public class SimpleCone {
		public static function create(radius1:Number, radius2:Number, height:Number, heightSegs:int=1, capSegs:int=1, sides:int=3, generateUV:Boolean=true):MeshObject {
			if (heightSegs<1) heightSegs = 1;
			if (capSegs<1) capSegs = 1;
			if (sides<3) sides = 3;
			var mo:MeshObject = new MeshObject();
			var vertexArray:Vector.<Vertex3D> = mo.vertices;
			var faceVertexIndexListArray:Vector.<FaceVertexIndex> = mo.faceVertexIndices;
			var uvArray:Vector.<UV>;
			if (generateUV) {
				uvArray = new Vector.<UV>();
				mo.uvs = uvArray;
			}
			var coord:Coordinates3D = new Coordinates3D();
			var v:Vertex3D = new Vertex3D(radius2);
			var v2:Vertex3D = new Vertex3D(0.5);
			coord.addVertex(v);
			vertexArray[0] = new Vertex3D(0, height);
			if (generateUV) {
				uvArray[0] = new UV(0.5, 0.5);
				coord.addVertex(v2);
			}
			var unitAngle:Number = 360/sides;
			var unitRadius:Number = radius2/capSegs;
			var unitUV:Number = 1/capSegs;
			var d:int = sides+1;
			var j:int;
			var index:int;
			var index1:int;
			var index2:int;
			var index3:int;
			var index4:int;
			for (var i:int = 0; i<capSegs; i++) {
				if (i != 0) {
					v.localX -= unitRadius;
					if (generateUV) v2.localX -= unitUV;
				}
				coord.reset();
				vertexArray.push(new Vertex3D(v.worldX, height, v.worldZ));
				if (generateUV) uvArray.push(new UV(0.5+v2.worldX, 0.5-v2.worldZ));
				for (j = 0; j<sides; j++) {
					coord.localRotationY = unitAngle;
					vertexArray.push(new Vertex3D(v.worldX, height, v.worldZ));
					if (generateUV) uvArray.push(new UV(0.5+v2.worldX, 0.5-v2.worldZ));
				}
				if (i != 0) {
					for (j = 0; j<sides; j++) {
						index3 = d*i+1+j;
						index4 = index3+1;
						index1 = index3-d;
						index2 = index1+1;
						faceVertexIndexListArray.push(new FaceVertexIndex(index1, index2, index3));
						faceVertexIndexListArray.push(new FaceVertexIndex(index3, index2, index4));
					}
				}
				if (i == capSegs-1) {
					for (j = 0; j<sides; j++) {
						index1 = d*i+1+j;
						index2 = index1+1;
						faceVertexIndexListArray.push(new FaceVertexIndex(index1, index2, 0));
					}
				}
			}
			
			index = vertexArray.length;
			vertexArray.push(new Vertex3D());
			if (generateUV) uvArray.push(new UV(0.5, 0.5));
			v.localX = radius1;
			v2.localX = 0.5;
			unitRadius = radius1/capSegs;
			for (i = 0; i<capSegs; i++) {
				if (i != 0) {
					v.localX -= unitRadius;
					if (generateUV) v2.localX -= unitUV;
				}
				coord.reset();
				vertexArray.push(new Vertex3D(v.worldX, 0, v.worldZ));
				if (generateUV) uvArray.push(new UV(0.5+v2.worldX, 0.5-v2.worldZ));
				for (j = 0; j<sides; j++) {
					coord.localRotationY = unitAngle;
					vertexArray.push(new Vertex3D(v.worldX, 0, v.worldZ));
					if (generateUV) uvArray.push(new UV(0.5+v2.worldX, 0.5-v2.worldZ));
				}
				if (i != 0) {
					for (j = 0; j<sides; j++) {
						index3 = d*i+1+j+index;
						index4 = index3+1;
						index1 = index3-d;
						index2 = index1+1;
						faceVertexIndexListArray.push(new FaceVertexIndex(index2, index1, index3));
						faceVertexIndexListArray.push(new FaceVertexIndex(index2, index3, index4));
					}
				}
				if (i == capSegs-1) {
					for (j = 0; j<sides; j++) {
						index1 = d*i+1+j+index;
						index2 = index1+1;
						faceVertexIndexListArray.push(new FaceVertexIndex(index2, index1, index));
					}
				}
			}
			
			coord.removeVertex(v2);
			var unitH:Number = height/heightSegs;
			var h:Number = height;
			v.localX = radius2;
			var unitR:Number = (radius1-radius2)/heightSegs;
			index = vertexArray.length;
			var currentV:Number;
			for (i = 0; i<=heightSegs; i++) {
				if (i != 0) {
					h -= unitH;
					v.localX += unitR;
				}
				coord.reset();
				if (generateUV) currentV = i/heightSegs;
				for (j = 0; j<=sides; j++) {
					if (j != 0) coord.localRotationY = unitAngle;
					vertexArray.push(new Vertex3D(v.worldX, h, v.worldZ));
					if (generateUV) uvArray.push(new UV(j/sides, currentV));
				}
				if (i != 0) {
					for (j = 0; j<sides; j++) {
						index3 = i*d+index+j;
						index4 = index3+1;
						index1 = index3-d;
						index2 = index1+1;
						faceVertexIndexListArray.push(new FaceVertexIndex(index1, index4, index2));
						faceVertexIndexListArray.push(new FaceVertexIndex(index1, index3, index4));
					}
				}
			}
			
			return mo;
		}
	}
}