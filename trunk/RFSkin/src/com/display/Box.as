package com.display
{
	import com.display.event.LayoutEvent;
	import com.display.utils.ObjectUtils;
	import com.youbt.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class Box extends Container
	{
		public function Box(type:String = LayoutType.HORIZONTAL,directionFlag:Boolean = false,_skin:DisplayObjectContainer=null)
		{
			super(_skin);
			this._layout = type;
			this.directionFlag = directionFlag;
		}
		
		public function set gap(value:int):void{
			if(_layout == LayoutType.HORIZONTAL){
				hgap = value;
			}else{
				vgap = value;
			}
		}
		
		override protected function bulid():void{
			var offsetx:int = 0
			var offsety:int = 0
			for each(var item:DisplayObject in childrens){
				if(_layout == LayoutType.HORIZONTAL){
					offsetx = hBulid(item,offsetx);
				}else{
					offsety = vBulid(item,offsety);
				}
			}
		}
		
		protected function hBulid(target:DisplayObject,offset:int):int{
			target.x = offset
			offset += target.width + hgap;
			target.y = 0;
			switch(_vAlign){
				case LayoutType.MIDDLE:
					target.y = (_maxHeight - target.height)/2
				break;
				case LayoutType.BOTTOM:
					target.y = _maxHeight - target.height
				break;
			}
			currentWidth = offset - _hgap
			return offset
		}
		
		protected function vBulid(target:DisplayObject,offset:int):int{
			target.y = offset
			offset += target.height + _vgap;
			target.x = 0;
			switch(_hAlign){
				case LayoutType.CENTER:
					target.x = (_maxWidth - target.width)/2
				break;
				case LayoutType.RIGHT:
					target.x = _maxWidth - target.width
				break;
			}
			currentHeight = offset - _vgap;
			return offset
		}
		
		
		override public function set width(value:Number):void{
//			this._intRectangle.width = value;
		}
		
		override public function set height(value:Number):void{
//			this._intRectangle.height = value;
		}
		
		override public function get width():Number{
			return currentWidth //< super.width ? super.width : currentWidth;
		}
		
		override public function get height():Number{
			return currentHeight// < super.height ? super.height : currentHeight;
		} 
		
		override protected function doData():void{
			var o:Object = ObjectUtils.getObjectPropertys(this._data);
			for (var s:String in o){
				setValue(s,o[s]);
			}
		}
		
//		public function getRealWidth():Number{
//			return super.width;
//		}
//		
//		public function getRealHeight():Number{
//			
//		}
		
	}
}