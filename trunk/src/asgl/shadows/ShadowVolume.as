package asgl.shadows {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.lights.AbstractLight;
	import asgl.lights.AmbientLight;
	import asgl.lights.EmptyLight;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	import asgl.utils.VectorUtil;
	
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	public class ShadowVolume extends AbstractShadow {
		/**
		 * need faces screen space normal.
		 */
		public var volumeBackFaces:Vector.<TriangleFace>;
		/**
		 * need faces screen space normal.
		 */
		public var volumeForeFaces:Vector.<TriangleFace>;
		public var screenZOffset:Number = 0;
		private var _totalBackFaces:int;
		private var _totalForeFaces:int;
		private var _abY:Number;
		private var _acX:Number;
		private var _acY:Number;
		private var _pixelX:Number;
		private var _pixelY:Number;
		private var _pixelZ:Number;
		private var _v0sy:Number;
		private var _vectorX:Number;
		private var _vectorY:Number;
		private var _vectorZ:Number;
		private var _u:Number;
		private var _v:Number;
		private var _backFacesData:Vector.<FaceData>;
		private var _forefacesData:Vector.<FaceData>;
		public function ShadowVolume(volumeForeFaces:Vector.<TriangleFace>=null, volumeBackFaces:Vector.<TriangleFace>=null):void {
			this.volumeForeFaces = volumeForeFaces;
			this.volumeBackFaces = volumeBackFaces;
			alphaRatio = 1;
			redRatio = 1;
			greenRatio = 1;
			blueRatio = 1;
		}
		public function clearBackFacesData():void {
			_backFacesData = null;
		}
		public function clearForeFacesData():void {
			_forefacesData = null;
		}
		public function computeBackFacesData():void {
			if (_backFacesData == null) _backFacesData = new Vector.<FaceData>();
			_computeFacesData(_backFacesData, volumeBackFaces);
		}
		public function computeForeFacesData():void {
			if (_forefacesData == null) _forefacesData = new Vector.<FaceData>();
			_computeFacesData(_forefacesData, volumeForeFaces);
		}
		public override function destroy():void {
			_backFacesData = null;
			_forefacesData = null;
			volumeBackFaces = null;
			volumeForeFaces = null;
		}
		public override function init(driver:AbstractRenderDriver):void {
			_totalBackFaces = _backFacesData == null ? 0 : _backFacesData.length;
			_totalForeFaces = _forefacesData == null ? 0 : _forefacesData.length;
			alphaRatio = 1;
			redRatio = 1;
			greenRatio = 1;
			blueRatio = 1;
		}
		public override function shadowTest(pixelScreenVertex:Vertex3D):void {
			var count:int = 0;
			var data:FaceData;
			_pixelX = pixelScreenVertex.screenX;
			_pixelY = pixelScreenVertex.screenY;
			_pixelZ = pixelScreenVertex.screenZ+screenZOffset;
			for (var i:int = 0; i<_totalBackFaces; i++) {
				data = _backFacesData[i];
				_v0sy = data.v0Y;
				_abY = data.abY;
				_acX = data.acX;
				_acY = data.acY;
				_u = (_pixelX*_acY-_pixelY*_acX-data.k0)/data.k1;
				if (isNaN(_u) || _u<0) continue;
				if (_acX == 0) {
					if (_acY == 0) {
						continue;
					} else {
						_v = (_pixelY-_v0sy-_u*_abY)/_acY;
						if (_v<0) continue;
					}
				} else {
					_v = (_pixelY-_v0sy-_u*_abY)/_acY;
					if (_v<0) continue;
				}
				if (isNaN(_v) || _u+_v>1) continue;
				_vectorX = data.vectorX;
				_vectorY = data.vectorY;
				_vectorZ = data.vectorZ;
				if (_pixelZ>=(_vectorX*data.v0X+_vectorY*_v0sy+_vectorZ*data.v0Z-_vectorX*_pixelX-_vectorY*_pixelY)/_vectorZ) count++;
			}
			for (i = 0; i<_totalForeFaces; i++) {
				data = _forefacesData[i];
				_v0sy = data.v0Y;
				_abY = data.abY;
				_acX = data.acX;
				_acY = data.acY;
				_u = (_pixelX*_acY-_pixelY*_acX-data.k0)/data.k1;
				if (isNaN(_u) || _u<0) continue;
				if (_acX == 0) {
					if (_acY == 0) {
						continue;
					} else {
						_v = (_pixelY-_v0sy-_u*_abY)/_acY;
						if (_v<0) continue;
					}
				} else {
					_v = (_pixelY-_v0sy-_u*_abY)/_acY;
					if (_v<0) continue;
				}
				if (isNaN(_v) || _u+_v>1) continue;
				_vectorX = data.vectorX;
				_vectorY = data.vectorY;
				_vectorZ = data.vectorZ;
				if (_pixelZ>(_vectorX*data.v0X+_vectorY*_v0sy+_vectorZ*data.v0Z-_vectorX*_pixelX-_vectorY*_pixelY)/_vectorZ) {
					count--
				}
			}
			light.hasShadow = count != 0;
		}
		public static function createVolumeFaces(screenSpaceForeFaces:Vector.<TriangleFace>, lights:Vector.<AbstractLight>, getForeFaces:Vector.<TriangleFace>, getBackFaces:Vector.<TriangleFace>, lineExtensionLength:Number=10000):void {
			if (screenSpaceForeFaces == null || lights == null) return;
			var lightList:Vector.<AbstractLight> = lights.concat();
			var totalFaces:int = screenSpaceForeFaces.length;
			var totalLights:int = lightList.length;
			var light:AbstractLight;
			var lineDic:Dictionary = new Dictionary();
			for (var i:int = 0; i<totalLights; i++) {
				light = lightList[i];
				lineDic[light] = {};
				if (light is AmbientLight || light is EmptyLight) {
					lightList.splice(i, 1);
					i--;
					totalLights--;
				}
			}
			if (totalLights == 0) return;
			VectorUtil.clear(getForeFaces);
			VectorUtil.concat(getForeFaces, screenSpaceForeFaces);
			VectorUtil.clear(getBackFaces);
			var sourceCoordMap:Object = {};
			var coordMap:Object;
			var lineMap:Object = {};
			var lineMap2:Object = {};
			var key0:String;
			var key1:String;
			var ev0:Vertex3D;
			var ev1:Vertex3D;
			var ev2:Vertex3D;
			var ev3:Vertex3D;
			var vector:Vector3D = new Vector3D();
			var tempValue:Number;
			var extensionVertex0:Vertex3D;
			var extensionVertex1:Vertex3D;
			var extensionVertex2:Vertex3D;
			var c0:String;
			var c1:String;
			var face:TriangleFace;
			var computeExtensionVertex:Function = function (extensionVertex:Vertex3D, targetVertex:Vertex3D):void {
				vector.normalize();
				extensionVertex.screenX = targetVertex.screenX+lineExtensionLength*vector.x;
				extensionVertex.screenY = targetVertex.screenY+lineExtensionLength*vector.y;
				extensionVertex.screenZ = targetVertex.screenZ+lineExtensionLength*vector.z;
			}
			var computeLine:Function = function (c0:String, c1:String):void {
				var key0:String = c0+'&'+c1;
				if (lineMap2[key0] == null) {
					key1 = c1+'&'+c0;
					if (lineMap2[key1] == null) {
						if (lineMap[key0] == null) {
							if (lineMap[key1] == null) {
								lineMap[key0] = 1;
							} else {
								delete lineMap[key1];
								lineMap2[key1] = 1;
							}
						} else {
							delete lineMap[key0];
							lineMap2[key0] = 1;
						}
					}
				}
			}
			for (i = 0; i<totalFaces; i++) {
				face = screenSpaceForeFaces[i];
				var v0:Vertex3D = face.vertex0;
				var v1:Vertex3D = face.vertex1;
				var v2:Vertex3D = face.vertex2;
				c0 = v0.screenX+'_'+v0.screenY+'_'+v0.screenZ;
				c1 = v1.screenX+'_'+v1.screenY+'_'+v1.screenZ;
				var c2:String = v2.screenX+'_'+v2.screenY+'_'+v2.screenZ;
				
				sourceCoordMap[c0] = v0;
				sourceCoordMap[c1] = v1;
				sourceCoordMap[c2] = v2;
				
				for (var j:int = 0; j<totalLights; j++) {
					light = lightList[j];
					light.getLightingVector(v0, vector);
					extensionVertex0 = new Vertex3D();
					computeExtensionVertex(extensionVertex0, v0);
					
					light.getLightingVector(v1, vector);
					extensionVertex1 = new Vertex3D();
					computeExtensionVertex(extensionVertex1, v1);
					
					light.getLightingVector(v2, vector);
					extensionVertex2 = new Vertex3D();
					computeExtensionVertex(extensionVertex2, v2);
					
					getBackFaces.push(new TriangleFace(extensionVertex0, extensionVertex2, extensionVertex1));
					
					coordMap = lineDic[light];
					coordMap[c0] = extensionVertex0;
					coordMap[c1] = extensionVertex1;
					coordMap[c2] = extensionVertex2;
				}
				
				computeLine(c0, c1);
				computeLine(c1, c2);
				computeLine(c2, c0);
			}
			for (var key:String in lineMap) {
				var coordList:Array = key.split('&');
				c0 = coordList[0];
				c1 = coordList[1];
				ev0 = sourceCoordMap[c0];
				ev1 = sourceCoordMap[c1];
				for (i = 0; i<totalLights; i++) {
					coordMap = lineDic[lightList[i]];
					ev2 = coordMap[c0];
					ev3 = coordMap[c1];
					face = new TriangleFace(ev0, ev2, ev1);
					if (face.isBack) {
						getBackFaces.push(face);
					} else {
						getForeFaces.push(face);
					}
					face = new TriangleFace(ev2, ev3, ev1);
					if (face.isBack) {
						getBackFaces.push(face);
					} else {
						getForeFaces.push(face);
					}
				}
			}
		}
		private function _computeFacesData(datas:Vector.<FaceData>, faces:Vector.<TriangleFace>):void {
			if (faces == null) return;
			var length:int = faces.length;
			var face:TriangleFace;
			for (var i:int = 0; i<length; i++) {
				face = faces[i];
				var data:FaceData = new FaceData();
				datas[i] = data;
				var v0:Vertex3D = face.vertex0;
				var v1:Vertex3D = face.vertex1;
				var v2:Vertex3D = face.vertex2;
				var vector:Vector3D = face.vector;
				var v0X:Number = v0.screenX;
				var v0Y:Number = v0.screenY;
				data.v0X = v0X;
				data.v0Y = v0Y;
				data.v0Z = v0.screenZ;
				var abX:Number = v1.screenX-v0X;
				data.abY = v1.screenY-v0Y;
				data.acX = v2.screenX-v0X;
				data.acY = v2.screenY-v0Y;
				data.k0 = v0X*data.acY-v0Y*data.acX;
				data.k1 = abX*data.acY-data.abY*data.acX;
				data.vectorX = vector.x;
				data.vectorY = vector.y;
				data.vectorZ = vector.z;
			}
		}
	}
}
class FaceData {
	public var abY:Number;
	public var acX:Number;
	public var acY:Number;
	public var k0:Number;
	public var k1:Number;
	public var v0X:Number;
	public var v0Y:Number;
	public var v0Z:Number;
	public var vectorX:Number;
	public var vectorY:Number;
	public var vectorZ:Number;
}