package asgl.mesh.primitives {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.math.Coordinates3D;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	public class SimpleTorus {
		public static function create(radius1:Number, radius2:Number, segs:int=3, sides:int=3, generateUV:Boolean=true):MeshObject {
			if (segs<3) segs = 3;
			if (sides<3) sides = 3;
			var mo:MeshObject = new MeshObject();
			var vertexArray:Vector.<Vertex3D> = mo.vertices;
			var faceVertexIndexListArray:Vector.<FaceVertexIndex> = mo.faceVertexIndices;
			var uvArray:Vector.<UV>;
			if (generateUV) {
				uvArray = new Vector.<UV>();
				mo.uvs = uvArray;
			}
			var coord1:Coordinates3D = new Coordinates3D();
			var coord2:Coordinates3D = new Coordinates3D();
			var v:Vertex3D = new Vertex3D(radius2);
			coord1.addVertex(v);
			var sidesList:Array = [];
			var unitAngle:Number = 360/sides;
			var tv:Vertex3D = new Vertex3D(radius2);
			sidesList[0] = tv;
			coord2.addVertex(tv, false);
			for (var i:int = 0; i<sides; i++) {
				coord1.localRotationY = unitAngle;
				tv = new Vertex3D(v.worldX, v.worldY, v.worldZ);
				sidesList.push(tv);
				coord2.addVertex(tv, false);
			}
			coord1.removeVertex(v);
			coord1.reset();
			coord1.addChild(coord2, false);
			coord2.autoRefreshEnabled = false;
			coord2.localRotationX = 90;
			coord2.localTranslateX = radius1;
			coord2.autoRefreshEnabled = true;
			coord2.refresh();
			unitAngle = 360/segs;
			var total:int = sidesList.length;
			var index1:int;
			var index2:int;
			var index3:int;
			var index4:int;
			var currentV:Number;
			var t:int = total-1;
			for (i = 0; i<=segs; i++) {
				if (i != 0) coord1.localRotationY = unitAngle;
				if (generateUV) currentV = i/segs;
				for (var j:int = 0; j<total; j++) {
					tv = sidesList[j];
					vertexArray.push(new Vertex3D(tv.worldX, tv.worldY, tv.worldZ));
					if (generateUV) uvArray.push(new UV(j/t, currentV));
				}
				if (i != 0){
					for (j = 0; j<sides; j++) {
						index3 = total*i+j;
						index4 = index3+1;
						index1 = index3-total;
						index2 = index1+1;
						faceVertexIndexListArray.push(new FaceVertexIndex(index1, index3, index4));
						faceVertexIndexListArray.push(new FaceVertexIndex(index1, index4, index2));
					}
				}
			}
			
			
			return mo;
		}
	}
}