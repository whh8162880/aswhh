package asgl.math {
	
	public class Vertex3D {
		private static var _idManager:Number = 0;
		public var cameraX:Number = 0;
		public var cameraY:Number = 0;
		public var cameraZ:Number = 0;
		/**
		 * [read only]
		 */
		public var id:Number;
		public var localX:Number;
		public var localY:Number;
		public var localZ:Number;
		public var screenX:Number = 0;
		public var screenY:Number = 0;
		public var screenZ:Number = 0;
		public var sourceX:Number = 0;
		public var sourceY:Number = 0;
		public var sourceZ:Number = 0;
		public var worldX:Number = 0;
		public var worldY:Number = 0;
		public var worldZ:Number = 0;
		public var color:uint = 0xFFFFFFFF;
		public function Vertex3D(localX:Number=0, localY:Number=0, localZ:Number=0):void {
			id = _idManager;
			_idManager++;
			this.localX = localX;
			this.localY = localY;
			this.localZ = localZ;
		}
		public function cloneAll():Vertex3D {
			var v:Vertex3D = new Vertex3D(localX, localY, localZ);
			v.cameraX = cameraX;
			v.cameraY = cameraY;
			v.cameraZ = cameraZ;
			v.screenX = screenX;
			v.screenY = screenY;
			v.screenZ = screenZ;
			v.sourceX = sourceX;
			v.sourceY = sourceY;
			v.sourceZ = sourceZ;
			v.worldX = worldX;
			v.worldY = worldY;
			v.worldZ = worldZ;
			return v;
		}
		public function cloneCamera():Vertex3D {
			var v:Vertex3D = new Vertex3D();
			v.cameraX = cameraX;
			v.cameraY = cameraY;
			v.cameraZ = cameraZ;
			return v;
		}
		public function cloneLocal():Vertex3D {
			return new Vertex3D(localX, localY, localZ);
		}
		public function cloneScreen():Vertex3D {
			var v:Vertex3D = new Vertex3D();
			v.screenX = screenX;
			v.screenY = screenY;
			v.screenZ = screenZ;
			return v;
		}
		public function cloneWorld():Vertex3D {
			var v:Vertex3D = new Vertex3D();
			v.worldX = worldX;
			v.worldY = worldY;
			v.worldZ = worldZ;
			return v;
		}
		public function copyAll(v:Vertex3D):void {
			cameraX = v.cameraX;
			cameraY = v.cameraY;
			cameraZ = v.cameraZ;
			screenX = v.screenX;
			screenY = v.screenY;
			screenZ = v.screenZ;
			sourceX = v.sourceX;
			sourceY = v.sourceY;
			sourceZ = v.sourceZ;
			worldX = v.worldX;
			worldY = v.worldY;
			worldZ = v.worldZ;
		}
		public function copyCamera(v:Vertex3D):void {
			cameraX = v.cameraX;
			cameraY = v.cameraY;
			cameraZ = v.cameraZ;
		}
		public function copyLocal(v:Vertex3D):void {
			localX = v.localX;
			localY = v.localY;
			localZ = v.localZ;
		}
		public function copyScreen(v:Vertex3D):void {
			screenX = v.screenX;
			screenY = v.screenY;
			screenZ = v.screenZ;
		}
		public function copyWorld(v:Vertex3D):void {
			worldX = v.worldX;
			worldY = v.worldY;
			worldZ = v.worldZ;
		}
		/**
		 * @param m the m is a inverse worldMatrix;
		 */
		public function inverseTransformLocalSpace(m:GLMatrix3D):void {
			localX = worldX*m.a+worldY*m.b+worldZ*m.c+m.tx;
			localY = worldX*m.d+worldY*m.e+worldZ*m.f+m.ty;
			localZ = worldX*m.g+worldY*m.h+worldZ*m.i+m.tz;
		}
		public function inverseTransformScreenSpace(perspectiveCoefficient:Number, cameraHalfWidth:Number, cameraHalfHeight:Number):void {
			var k:Number = -cameraZ;
			screenX = (cameraX+k*cameraHalfWidth-cameraHalfWidth)/k;
			screenY = (cameraY-k*cameraHalfHeight+cameraHalfHeight)/k;
			screenZ = perspectiveCoefficient/k;
		}
		/**
		 * @param m the m is a inverse screenMatrix;
		 */
		public function inverseTransformWorldSpace(m:GLMatrix3D):void {
			worldX = screenX*m.a+screenY*m.b+screenZ*m.c+m.tx;
			worldY = screenX*m.d+screenY*m.e+screenZ*m.f+m.ty;
			worldZ = screenX*m.g+screenY*m.h+screenZ*m.i+m.tz;
		}
		public function localCoordinatesTransform():void {
			var temp:Number = localY;
			localY = localZ;
			localZ = temp;
		}
		public function transformCameraSpace(perspectiveCoefficient:Number, cameraHalfWidth:Number, cameraHalfHeight:Number):void {
			var k:Number = perspectiveCoefficient/screenZ;
			cameraX = k*(screenX-cameraHalfWidth)+cameraHalfWidth;
			cameraY = k*(screenY+cameraHalfHeight)-cameraHalfHeight;
			cameraZ = -k;
		}
		/**
		 * @param m the m is a localMatrix;
		 */
		public function transformLocalSpace(m:GLMatrix3D):void {
			localX = sourceX*m.a+sourceY*m.b+sourceZ*m.c+m.tx;
			localY = sourceX*m.d+sourceY*m.e+sourceZ*m.f+m.ty;
			localZ = sourceX*m.g+sourceY*m.h+sourceZ*m.i+m.tz;
		}
		/**
		 * @param m the m is a screenMatrix;
		 */
		public function transformScreenSpace(m:GLMatrix3D):void {
			screenX = worldX*m.a+worldY*m.b+worldZ*m.c+m.tx;
			screenY = worldX*m.d+worldY*m.e+worldZ*m.f+m.ty;
			screenZ = worldX*m.g+worldY*m.h+worldZ*m.i+m.tz;
		}
		/**
		 * @param m the m is a worldMatrix;
		 */
		public function transformWorldSpace(m:GLMatrix3D):void {
			worldX = localX*m.a+localY*m.b+localZ*m.c+m.tx;
			worldY = localX*m.d+localY*m.e+localZ*m.f+m.ty;
			worldZ = localX*m.g+localY*m.h+localZ*m.i+m.tz;
		}
		public function toCameraString():String {
			return '(cameraX='+cameraX+', cameraY='+cameraY+', cameraZ='+cameraZ+')';
		}
		public function toLocalString():String {
			return '(localX='+localX+', localY='+localY+', localZ='+localZ+')';
		}
		public function toScreenString():String {
			return '(screenX='+screenX+', screenY='+screenY+', screenZ='+screenZ+')';
		}
		public function toSourceString():String {
			return '(sourceX='+sourceX+', sourceY='+sourceY+', sourcenZ='+sourceZ+')';
		}
		public function toString():String {
			return '(localX='+localX+', localY='+localY+', localZ='+localZ+', worldX='+worldX+', worldY='+worldY+', worldZ='+worldZ+', screenX='+screenX+', screenY='+screenY+', screenZ='+screenZ+', cameraX='+cameraX+', cameraY='+cameraY+', cameraZ='+cameraZ+')';
		}
		public function toWorldString():String {
			return  '(worldX='+worldX+', worldY='+worldY+', worldZ='+worldZ+')';
		}
	}
}