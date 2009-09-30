package asgl.utils {
	import __AS3__.vec.Vector;
	
	import asgl.math.UV;
	import asgl.mesh.TriangleFace;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class Image {
		public static function clipBlockAlpha(img:BitmapData, rows:uint, columns:uint):BitmapData {
			if (img == null) return null;
			function hAlphaTest(endX:int, y:int):Boolean {
				for (var i:int = 0; i<endX; i++) {
					if ((img.getPixel32(i, y)>>24&0xFF) != 0) return false;
				}
				return true;
			}
			function vAlphaTest(endY:int, x:int):Boolean {
				for (var i:int = 0; i<endY; i++) {
					if ((img.getPixel32(x, i)>>24&0xFF) != 0) return false;
				}
				return true;
			}
			var m:int;
			var width:int = img.width;
			var height:int = img.height;
			var unitW:int = width/columns;
			var middleW:int = unitW/2;
			var finalWD:int = Number.POSITIVE_INFINITY;
			for (var i:int = 0; i<columns; i++) {
				var startW:int = unitW*i;
				var endW:int = startW+unitW-1;
				var wD:int;
				for (m = 0; m<middleW; m++) {
					if (vAlphaTest(height-1, startW+m) && vAlphaTest(height-1, endW-m)) {
						wD = m+1;
					} else {
						break;
					}
				}
				if (finalWD>wD) finalWD = wD;
			}
			
			var unitH:int = height/rows;
			var middleH:int = unitH/2;
			var finalHUD:int = Number.POSITIVE_INFINITY;
			var finalHDD:int = Number.POSITIVE_INFINITY;
			for (i = 0; i<rows; i++) {
				var startH:int = unitH*i;
				var endH:int = startH+unitH-1;
				var hUD:int;
				var hDD:int;
				for (m = 0; m<middleH; m++) {
					if (hAlphaTest(width-1, startH+m)) {
						hUD = m+1;
					} else {
						break;
					}
				}
				if (finalHUD>hUD) finalHUD = hUD;
				
				for (m = 0; m<middleH; m++) {
					if (hAlphaTest(width-1, endH-m)) {
						hDD = m+1;
					} else {
						break;
					}
				}
				if (finalHDD>hDD) finalHDD = hDD;
			}
			
			var finalUnitW:int = unitW-finalWD*2;
			var outputV:BitmapData = new BitmapData(width-finalWD*columns*2, height, true, 0);
			var matrix:Matrix = new Matrix();
			var rect:Rectangle = new Rectangle(0, 0, finalUnitW, height);
			for (i = 0; i<columns; i++) {
				matrix.tx = -finalWD*((i+1)*2-1);
				rect.x = finalUnitW*i;
				outputV.draw(img, matrix, null, null, rect);
			}
			
			var finalUnitH:int = unitH-(finalHUD+finalHDD);
			var output:BitmapData = new BitmapData(outputV.width, height-(finalHUD+finalHDD)*rows, true, 0);
			matrix.tx = 0;
			rect.x = 0;
			rect.width = outputV.width;
			rect.height = finalUnitH;
			for (i = 0; i<rows; i++) {
				matrix.ty = -(finalHUD*(i+1))-(finalHDD*i);
				rect.y = finalUnitH*i;
				output.draw(outputV, matrix, null, null, rect);
			}
			outputV.dispose();
			
			return output;
		}
		/**
		 * @param faces the faces are materialFaces.
		 */
		public static function createUVImage(width:uint, height:uint, backgroundColor:uint, lineColor:uint, faces:Vector.<TriangleFace>):BitmapData {
			if (width>2880) {
				width = 2880;
			} else if (width<1) {
				width = 1;
			}
			if (height>2880) {
				height = 2880;
			} else if (height<1) {
				height = 1;
			}
			var img:BitmapData = new BitmapData(width, height, true, backgroundColor);
			var length:int = faces.length;
			var shape:Shape = new Shape();
			var g:Graphics = shape.graphics;
			g.lineStyle(1, lineColor&0xFFFFFF, (lineColor>>24&0xFF)/255);
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				if (face.isMaterialFace) {
					var uv1:UV = face.uv0;
					var uv2:UV = face.uv1;
					var uv3:UV = face.uv2;
					g.moveTo(uv1.u*width, uv1.v*height);
					g.lineTo(uv2.u*width, uv2.v*height);
					g.lineTo(uv3.u*width, uv3.v*height);
					g.lineTo(uv1.u*width, uv1.v*height);
				}
			}
			img.draw(shape);
			return img;
		}
		public static function diffuseAndBumpBlend(diffuse:BitmapData, bump:BitmapData):BitmapData {
			var dw:int = diffuse.width-1;
			var dh:int = diffuse.height-1;
			var bw:int = bump.width-1;
			var bh:int = bump.height-1;
			var out:BitmapData = new BitmapData(dw, dh, true, 0);
			for (var y:int = 0; y<=dh; y++) {
				var by:int = y*bh/dh;
				for (var x:int = 0; x<=dw; x++) {
					var kx:Number = x/dw;
					var p:uint = bump.getPixel(kx*bw, by);
					var b:Number = ((p>>16&0xFF)+(p>>8*0xFF)+(p&0xFF))/765;
					p = diffuse.getPixel32(x, y);
					out.setPixel32(x, y, (p&0xFF000000)|((p>>16&0xFF)*b)<<16|((p>>8&0xFF)*b)<<8|((p&0xFF)*b));
				}
			}
			return out;
		}
		public static function flipHorizontal(img:BitmapData):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			out.draw(img, new Matrix(-1, 0, 0, 1, w));
			return out;
		}
		public static function flipHorizontalAndVertical(img:BitmapData):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			out.draw(img, new Matrix(-1, 0, 0, -1, w, h));
			return out;
		}
		public static function flipNormalImage(img:BitmapData, flipX:Boolean=true, flipY:Boolean=true, flipZ:Boolean=false):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			var vx:Number;
			var vy:Number;
			var vz:Number;
			for (var i:int = 0; i<w; i++) {
				for (var j:int = 0; j<h; j++) {
					var color:uint = img.getPixel(i, j);
					var nx:int = color>>16&0xFF;
					var ny:int = color>>8&0xFF;
					var nz:int = color&0xFF;
					if (nx>127) {
						vx = (nx-127)/128;
					} else if (nx<127) {
						vx = (nx-127)/127;
					} else {
						vx = 0;
					}
					if (ny>127) {
						vy = (ny-127)/128;
					} else if (ny<127) {
						vy = (ny-127)/127;
					} else {
						vy = 0;
					}
					if (nz>127) {
						vz = (nz-127)/128;
					} else if (nz<127) {
						vz = (nz-127)/127;
					} else {
						vz = 0;
					}
					if (flipX) vx = -vx;
					if (flipY) vy = -vy;
					if (flipZ) vz = -vz;
					out.setPixel32(i, j, 0xFF000000|int(127+vx*(vx>=0 ? 128 : 127))<<16|int(127+vy*(vy>=0 ? 128 : 127))<<8|int(127+vz*(vz>=0 ? 128 : 127)));
				}
			}
			return out;
		}
		public static function flipVertical(img:BitmapData):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			out.draw(img, new Matrix(1, 0, 0, -1, 0, h));
			return out;
		}
		public static function hasAlpha(img:BitmapData):Boolean {
			var w:int = img.width;
			var h:int = img.height;
			for (var i:int = 0; i<w; i++) {
				for (var j:int = 0; j<h; j++) {
					if ((img.getPixel32(i, j)>>24&0xFF) != 255) return true;
				}
			}
			return false;
		}
		public static function hasInstance(img:BitmapData):Boolean {
			if (img == null) return false;
			try {
				img.width;
			} catch (e:Error) {
				return false;
			}
			return true;
		}
		public static function setAlpha(img:BitmapData, alphaRatio:Number):BitmapData {
			if (alphaRatio == 1) return img.clone();
			if (alphaRatio == 0) return new BitmapData(img.width, img.height, true, 0x00);
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			out.draw(img);
			out.colorTransform(new Rectangle(0, 0, w, h), new ColorTransform(1, 1, 1, alphaRatio));
			return out;
		}
		public static function setBlackToAlpha(img:BitmapData, offset:int = 0):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			out.draw(img);
			for (var i:int = 0; i<w; i++) {
				for (var j:int = 0; j<h; j++) {
					var color:uint = out.getPixel32(i, j);
					if ((color>>16&0xFF)<=offset && (color>>8&0xFF)<=offset && (color&0xFF)<=offset) out.setPixel32(i, j, 0x00000000);
				}
			}
			return out;
		}
		public static function setBlackWhiteColor(img:BitmapData, threshold:int=128):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			for (var i:int = 0; i<w; i++) {
				for (var j:int = 0; j<h; j++) {
					var color:uint = img.getPixel32(i, j);
					out.setPixel32(i, j, ((color>>16&0xFF)+(color>>8&0xFF)+(color&0xFF))/3>threshold ? color&0xFF000000|0xFFFFFF : color&0xFF000000);
				}
			}
			return out;
		}
		/**
		 * @param value the value is 0 to 1.
		 */
		public static function setBrightness(img:BitmapData, value:Number):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			if (value == 0.5) {
				out.draw(img);
			} else if (value>=1) {
				out.applyFilter(img, new Rectangle(0, 0, w, h), new Point(), new ColorMatrixFilter([0, 0, 0, 0, 255, 0, 0, 0, 0, 255, 0, 0, 0, 0, 255, 0, 0, 0, 1, 0]));
			} else if (value<=0) {
				out.applyFilter(img, new Rectangle(0, 0, w, h), new Point(), new ColorMatrixFilter([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0]));
			} else if (value>0.5) {
				value = value*2-1;
				var k1:Number = 1-value;
				var k2:Number = 255*value;
				out.applyFilter(img, new Rectangle(0, 0, w, h), new Point(), new ColorMatrixFilter([k1, 0, 0, 0, k2, 0, k1, 0, 0, k2, 0, 0, k1, 0, k2, 0, 0, 0, 1, 0]));
			} else {
				value *= 2;
				out.applyFilter(img, new Rectangle(0, 0, w, h), new Point(), new ColorMatrixFilter([value, 0, 0, 0, 0, 0, value, 0, 0, 0, 0, 0, value, 0, 0, 0, 0, 0, 1, 0]));
			}
			return out;
		}
		public static function setGray(img:BitmapData):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			var k:Number = 1/3;
			out.applyFilter(img, new Rectangle(0, 0, w, h), new Point(), new ColorMatrixFilter([k, k, k, 0, 0, k, k, k, 0, 0, k, k, k, 0, 0, 0, 0, 0, 1, 0]));
			return out;
		}
		public static function setInverseColor(img:BitmapData):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			out.applyFilter(img, new Rectangle(0, 0, w, h), new Point(), new ColorMatrixFilter([-1, 0, 0, 0, 255, 0, -1, 0, 0, 255, 0, 0, -1, 0, 255, 0, 0, 0, 1, 0]));
			return out;
		}
		public static function setSideLine(img:BitmapData, color:uint=0xFF000000):BitmapData {
			var w:int = img.width;
			var h:int = img.height;
			var out:BitmapData = new BitmapData(w, h, true, 0);
			w--;
			h--;
			out.draw(img);
			for (var i:int = 0; i<=w; i++) {
				out.setPixel32(i, 0, color);
				out.setPixel32(i, h, color);
			}
			for (i = 1; i<h; i++) {
				out.setPixel32(0, i, color);
				out.setPixel32(w, i, color);
			}
			return out;
		}
	}
}