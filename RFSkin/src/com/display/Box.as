package com.display
{
	import com.display.event.LayoutEvent;
	import com.display.utils.ObjectUtils;
	import com.youbt.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class Box extends Container
	{
		protected var layouttype:String
		protected var childrens:Array
		protected var _maxHeight:Number = 0;
		protected var _maxWidth:Number = 0;
		protected var directionFlag:Boolean;
		protected var currentWidth:Number;
		protected var currentHeight:Number;
		public function Box(type:String = LayoutType.HORIZONTAL,directionFlag:Boolean = false,_skin:DisplayObjectContainer=null)
		{
			this.layouttype = type;
			this.directionFlag = directionFlag;
			childrens = []
			super(_skin);
		}
		
		public function set gap(value:int):void{
			if(layouttype == LayoutType.HORIZONTAL){
				hgap = value;
			}else{
				vgap = value;
			}
		}
		
		protected var offset:Number;
		override public function addChild(child:DisplayObject):DisplayObject{
			if(directionFlag){
				return addChildAt(child,0);
			}else{
				return addChildAt(child,this.numChildren);
			}
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			if(child == null){
				return null;
			}
			childrens.splice(index,0,child);
			child.addEventListener(LayoutEvent.BUILD,rebulidHandler);
			var d:DisplayObject = super.addChildAt(child,index)
			updataChild(child)
			if(child.width >0 && child.height > 0)
				bulidflag = true;
			return d;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject{
			if(child == null){
				return null;
			}
			ArrayUtil.remove(childrens,child);
			child.removeEventListener(LayoutEvent.BUILD,rebulidHandler);
			var d:DisplayObject = super.removeChild(child);
			resetMaxChild()
			bulidflag = true;
			return d;
		}
		
		override public function removeChildAt(index:int):DisplayObject{
			var d:DisplayObject = this.getChildAt(index);
			return this.removeChild(d);
		}
		
		public function getChildrens():Array{
			return childrens;
		}
		
		public function refresh():void{
			resetMaxChild()
			bulid();
		}
		
		override protected function bulid():void{
			var offsetx:int = 0
			var offsety:int = 0
			for each(var item:DisplayObject in childrens){
				if(layouttype == LayoutType.HORIZONTAL){
					offsetx = hBulid(item,offsetx);
				}else{
					offsety = vBulid(item,offsety);
				}
			}
			this.dispatchEvent(new LayoutEvent(LayoutEvent.BUILD));
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
		
		protected function rebulidHandler(event:LayoutEvent):void{
			var child:DisplayObject = event.currentTarget as DisplayObject
			updataChild(child)
			bulidflag = true;
		}
		
		protected function updataChild(child:DisplayObject):void{
			var height:Number = child.height;
			var width:Number = child.width
			if(height>_maxHeight) {
				_maxHeight = height;
			}
			
			if(width>_maxWidth) {
				_maxWidth = width;
			}
			
			currentWidth = _maxWidth
			currentHeight = _maxHeight
		}
		
		protected function resetMaxChild():void{
			_maxHeight = -1;
			_maxWidth  = -1;
			for each(var child:DisplayObject in childrens){
				updataChild(child);
			}
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