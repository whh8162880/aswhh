package asgl.data {
	import __AS3__.vec.Vector;
	
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	
	import flash.geom.Vector3D;
	
	public class BinaryTree {
		private static const HALF_PI:Number = Math.PI/2+0.0000000000001;
		private static const ZERO:Number = 0.0000000000001;
		public var leftSubtree:BinaryTree;
		public var rightSubtree:BinaryTree;
		public var node:*;
		public function BinaryTree(node:*=null):void {
			this.node = node;
		}
		public function getComponentStructureXML(stringFunction:Function=null):XML {
			var xml:XML = <binaryTree/>;
			var sf:Function = stringFunction;
			if (sf == null) {
				sf = function (data:*):String {
					return data.toString();
				}
			}
			var childXML:Function = function (node:XML, bt:BinaryTree):void {
				var child:XML;
				if (bt.leftSubtree != null) {
					child = <leftTree info={sf(bt.leftSubtree.node)}></leftTree>;
					node.appendChild(child);
					childXML(child, bt.leftSubtree);
				}
				if (bt.rightSubtree != null) {
					child = <rightTree info={sf(bt.rightSubtree.node)}></rightTree>;
					node.appendChild(child);
					childXML(child, bt.rightSubtree);
				}
			}
			xml.appendChild(<root info={sf(node)}></root>);
			childXML(xml, this);
			return xml;
		}
		/**
		 * need faces screen space normalize vector.
		 * @param splicFunction(srcFace:TriangleFace, splicFace0:TriangleFace, splicFace1:TriangleFace, splicFace2:TriangleFace, splicVertex0:Vertex3D, splicVertex1:Vertex3D).
		 */
		public static function getFacesBinaryTreeFromScreenSpace(faces:Vector.<TriangleFace>, splicFunction:Function=null):BinaryTree {
			if (faces == null || faces.length == 0) return null;
			var list:Vector.<TriangleFace> = faces.concat();
			var bt:BinaryTree = new BinaryTree(list.shift());
			_createSubtree(bt, list, splicFunction);
			return bt;
		}
		private static function _createSubtree(bt:BinaryTree, faces:Vector.<TriangleFace>, splicFunction:Function):void {
			var face:TriangleFace = bt.node;
			var vector:Vector3D = face.vector;
			var vx:Number = vector.x;
			var vy:Number = vector.y;
			var vz:Number = vector.z;
			var d:Number = Math.sqrt(vx*vx+vy*vy+vz*vz);
			var v0:Vertex3D = face.vertex0;
			var length:int = faces.length;
			var sx:Number = v0.screenX;
			var sy:Number = v0.screenY;
			var sz:Number = v0.screenZ;
			var left:Vector.<TriangleFace> = new Vector.<TriangleFace>();
			var right:Vector.<TriangleFace> = new Vector.<TriangleFace>();
			var lineVX0:Number;
			var lineVY0:Number;
			var lineVZ0:Number;
			var lineVX1:Number;
			var lineVY1:Number;
			var lineVZ1:Number;
			var k:Number;
			var k1:Number;
			var k2:Number;
			var k3:Number;
			var clipV0:Vertex3D;
			var clipV1:Vertex3D;
			var uv0:UV;
			var uv1:UV;
			var dx:Number;
			var dy:Number;
			var dz:Number;
			var clipUV0:UV;
			var clipUV1:UV;
			var du:Number;
			var dv:Number;
			var angle:Number;
			var value:Number;
			var splicFace0:TriangleFace;
			var splicFace1:TriangleFace;
			var splicFace2:TriangleFace; 
			for (var i:int = 0; i<length; i++) {
				var compareFace:TriangleFace = faces[i];
				var b0:int = 2;
				var b1:int = 2;
				var b2:int = 2;
				var compareVertex0:Vertex3D = compareFace.vertex0;
				var csx0:Number = compareVertex0.screenX;
				var csy0:Number = compareVertex0.screenY;
				var csz0:Number = compareVertex0.screenZ;
				var cx:Number = csx0-sx;
				var cy:Number = csy0-sy;
				var cz:Number = csz0-sz;
				if (cx == 0 && cy == 0 && cz == 0) {
					b0 = 1;
				} else {
					value = (vx*cx+vy*cy+vz*cz)/(d*Math.sqrt(cx*cx+cy*cy+cz*cz));
					if (value<=-0.1) {
						b0 = 0;
					} else if (value<=0.1) {
						angle = Math.acos(value);
						value = angle-HALF_PI;
						if (value>=-ZERO && value<=ZERO) {
							b0 = 1;
						} else if (angle>HALF_PI) {
							b0 = 0;
						}
					}
				}
				
				var compareVertex1:Vertex3D = compareFace.vertex1;
				var csx1:Number = compareVertex1.screenX;
				var csy1:Number = compareVertex1.screenY;
				var csz1:Number = compareVertex1.screenZ;
				cx = csx1-sx;
				cy = csy1-sy;
				cz = csz1-sz;
				if (cx == 0 && cy == 0 && cz == 0) {
					b1 = 1;
				} else {
					value = (vx*cx+vy*cy+vz*cz)/(d*Math.sqrt(cx*cx+cy*cy+cz*cz));
					if (value<=-0.1) {
						b1 = 0;
					} else if (value<=0.1) {
						angle = Math.acos(value);
						value = angle-HALF_PI;
						if (value>=-ZERO && value<=ZERO) {
							b1 = 1;
						} else if (angle>HALF_PI) {
							b1 = 0;
						}
					}
				}
				
				var compareVertex2:Vertex3D = compareFace.vertex2;
				var csx2:Number = compareVertex2.screenX;
				var csy2:Number = compareVertex2.screenY;
				var csz2:Number = compareVertex2.screenZ;
				cx = csx2-sx;
				cy = csy2-sy;
				cz = csz2-sz;
				if (cx == 0 && cy == 0 && cz == 0) {
					b2 = 1;
				} else {
					value = (vx*cx+vy*cy+vz*cz)/(d*Math.sqrt(cx*cx+cy*cy+cz*cz));
					if (value<=-0.1) {
						b2 = 0;
					} else if (value<=0.1) {
						angle = Math.acos(value);
						value = angle-HALF_PI;
						if (value>=-ZERO && value<=ZERO) {
							b2 = 1;
						} else if (angle>HALF_PI) {
							b2 = 0;
						}
					}
				}
				
				if (b0>0 && b1>0 && b2>0) {
					left.push(compareFace);
				} else if (b0<2 && b1<2 && b2<2) {
					right.push(compareFace);
				} else if (b0>0) {
					if (b1>0) {
						lineVX0 = csx2-csx0;
						lineVY0 = csy2-csy0;
						lineVZ0 = csz2-csz0;
						k2 = lineVX0*vx+lineVY0*vy+lineVZ0*vz;
						if (k2>=-ZERO && k2<=ZERO) {
							left.push(compareFace);
						} else {
							lineVX1 = csx2-csx1;
							lineVY1 = csy2-csy1;
							lineVZ1 = csz2-csz1;
							k3 = lineVX1*vx+lineVY1*vy+lineVZ1*vz;
							if (k3>=-ZERO && k3<=ZERO) {
								left.push(compareFace);
							} else {
								k = -(vx*csx2+vy*csy2+vz*csz2-vx*sx-vy*sy-vz*sz)/k2;
								clipV0 = new Vertex3D();
								clipV0.screenX = lineVX0*k+csx2;
								clipV0.screenY = lineVY0*k+csy2;
								clipV0.screenZ = lineVZ0*k+csz2;
								
								k = -(vx*csx2+vy*csy2+vz*csz2-vx*sx-vy*sy-vz*sz)/k3;
								clipV1 = new Vertex3D();
								clipV1.screenX = lineVX1*k+csx2;
								clipV1.screenY = lineVY1*k+csy2;
								clipV1.screenZ = lineVZ1*k+csz2;
								
								if (compareFace.isMaterialFace) {
									uv0 = compareFace.uv2;
									uv1 = compareFace.uv0;
									dx = csx2-clipV0.screenX;
									dy = csy2-clipV0.screenY;
									dz = csz2-clipV0.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX0*lineVX0+lineVY0*lineVY0+lineVZ0*lineVZ0);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV0 = uv0.clone();
									clipUV0.u += k1*du;
									clipUV0.v += k1*dv;
									
									uv1 = compareFace.uv1;
									dx = csx2-clipV1.screenX;
									dy = csy2-clipV1.screenY;
									dz = csz2-clipV1.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX1*lineVX1+lineVY1*lineVY1+lineVZ1*lineVZ1);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV1 = uv0.clone();
									clipUV1.u += k1*du;
									clipUV1.v += k1*dv;
									splicFace0 = compareFace.getNewTriangleFace(compareVertex0, compareVertex1, clipV0, true, compareFace.material, compareFace.uv0, compareFace.uv1, clipUV0);
									splicFace1 = compareFace.getNewTriangleFace(compareVertex1, clipV1, clipV0, true, compareFace.material, compareFace.uv1, clipUV1, clipUV0);
									left.push(splicFace0, splicFace1);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex2, clipV0, clipV1, true, compareFace.material, compareFace.uv2, clipUV0, clipUV1);
									right.push(splicFace2);
								} else {
									splicFace0 = compareFace.getNewTriangleFace(compareVertex0, compareVertex1, clipV0);
									splicFace1 = compareFace.getNewTriangleFace(compareVertex1, clipV1, clipV0);
									left.push(splicFace0, splicFace1);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex2, clipV0, clipV1);
									right.push(splicFace2);
								}
								if (splicFunction != null) splicFunction(compareFace, splicFace0, splicFace1, splicFace2, clipV0, clipV1);
							}
						}
						//b0,b1 / b2
					} else if (b2>0) {
						lineVX0 = csx1-csx0;
						lineVY0 = csy1-csy0;
						lineVZ0 = csz1-csz0;
						k2 = lineVX0*vx+lineVY0*vy+lineVZ0*vz;
						if (k2>=-ZERO && k2<=ZERO) {
							left.push(compareFace);
						} else {
							lineVX1 = csx1-csx2;
							lineVY1 = csy1-csy2;
							lineVZ1 = csz1-csz2;
							k3 = lineVX1*vx+lineVY1*vy+lineVZ1*vz;
							if (k3>=-ZERO && k3<=ZERO) {
								left.push(compareFace);
							} else {
								k = -(vx*csx1+vy*csy1+vz*csz1-vx*sx-vy*sy-vz*sz)/k2;
								clipV0 = new Vertex3D();
								clipV0.screenX = lineVX0*k+csx1;
								clipV0.screenY = lineVY0*k+csy1;
								clipV0.screenZ = lineVZ0*k+csz1;
								
								k = -(vx*csx1+vy*csy1+vz*csz1-vx*sx-vy*sy-vz*sz)/k3;
								clipV1 = new Vertex3D();
								clipV1.screenX = lineVX1*k+csx1;
								clipV1.screenY = lineVY1*k+csy1;
								clipV1.screenZ = lineVZ1*k+csz1;
								
								if (compareFace.isMaterialFace) {
									uv0 = compareFace.uv1;
									uv1 = compareFace.uv0;
									dx = csx1-clipV0.screenX;
									dy = csy1-clipV0.screenY;
									dz = csz1-clipV0.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX0*lineVX0+lineVY0*lineVY0+lineVZ0*lineVZ0);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV0 = uv0.clone();
									clipUV0.u += k1*du;
									clipUV0.v += k1*dv;
									
									uv1 = compareFace.uv2;
									dx = csx1-clipV1.screenX;
									dy = csy1-clipV1.screenY;
									dz = csz1-clipV1.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX1*lineVX1+lineVY1*lineVY1+lineVZ1*lineVZ1);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV1 = uv0.clone();
									clipUV1.u += k1*du;
									clipUV1.v += k1*dv;
									splicFace0 = compareFace.getNewTriangleFace(compareVertex0, clipV0, compareVertex2, true, compareFace.material, compareFace.uv0, clipUV0, compareFace.uv2);
									splicFace1 = compareFace.getNewTriangleFace(compareVertex2, clipV0, clipV1, true, compareFace.material, compareFace.uv2, clipUV0, clipUV1);
									left.push(splicFace0, splicFace1);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex1, clipV1, clipV0, true, compareFace.material, compareFace.uv1, clipUV1, clipUV0);
									right.push(splicFace2);
								} else {
									splicFace0 = compareFace.getNewTriangleFace(compareVertex0, clipV0, compareVertex2);
									splicFace1 = compareFace.getNewTriangleFace(compareVertex2, clipV0, clipV1);
									left.push(splicFace0, splicFace1);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex1, clipV1, clipV0);
									right.push(splicFace2);
								}
								if (splicFunction != null) splicFunction(compareFace, splicFace0, splicFace1, splicFace2, clipV0, clipV1);
							}
						}
						//b0,b2 / b1
					} else {
						lineVX0 = csx0-csx1;
						lineVY0 = csy0-csy1;
						lineVZ0 = csz0-csz1;
						k2 = lineVX0*vx+lineVY0*vy+lineVZ0*vz;
						if (k2>=-ZERO && k2<=ZERO) {
							right.push(compareFace);
						} else {
							lineVX1 = csx0-csx2;
							lineVY1 = csy0-csy2;
							lineVZ1 = csz0-csz2;
							k3 = lineVX1*vx+lineVY1*vy+lineVZ1*vz;
							if (k3>=-ZERO && k3<=ZERO) {
								right.push(compareFace);
							} else {
								k = -(vx*csx0+vy*csy0+vz*csz0-vx*sx-vy*sy-vz*sz)/k2;
								clipV0 = new Vertex3D();
								clipV0.screenX = lineVX0*k+csx0;
								clipV0.screenY = lineVY0*k+csy0;
								clipV0.screenZ = lineVZ0*k+csz0;
								
								k = -(vx*csx0+vy*csy0+vz*csz0-vx*sx-vy*sy-vz*sz)/k3;
								clipV1 = new Vertex3D();
								clipV1.screenX = lineVX1*k+csx0;
								clipV1.screenY = lineVY1*k+csy0;
								clipV1.screenZ = lineVZ1*k+csz0;
								
								if (compareFace.isMaterialFace) {
									uv0 = compareFace.uv0;
									uv1 = compareFace.uv1;
									dx = csx0-clipV0.screenX;
									dy = csy0-clipV0.screenY;
									dz = csz0-clipV0.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX0*lineVX0+lineVY0*lineVY0+lineVZ0*lineVZ0);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV0 = uv0.clone();
									clipUV0.u += k1*du;
									clipUV0.v += k1*dv;
									
									uv1 = compareFace.uv2;
									dx = csx0-clipV1.screenX;
									dy = csy0-clipV1.screenY;
									dz = csz0-clipV1.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX1*lineVX1+lineVY1*lineVY1+lineVZ1*lineVZ1);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV1 = uv0.clone();
									clipUV1.u += k1*du;
									clipUV1.v += k1*dv;
									splicFace0 = compareFace.getNewTriangleFace(compareVertex0, clipV0, clipV1, true, compareFace.material, compareFace.uv0, clipUV0, clipUV1);
									left.push(splicFace0);
									splicFace1 = compareFace.getNewTriangleFace(compareVertex1, compareVertex2, clipV0, true, compareFace.material, compareFace.uv1, compareFace.uv2,clipUV0);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex2, clipV1, clipV0, true, compareFace.material, compareFace.uv2, clipUV1, clipUV0);
									right.push(splicFace1, splicFace2);
								} else {
									splicFace0 = compareFace.getNewTriangleFace(compareVertex0, clipV0, clipV1);
									left.push(splicFace0);
									splicFace1 = compareFace.getNewTriangleFace(compareVertex1, compareVertex2, clipV0);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex2, clipV1, clipV0);
									right.push(splicFace1, splicFace2);
								}
								if (splicFunction != null) splicFunction(compareFace, splicFace0, splicFace1, splicFace2, clipV0, clipV1);
							}
						}
						//b0 / b1,b2
					}
				} else if (b1>0) {
					if (b2>0) {
						lineVX0 = csx0-csx1;
						lineVY0 = csy0-csy1;
						lineVZ0 = csz0-csz1;
						k2 = lineVX0*vx+lineVY0*vy+lineVZ0*vz;
						if (k2>=-ZERO && k2<=ZERO) {
							left.push(compareFace);
						} else {
							lineVX1 = csx0-csx2;
							lineVY1 = csy0-csy2;
							lineVZ1 = csz0-csz2;
							k3 = lineVX1*vx+lineVY1*vy+lineVZ1*vz;
							if (k3>=-ZERO && k3<=ZERO) {
								left.push(compareFace);
							} else {
								k = -(vx*csx0+vy*csy0+vz*csz0-vx*sx-vy*sy-vz*sz)/k2;
								clipV0 = new Vertex3D();
								clipV0.screenX = lineVX0*k+csx0;
								clipV0.screenY = lineVY0*k+csy0;
								clipV0.screenZ = lineVZ0*k+csz0;
								
								k = -(vx*csx0+vy*csy0+vz*csz0-vx*sx-vy*sy-vz*sz)/k3;
								clipV1 = new Vertex3D();
								clipV1.screenX = lineVX1*k+csx0;
								clipV1.screenY = lineVY1*k+csy0;
								clipV1.screenZ = lineVZ1*k+csz0;
								
								if (compareFace.isMaterialFace) {
									uv0 = compareFace.uv0;
									uv1 = compareFace.uv1;
									dx = csx0-clipV0.screenX;
									dy = csy0-clipV0.screenY;
									dz = csz0-clipV0.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX0*lineVX0+lineVY0*lineVY0+lineVZ0*lineVZ0);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV0 = uv0.clone();
									clipUV0.u += k1*du;
									clipUV0.v += k1*dv;
									
									uv1 = compareFace.uv2;
									dx = csx0-clipV1.screenX;
									dy = csy0-clipV1.screenY;
									dz = csz0-clipV1.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX1*lineVX1+lineVY1*lineVY1+lineVZ1*lineVZ1);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV1 = uv0.clone();
									clipUV1.u += k1*du;
									clipUV1.v += k1*dv;
									splicFace0 = compareFace.getNewTriangleFace(compareVertex1, compareVertex2, clipV0, true, compareFace.material, compareFace.uv1, compareFace.uv2, clipUV0)
									splicFace1 = compareFace.getNewTriangleFace(compareVertex2, clipV1, clipV0, true, compareFace.material, compareFace.uv2, clipUV1, clipUV0);
									left.push(splicFace0, splicFace1);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex0, clipV0, clipV1, true, compareFace.material, compareFace.uv0, clipUV0, clipUV1);
									right.push(splicFace2);
								} else {
									splicFace0 = compareFace.getNewTriangleFace(compareVertex1, compareVertex2, clipV0);
									splicFace1 = compareFace.getNewTriangleFace(compareVertex2, clipV1, clipV0);
									left.push(splicFace0, splicFace1);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex0, clipV0, clipV1);
									right.push(splicFace2);
								}
								if (splicFunction != null) splicFunction(compareFace, splicFace0, splicFace1, splicFace2, clipV0, clipV1);
							}
						}
						//b1,b2 / b0
					} else {
						lineVX0 = csx1-csx0;
						lineVY0 = csy1-csy0;
						lineVZ0 = csz1-csz0;
						k2 = lineVX0*vx+lineVY0*vy+lineVZ0*vz;
						if (k2>=-ZERO && k2<=ZERO) {
							right.push(compareFace);
						} else {
							lineVX1 = csx1-csx2;
							lineVY1 = csy1-csy2;
							lineVZ1 = csz1-csz2;
							k3 = lineVX1*vx+lineVY1*vy+lineVZ1*vz;
							if (k3>=-ZERO && k3<=ZERO) {
								right.push(compareFace);
							} else {
								k = -(vx*csx1+vy*csy1+vz*csz1-vx*sx-vy*sy-vz*sz)/k2;
								clipV0 = new Vertex3D();
								clipV0.screenX = lineVX0*k+csx1;
								clipV0.screenY = lineVY0*k+csy1;
								clipV0.screenZ = lineVZ0*k+csz1;
								
								k = -(vx*csx1+vy*csy1+vz*csz1-vx*sx-vy*sy-vz*sz)/k3;
								clipV1 = new Vertex3D();
								clipV1.screenX = lineVX1*k+csx1;
								clipV1.screenY = lineVY1*k+csy1;
								clipV1.screenZ = lineVZ1*k+csz1;
								
								if (compareFace.isMaterialFace) {
									uv0 = compareFace.uv1;
									uv1 = compareFace.uv0;
									dx = csx1-clipV0.screenX;
									dy = csy1-clipV0.screenY;
									dz = csz1-clipV0.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX0*lineVX0+lineVY0*lineVY0+lineVZ0*lineVZ0);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV0 = uv0.clone();
									clipUV0.u += k1*du;
									clipUV0.v += k1*dv;
									
									uv1 = compareFace.uv2;
									dx = csx1-clipV1.screenX;
									dy = csy1-clipV1.screenY;
									dz = csz1-clipV1.screenZ;
									k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX1*lineVX1+lineVY1*lineVY1+lineVZ1*lineVZ1);
									du = uv1.u-uv0.u;
									dv = uv1.v-uv0.v;
									clipUV1 = uv0.clone();
									clipUV1.u += k1*du;
									clipUV1.v += k1*dv;
									splicFace0 = compareFace.getNewTriangleFace(compareVertex1, clipV1, clipV0, true, compareFace.material, compareFace.uv1, clipUV1, clipUV0);
									left.push(splicFace0);
									splicFace1 = compareFace.getNewTriangleFace(compareVertex0, clipV0, compareVertex2, true, compareFace.material, compareFace.uv0, clipUV0, compareFace.uv2);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex2, clipV0, clipV1, true, compareFace.material, compareFace.uv2, clipUV0, clipUV1);
									right.push(splicFace1, splicFace2);
								} else {
									splicFace0 = compareFace.getNewTriangleFace(compareVertex1, clipV1, clipV0);
									left.push(splicFace0);
									splicFace1 = compareFace.getNewTriangleFace(compareVertex0, clipV0, compareVertex2);
									splicFace2 = compareFace.getNewTriangleFace(compareVertex2, clipV0, clipV1);
									right.push(splicFace1, splicFace2);
								}
								if (splicFunction != null) splicFunction(compareFace, splicFace0, splicFace1, splicFace2, clipV0, clipV1);
							}
						}
						//b1 / b0,b2
					}
				} else {
					lineVX0 = csx2-csx0;
					lineVY0 = csy2-csy0;
					lineVZ0 = csz2-csz0;
					k2 = lineVX0*vx+lineVY0*vy+lineVZ0*vz;
					if (k2>=-ZERO && k2<=ZERO) {
						right.push(compareFace);
					} else {
						lineVX1 = csx2-csx1;
						lineVY1 = csy2-csy1;
						lineVZ1 = csz2-csz1;
						k3 = lineVX1*vx+lineVY1*vy+lineVZ1*vz;
						if (k3>=-ZERO && k3<=ZERO) {
							right.push(compareFace);
						} else {
							k = -(vx*csx2+vy*csy2+vz*csz2-vx*sx-vy*sy-vz*sz)/k2;
							clipV0 = new Vertex3D();
							clipV0.screenX = lineVX0*k+csx2;
							clipV0.screenY = lineVY0*k+csy2;
							clipV0.screenZ = lineVZ0*k+csz2;
							
							k = -(vx*csx2+vy*csy2+vz*csz2-vx*sx-vy*sy-vz*sz)/k3;
							clipV1 = new Vertex3D();
							clipV1.screenX = lineVX1*k+csx2;
							clipV1.screenY = lineVY1*k+csy2;
							clipV1.screenZ = lineVZ1*k+csz2;
							
							if (compareFace.isMaterialFace) {
								uv0 = compareFace.uv2;
								uv1 = compareFace.uv0;
								dx = csx2-clipV0.screenX;
								dy = csy2-clipV0.screenY;
								dz = csz2-clipV0.screenZ;
								k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX0*lineVX0+lineVY0*lineVY0+lineVZ0*lineVZ0);
								du = uv1.u-uv0.u;
								dv = uv1.v-uv0.v;
								clipUV0 = uv0.clone();
								clipUV0.u += k1*du;
								clipUV0.v += k1*dv;
								
								uv1 = compareFace.uv1;
								dx = csx2-clipV1.screenX;
								dy = csy2-clipV1.screenY;
								dz = csz2-clipV1.screenZ;
								k1 = Math.sqrt(dx*dx+dy*dy+dz*dz)/Math.sqrt(lineVX1*lineVX1+lineVY1*lineVY1+lineVZ1*lineVZ1);
								du = uv1.u-uv0.u;
								dv = uv1.v-uv0.v;
								clipUV1 = uv0.clone();
								clipUV1.u += k1*du;
								clipUV1.v += k1*dv;
								splicFace0 = compareFace.getNewTriangleFace(compareVertex2, clipV0, clipV1, true, compareFace.material, compareFace.uv2, clipUV0, clipUV1);
								left.push(splicFace0);
								splicFace1 = compareFace.getNewTriangleFace(compareVertex0, compareVertex1, clipV0, true, compareFace.material, compareFace.uv0, compareFace.uv1, clipUV0);
								splicFace2 = compareFace.getNewTriangleFace(compareVertex1, clipV1, clipV0, true, compareFace.material, compareFace.uv1, clipUV1, clipUV0);
								right.push(splicFace1, splicFace2);
							} else {
								splicFace0 = compareFace.getNewTriangleFace(compareVertex2, clipV0, clipV1);
								left.push(splicFace0);
								splicFace1 = compareFace.getNewTriangleFace(compareVertex0, compareVertex1, clipV0);
								splicFace2 = compareFace.getNewTriangleFace(compareVertex1, clipV1, clipV0);
								right.push(splicFace1, splicFace2);
							}
							if (splicFunction != null) splicFunction(compareFace, splicFace0, splicFace1, splicFace2, clipV0, clipV1);
						}
					}
					//b2 / b0,b1
				}
			}
			if (left.length>0) {
				var leftBt:BinaryTree = new BinaryTree(left.shift());
				bt.leftSubtree = leftBt;
				if (left.length>0) _createSubtree(leftBt, left, splicFunction);
			}
			if (right.length>0) {
				var rightBt:BinaryTree = new BinaryTree(right.shift());
				bt.rightSubtree = rightBt;
				if (right.length>0) _createSubtree(rightBt, right, splicFunction);
			}
		}
	}
}