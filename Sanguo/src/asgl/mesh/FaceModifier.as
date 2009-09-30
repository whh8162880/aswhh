package asgl.mesh {
	import __AS3__.vec.Vector;
	
	import asgl.handlers.ScreenSpaceBackFacesCulling;
	import asgl.math.BoundBox;
	import asgl.math.BoundSphere;
	import asgl.math.Color;
	import asgl.math.SpaceType;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.utils.VectorUtil;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class FaceModifier {
		private static const POSITIVE_INFINITY:Number = Number.POSITIVE_INFINITY;
		private static const NEGATIVE_INFINITY:Number = Number.NEGATIVE_INFINITY;
		public var faces:Vector.<TriangleFace>;
		public function FaceModifier(faces:Vector.<TriangleFace>=null):void {
			this.faces = faces;
		}
		public function set facesColor(value:uint):void {
			if (faces == null) return;
			for (var i:int = faces.length-1; i>=0; i--) {
				faces[i].color = value;
			}
		}
		/**
		 * need faces screen coord.
		 */
		public function get screenSpaceForeFaces():Vector.<TriangleFace> {
			if (faces == null) return new Vector.<TriangleFace>();
			var out:Vector.<TriangleFace>;
			new ScreenSpaceBackFacesCulling().handle(null, faces, function (faces:Vector.<TriangleFace>):void {
				out = faces;
			});
			return out;
		}
		public function get totalFaces():int {
			if (faces == null) return 0;
			return faces.length;
		}
		/**
		 * faces are materialFaces.
		 */
		public function get uvs():Vector.<UV> {
			var list:Vector.<UV> = new Vector.<UV>();
			if (faces == null) return list;
			var length:int = faces.length;
			var map:Dictionary = new Dictionary();
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				if (face.isMaterialFace) {
					if (map[face.uv0] == null) map[face.uv0] = 1;
					if (map[face.uv1] == null) map[face.uv1] = 1;
					if (map[face.uv2] == null) map[face.uv2] = 1;
				}
			}
			for (var key:* in map) {
				list.push(key);
			}
			return list;
		}
		public function get vectors():Vector.<Vector3D> {
			var list:Vector.<Vector3D> = new Vector.<Vector3D>();
			if (faces == null) return list;
			var length:uint = faces.length;
			var v:Vector3D;
			for (var i:uint = 0; i<length; i++) {
				v = faces[i].vector;
				if (v != null && list.indexOf(v) == -1) list.push(v);
			}
			return list;
		}
		public function get vertices():Vector.<Vertex3D> {
			var list:Vector.<Vertex3D> = new Vector.<Vertex3D>();
			if (faces == null) return list;
			var length:int = faces.length;
			var map:Dictionary = new Dictionary();
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				if (map[face.vertex0] == null) map[face.vertex0] = 1;
				if (map[face.vertex1] == null) map[face.vertex1] = 1;
				if (map[face.vertex2] == null) map[face.vertex2] = 1;
			}
			for (var key:* in map) {
				list.push(key);
			}
			return list;
		}
		public function computeNormal(spaceType:String, normalizeEnabled:Boolean=false):void {
			if (faces == null) return;
			var length:int = faces.length;
			var i:int;
			var face:TriangleFace;
			var v0:Vertex3D;
			var v1:Vertex3D;
			var v2:Vertex3D;
			var v0X:Number;
			var v0Y:Number;
			var v0Z:Number;
			var abX:Number;
			var abY:Number;
			var abZ:Number;
			var acX:Number;
			var acY:Number;
			var acZ:Number;
			var vector:Vector3D;
			if (spaceType == SpaceType.LOCAL_SPACE) {
				if (normalizeEnabled) {
					for (i = 0; i<length; i++) {
						face = faces[i];
						v0 = face.vertex0;
						v1 = face.vertex1;
						v2 = face.vertex2;
						v0X = v0.localX;
						v0Y = v0.localY;
						v0Z = v0.localZ;
						abX = v1.localX-v0X;
						abY = v1.localY-v0Y;
						abZ = v1.localZ-v0Z;
						acX = v2.localX-v0X;
						acY = v2.localY-v0Y;
						acZ = v2.localZ-v0Z;
						vector = face.vector;
						vector.x = abY*acZ-abZ*acY;
						vector.y = abZ*acX-abX*acZ;
						vector.z = abX*acY-abY*acX;
						vector.normalize();
					}
				} else {
					for (i = 0; i<length; i++) {
						face = faces[i];
						v0 = face.vertex0;
						v1 = face.vertex1;
						v2 = face.vertex2;
						v0X = v0.localX;
						v0Y = v0.localY;
						v0Z = v0.localZ;
						abX = v1.localX-v0X;
						abY = v1.localY-v0Y;
						abZ = v1.localZ-v0Z;
						acX = v2.localX-v0X;
						acY = v2.localY-v0Y;
						acZ = v2.localZ-v0Z;
						vector = face.vector;
						vector.x = abY*acZ-abZ*acY;
						vector.y = abZ*acX-abX*acZ;
						vector.z = abX*acY-abY*acX;
					}
				}
			} else if (spaceType == SpaceType.WORLD_SPACE) {
				if (normalizeEnabled) {
					for (i = 0; i<length; i++) {
						face = faces[i];
						v0 = face.vertex0;
						v1 = face.vertex1;
						v2 = face.vertex2;
						v0X = v0.worldX;
						v0Y = v0.worldY;
						v0Z = v0.worldZ;
						abX = v1.worldX-v0X;
						abY = v1.worldY-v0Y;
						abZ = v1.worldZ-v0Z;
						acX = v2.worldX-v0X;
						acY = v2.worldY-v0Y;
						acZ = v2.worldZ-v0Z;
						vector = face.vector;
						vector.x = abY*acZ-abZ*acY;
						vector.y = abZ*acX-abX*acZ;
						vector.z = abX*acY-abY*acX;
						vector.normalize();
					}
				} else {
					for (i = 0; i<length; i++) {
						face = faces[i];
						v0 = face.vertex0;
						v1 = face.vertex1;
						v2 = face.vertex2;
						v0X = v0.worldX;
						v0Y = v0.worldY;
						v0Z = v0.worldZ;
						abX = v1.worldX-v0X;
						abY = v1.worldY-v0Y;
						abZ = v1.worldZ-v0Z;
						acX = v2.worldX-v0X;
						acY = v2.worldY-v0Y;
						acZ = v2.worldZ-v0Z;
						vector = face.vector;
						vector.x = abY*acZ-abZ*acY;
						vector.y = abZ*acX-abX*acZ;
						vector.z = abX*acY-abY*acX;
					}
				}
			} else if (spaceType == SpaceType.SCREEN_SPACE) {
				if (normalizeEnabled) {
					for (i = 0; i<length; i++) {
						face = faces[i];
						v0 = face.vertex0;
						v1 = face.vertex1;
						v2 = face.vertex2;
						v0X = v0.screenX;
						v0Y = v0.screenY;
						v0Z = v0.screenZ;
						abX = v1.screenX-v0X;
						abY = v1.screenY-v0Y;
						abZ = v1.screenZ-v0Z;
						acX = v2.screenX-v0X;
						acY = v2.screenY-v0Y;
						acZ = v2.screenZ-v0Z;
						vector = face.vector;
						vector.x = abY*acZ-abZ*acY;
						vector.y = abZ*acX-abX*acZ;
						vector.z = abX*acY-abY*acX;
						vector.normalize();
					}
				} else {
					for (i = 0; i<length; i++) {
						face = faces[i];
						v0 = face.vertex0;
						v1 = face.vertex1;
						v2 = face.vertex2;
						v0X = v0.screenX;
						v0Y = v0.screenY;
						v0Z = v0.screenZ;
						abX = v1.screenX-v0X;
						abY = v1.screenY-v0Y;
						abZ = v1.screenZ-v0Z;
						acX = v2.screenX-v0X;
						acY = v2.screenY-v0Y;
						acZ = v2.screenZ-v0Z;
						vector = face.vector;
						vector.x = abY*acZ-abZ*acY;
						vector.y = abZ*acX-abX*acZ;
						vector.z = abX*acY-abY*acX;
					}
				}
			}
		}
		public function flip():void {
			if (faces == null) return;
			var length:int = faces.length;
			for (var i:int = 0; i<length; i++) {
				faces[i].flip();
			}
		}
		public function getBoundBox(spaceType:String, boundBox:BoundBox=null):BoundBox {
			var bound:BoundBox = boundBox == null ? new BoundBox() : boundBox;
			bound.reset();
			if (faces == null || faces.length == 0) return bound;
			var x:Number;
			var y:Number;
			var z:Number;
			var minX:Number = POSITIVE_INFINITY;
			var maxX:Number = NEGATIVE_INFINITY;
			var minY:Number = POSITIVE_INFINITY;
			var maxY:Number = NEGATIVE_INFINITY;
			var minZ:Number = POSITIVE_INFINITY;
			var maxZ:Number = NEGATIVE_INFINITY;
			var i:int;
			var v:Vertex3D;
			var face:TriangleFace;
			if (spaceType == SpaceType.LOCAL_SPACE) {
				for (i = faces.length-1; i>=0; i--) {
					face = faces[i];
					v = face.vertex0;
					x = v.localX;
					y = v.localY;
					z = v.localZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
					v = face.vertex1;
					x = v.localX;
					y = v.localY;
					z = v.localZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
					v = face.vertex2;
					x = v.localX;
					y = v.localY;
					z = v.localZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
				}
			} else if (spaceType == SpaceType.WORLD_SPACE) {
				for (i = faces.length-1; i>=0; i--) {
					face = faces[i];
					v = face.vertex0;
					x = v.worldX;
					y = v.worldY;
					z = v.worldZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
					v = face.vertex1;
					x = v.worldX;
					y = v.worldY;
					z = v.worldZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
					v = face.vertex2;
					x = v.worldX;
					y = v.worldY;
					z = v.worldZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
				}
			} else if (spaceType == SpaceType.SCREEN_SPACE) {
				for (i = faces.length-1; i>=0; i--) {
					face = faces[i];
					v = face.vertex0;
					x = v.screenX;
					y = v.screenY;
					z = v.screenZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
					v = face.vertex1;
					x = v.screenX;
					y = v.screenY;
					z = v.screenZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
					v = face.vertex2;
					x = v.screenX;
					y = v.screenY;
					z = v.screenZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
				}
			} else {
				return bound;
			}
			bound.minX = minX;
			bound.maxX = maxX;
			bound.minY = minY;
			bound.maxY = maxY;
			bound.minZ = minZ;
			bound.maxZ = maxZ;
			return bound;
		}
		public function getBoundSphere(spaceType:String, boundSphere:BoundSphere=null):BoundSphere {
			var bs:BoundSphere = boundSphere == null ? new BoundSphere() : boundSphere;
			bs.setValueFromBoundBox(getBoundBox(spaceType));
			return bs;
		}
		public function localSpaceAddConcatFaces():void {
			if (faces == null) return;
			var length:int = faces.length;
			var map:Object = {};
			var face:TriangleFace;
			for (var i:int = 0; i<length; i++) {
				face = faces[i];
				if (face.concatFaces == null || face.concatFaces.length>0) face.concatFaces = new Vector.<TriangleFace>();
				face.concatFaces.push(face);
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
			for each (var arr:Array in map) {
				length = arr.length;
				for (i = 0; i<length; i++) {
					face = arr[i];
					var faceArr:Vector.<TriangleFace> = face.concatFaces;
					for (var j:int = 0; j<length; j++) {
						var compareFace:TriangleFace = arr[j];
						if (faceArr.indexOf(compareFace) == -1) faceArr.push(compareFace);
					}
				}
			}
		}
		public function randomFacesColor(randomAlpha:Boolean=true):void {
			if (faces == null) return;
			for (var i:int = faces.length-1; i>=0; i--) {
				faces[i].color = Color.randomColor(randomAlpha);
			}
		}
		public function setFacesProperty(propertyName:String, value:Object):void {
			if (faces == null) return;
			var length:int = faces.length;
			for (var i:int = 0; i<length; i++) {
				try {
					faces[i][propertyName] = value;
				} catch (e:Error) {}
			}
		}
		/**
		 * need localSpace concatFaces and localSpaceNormal of faces.
		 */
		public function setScaleFromLocalSpaceNormal(scale:Number):void {
			if (faces == null) return;
			var totalFace:int = faces.length;
			var face:TriangleFace;
			var i:int;
			var j:int;
			var v1:Vertex3D;
			var v2:Vertex3D;
			var v3:Vertex3D;
			var table:Object;
			var dict:Dictionary = new Dictionary();
			var vertexArray:Array;
			var concatFaces:Vector.<TriangleFace>;
			var concatFaceNormal:Vector3D;
			var vectorX:Number;
			var vectorY:Number;
			var vectorZ:Number;
			var key:int;
			for (i = 0; i<totalFace; i++) {
				face = faces[i];
				var v:Vertex3D;
				for (j = 0; j<3; j++) {
					if (j == 0) {
						v = face.vertex0;
					} else if (j == 1) {
						v = face.vertex1;
					} else {
						v = face.vertex2;
					}
					if (dict[v] == null) {
						dict[v] = true;
						concatFaces = face.concatFaces;
						if (concatFaces == null) {
							concatFaceNormal = face.vector;
							vectorX = concatFaceNormal.x;
							vectorY = concatFaceNormal.y;
							vectorZ = concatFaceNormal.z;
						} else {
							var max:int = concatFaces.length;
							vectorX = 0;
							vectorY = 0;
							vectorZ = 0;
							table = {};
							for (var n:int = 0; n<max; n++) {
								var concatFace:TriangleFace = concatFaces[n];
								var concatVertex:Vertex3D
								concatVertex = concatFace.vertex0;
								if (v.localX == concatVertex.localX && v.localY == concatVertex.localY && v.localZ == concatVertex.localZ) {
									concatFaceNormal = concatFace.vector;
									key = int(concatFaceNormal.x*100000)*100+int(concatFaceNormal.y*100000)*10+int(concatFaceNormal.z*100000);
									if (table[key] == null) {
										table[key] = 1;
										vectorX += concatFaceNormal.x;
										vectorY += concatFaceNormal.y;
										vectorZ += concatFaceNormal.z;
									}
									break;
								}
								concatVertex = concatFace.vertex1;
								if (v.localX == concatVertex.localX && v.localY == concatVertex.localY && v.localZ == concatVertex.localZ) {
									concatFaceNormal = concatFace.vector;
									key = int(concatFaceNormal.x*100000)*100+int(concatFaceNormal.y*100000)*10+int(concatFaceNormal.z*100000);
									if (table[key] == null) {
										table[key] = 1;
										vectorX += concatFaceNormal.x;
										vectorY += concatFaceNormal.y;
										vectorZ += concatFaceNormal.z;
									}
									break;
								}
								concatVertex = concatFace.vertex2;
								if (v.localX == concatVertex.localX && v.localY == concatVertex.localY && v.localZ == concatVertex.localZ) {
									concatFaceNormal = concatFace.vector;
									key = int(concatFaceNormal.x*100000)*100+int(concatFaceNormal.y*100000)*10+int(concatFaceNormal.z*100000);
									if (table[key] == null) {
										table[key] = 1;
										vectorX += concatFaceNormal.x;
										vectorY += concatFaceNormal.y;
										vectorZ += concatFaceNormal.z;
									}
									break;
								}
							}
						}
						var k:Number = 1/Math.sqrt(vectorX*vectorX+vectorY*vectorY+vectorZ*vectorZ);
						v.localX += vectorX*k*scale;
						v.localY += vectorY*k*scale;
						v.localZ += vectorZ*k*scale;
					}
				}
			}
		}
		/**
		 * uvs.length = vertices.length.
		 */
		public function sortUVsFromVertices(uvs:Vector.<UV>, vertices:Vector.<Vertex3D>):void {
			if (faces == null || uvs == null || vertices == null) return;
			if (vertices.length != uvs.length) return;
			var length:int = faces.length;
			var list:Vector.<UV> = new Vector.<UV>();
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				var index:int = vertices.indexOf(face.vertex0);
				if (index != -1) list[index] = face.uv0;
				index = vertices.indexOf(face.vertex1);
				if (index != -1) list[index] = face.uv1;
				index = vertices.indexOf(face.vertex2);
				if (index != -1) list[index] = face.uv2;
			}
			VectorUtil.clear(uvs);
			VectorUtil.concat(uvs, list);
		}
	}
}