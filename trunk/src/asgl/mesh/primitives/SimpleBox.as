package asgl.mesh.primitives {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.math.Coordinates3D;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	public class SimpleBox {
		public static function create(length:Number, width:Number, height:Number, lengthSegs:int=1, widthSegs:int=1, heightSegs:int=1, generateUV:Boolean=true):MeshObject {
			var halfLength:Number = length/2;
			var halfWidth:Number = width/2;
			var halfHegiht:Number = height/2;
			var meshOjbect:MeshObject = new MeshObject();
			var mo:MeshObject = SimplePlane.create(length, width, lengthSegs, widthSegs, generateUV);
			var vertices:Vector.<Vertex3D>;
			var list:Vector.<FaceVertexIndex>;
			vertices = mo.vertices;
			var max:int = vertices.length;
			list = mo.faceVertexIndices;
			var total:int = list.length;
			for (var i:int = 0; i<total; i++) {
				list[i].flip();
			}
			meshOjbect.vertices = meshOjbect.vertices.concat(mo.vertices);
			if (generateUV) {
				meshOjbect.uvs = new Vector.<UV>();
				meshOjbect.uvs = meshOjbect.uvs.concat(mo.uvs);
			}
			meshOjbect.faceVertexIndices = meshOjbect.faceVertexIndices.concat(mo.faceVertexIndices);
			var index:int = max;
			
			mo = SimplePlane.create(length, width, lengthSegs, widthSegs, generateUV);
			vertices = mo.vertices;
			max = vertices.length;
			for (i = 0; i<max; i++) {
				vertices[i].localY += height;
			}
			meshOjbect.vertices = meshOjbect.vertices.concat(mo.vertices);
			if (generateUV) meshOjbect.uvs = meshOjbect.uvs.concat(mo.uvs);
			meshOjbect.faceVertexIndices = meshOjbect.faceVertexIndices.concat(mo.faceVertexIndices);
			list = mo.faceVertexIndices;
			total = list.length;
			var faceVertexIndex:FaceVertexIndex;
			var j:int;
			for (i = 0; i<total; i++) {
				faceVertexIndex = list[i];
				for (j = 0; j<3; j++) {
					faceVertexIndex.setIndex(faceVertexIndex.getIndex(j)+index, j);
				}
			}
			index += max;
			
			mo = SimplePlane.create(length, height, lengthSegs, heightSegs, generateUV);
			var coord:Coordinates3D = new Coordinates3D();
			coord.addVertices(mo.vertices, false);
			coord.autoRefreshEnabled = false;
			coord.localRotationX = -90;
			coord.localTranslateY = halfWidth;
			coord.autoRefreshEnabled = true;
			coord.refresh();
			vertices = mo.vertices;
			max = vertices.length;
			var vertex:Vertex3D;
			for (i = 0; i<max; i++) {
				vertex = vertices[i];
				vertex.localX = vertex.worldX;
				vertex.localY = vertex.worldY+halfHegiht;
				vertex.localZ = vertex.worldZ;
			}
			meshOjbect.vertices = meshOjbect.vertices.concat(mo.vertices);
			if (generateUV) meshOjbect.uvs = meshOjbect.uvs.concat(mo.uvs);
			meshOjbect.faceVertexIndices = meshOjbect.faceVertexIndices.concat(mo.faceVertexIndices);
			list = mo.faceVertexIndices;
			total = list.length;
			for (i = 0; i<total; i++) {
				faceVertexIndex = list[i];
				for (j = 0; j<3; j++) {
					faceVertexIndex.setIndex(faceVertexIndex.getIndex(j)+index, j);
				}
			}
			index += max;
			
			mo = SimplePlane.create(length, height, lengthSegs, heightSegs, generateUV);
			coord.clearVertices();
			coord.reset();
			coord.addVertices(mo.vertices, false);
			coord.autoRefreshEnabled = false;
			coord.localRotationX = -90;
			coord.localRotationZ = 180;
			coord.localTranslateY = halfWidth;
			coord.autoRefreshEnabled = true;
			coord.refresh();
			vertices = mo.vertices;
			max = vertices.length;
			for (i = 0; i<max; i++) {
				vertex = vertices[i];
				vertex.localX = vertex.worldX;
				vertex.localY = vertex.worldY+halfHegiht;
				vertex.localZ = vertex.worldZ;
			}
			meshOjbect.vertices = meshOjbect.vertices.concat(mo.vertices);
			if (generateUV) meshOjbect.uvs = meshOjbect.uvs.concat(mo.uvs);
			meshOjbect.faceVertexIndices = meshOjbect.faceVertexIndices.concat(mo.faceVertexIndices);
			list = mo.faceVertexIndices;
			total = list.length;
			for (i = 0; i<total; i++) {
				faceVertexIndex = list[i];
				for (j = 0; j<3; j++) {
					faceVertexIndex.setIndex(faceVertexIndex.getIndex(j)+index, j);
				}
			}
			index += max;
			
			mo = SimplePlane.create(width, height, widthSegs, heightSegs, generateUV);
			coord.clearVertices();
			coord.reset();
			coord.addVertices(mo.vertices, false);
			coord.autoRefreshEnabled = false;
			coord.localRotationX = -90;
			coord.localRotationZ = 90;
			coord.localTranslateY = halfLength;
			coord.autoRefreshEnabled = true;
			coord.refresh();
			vertices = mo.vertices;
			max = vertices.length;
			for (i = 0; i<max; i++) {
				vertex = vertices[i];
				vertex.localX = vertex.worldX;
				vertex.localY = vertex.worldY+halfHegiht;
				vertex.localZ = vertex.worldZ;
			}
			meshOjbect.vertices = meshOjbect.vertices.concat(mo.vertices);
			if (generateUV) meshOjbect.uvs = meshOjbect.uvs.concat(mo.uvs);
			meshOjbect.faceVertexIndices = meshOjbect.faceVertexIndices.concat(mo.faceVertexIndices);
			list = mo.faceVertexIndices;
			total = list.length;
			for (i = 0; i<total; i++) {
				faceVertexIndex = list[i];
				for (j = 0; j<3; j++) {
					faceVertexIndex.setIndex(faceVertexIndex.getIndex(j)+index, j);
				}
			}
			index += max;
			
			mo = SimplePlane.create(width, height, widthSegs, heightSegs, generateUV);
			coord.clearVertices();
			coord.reset();
			coord.addVertices(mo.vertices, false);
			coord.autoRefreshEnabled = false;
			coord.localRotationX = -90;
			coord.localRotationZ = -90;
			coord.localTranslateY = halfLength;
			coord.autoRefreshEnabled = true;
			coord.refresh();
			vertices = mo.vertices;
			max = vertices.length;
			for (i = 0; i<max; i++) {
				vertex = vertices[i];
				vertex.localX = vertex.worldX;
				vertex.localY = vertex.worldY+halfHegiht;
				vertex.localZ = vertex.worldZ;
			}
			meshOjbect.vertices = meshOjbect.vertices.concat(mo.vertices);
			if (generateUV) meshOjbect.uvs = meshOjbect.uvs.concat(mo.uvs);
			meshOjbect.faceVertexIndices = meshOjbect.faceVertexIndices.concat(mo.faceVertexIndices);
			list = mo.faceVertexIndices;
			total = list.length;
			for (i = 0; i<total; i++) {
				faceVertexIndex = list[i];
				for (j = 0; j<3; j++) {
					faceVertexIndex.setIndex(faceVertexIndex.getIndex(j)+index, j);
				}
			}
			
			return meshOjbect;
		}
	}
}