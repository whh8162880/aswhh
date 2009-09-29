package asgl.mesh.primitives {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	public class SimplePlane {
		public static function create(length:Number, width:Number, lengthSegs:int=1, widthSegs:int=1, generateUV:Boolean=true):MeshObject {
			if (length<0) length = 0;
			if (width<0) width = 0;
			if (lengthSegs<1) lengthSegs = 1;
			if (widthSegs<1) widthSegs = 1;
			lengthSegs;
			widthSegs;
			var unitLength:Number = length/widthSegs;
			var unitWidth:Number = width/lengthSegs;
			length /= 2;
			width /= 2;
			var meshOjbect:MeshObject = new MeshObject();
			var vertexListArray:Vector.<Vertex3D> = meshOjbect.vertices;
			var uvListArray:Vector.<UV>;
			if (generateUV) {
				uvListArray = new Vector.<UV>();
				meshOjbect.uvs = uvListArray;
			}
			var vertexMap:Object = {};
			var tv:Number;
			for (var l:int = 0; l<=lengthSegs; l++) {
				var z:Number = width-l*unitWidth;
				if (generateUV) tv = 1-(z+width)/(2*width);
				var head:String = l.toString()+'_';
				for (var w:int = 0; w<=widthSegs; w++) {
					var vertex:Vertex3D = new Vertex3D(w*unitLength-length, 0, z)
					vertexListArray.push(vertex);
					vertexMap[head+w.toString()] = vertex;
					if (generateUV) uvListArray.push(new UV((vertex.localX+length)/(2*length), tv));
				}
			}
			var faceVertexIndexListArray:Vector.<FaceVertexIndex> = meshOjbect.faceVertexIndices;
			var max:int = lengthSegs*widthSegs;
			for (var i:int = 0; i<max; i++) {
				var h:int = Math.floor(i/widthSegs);
				var v:int = i%widthSegs;
				var h0:String = h.toString()+'_';
				var h1:String = (h+1).toString()+'_';
				var v0:String = v.toString();
				var v1:String = (v+1).toString();
				var index1:int = vertexListArray.indexOf(vertexMap[h0+v0]);
				var index2:int = vertexListArray.indexOf(vertexMap[h0+v1]);
				var index3:int = vertexListArray.indexOf(vertexMap[h1+v0]);
				var index4:int = vertexListArray.indexOf(vertexMap[h1+v1]);
				faceVertexIndexListArray.push(new FaceVertexIndex(index1, index2, index3), new FaceVertexIndex(index2, index4, index3));
			}
			return meshOjbect;
		}
	}
}