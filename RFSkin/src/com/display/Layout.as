package com.display
{
	import com.display.event.LayoutEvent;
	import com.youbt.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class Layout extends Sprite
	{
		protected var _hgap:int 
		protected var _vgap:int
		protected var _hAlign:String;
		protected var _vAlign:String;
		protected var _hParentAlign:String;
		protected var _vParentAlign:String;
		protected var _buildFlag:Boolean = false;
		protected var _layout:String;
		
		protected var childrens:Array;
		protected var directionFlag:Boolean;
		
		protected var _maxHeight:Number = 0;
		protected var _maxWidth:Number = 0;
		protected var currentWidth:Number;
		protected var currentHeight:Number;
		public function Layout()
		{
			childrens = []
			_hgap = _vgap = 8;
			_layout = LayoutType.ABSOLUTE;
			_hAlign = LayoutType.LEFT;
			_vAlign = LayoutType.TOP;
			_hParentAlign = LayoutType.ABSOLUTE;
			_vParentAlign = LayoutType.ABSOLUTE;
		}
		
		//--------------------------------------
		public function set hgap(value:int):void{
			if(_hgap == value) return;
			_hgap = value;
			bulidflag = true
		}
		
		public function get hgap():int{
			return _hgap
		}
		
		//---------------------------------------
		public function set vgap(value:int):void{
			if(_vgap == value) return;
			_vgap = value;
			bulidflag= true
		}
		
		public function get vgap():int{
			return _hgap
		}
		
		//---------------------------------------
		public function set hParentAlign(value:String):void{
			if(_hParentAlign == value) return;
			_hParentAlign = value;
			bulidflag= true
		}
		
		public function get hParentAlign():String{
			return _hParentAlign
		}
		
		//---------------------------------------
		public function set vParentAlign(value:String):void{
			if(_vParentAlign == value) return;
			_vParentAlign = value;
			bulidflag= true
		}
		
		public function get vParentAlign():String{
			return _vParentAlign
		}
		
		//---------------------------------------
		public function set vAlign(value:String):void{
			if(_vAlign == value) return;
			_vAlign = value;
			bulidflag= true
		}
		
		public function get vAlign():String{
			return _vAlign
		}
		
		//---------------------------------------
		public function set hAlign(value:String):void{
			if(_hAlign == value) return;
			_hAlign = value;
			bulidflag= true
		}
		
		public function get hAlign():String{
			return _hAlign
		}
		
		//---------------------------------------
		public function set layout(value:String):void{
			if(_layout == value) return;
			_layout = value;
			bulidflag= true
		}
		
		public function get layout():String{
			return _layout
		}
		
		public function set bulidflag(value:Boolean):void{
			if(_buildFlag == value){
				return;
			}
			if(_buildFlag == false && (_layout != LayoutType.ABSOLUTE || _hAlign != LayoutType.LEFT || _vAlign != LayoutType.TOP)){
				_buildFlag = true;
				this.addEventListener(Event.ENTER_FRAME,enterFrameHandelr);
			}else{
				_buildFlag = false;
				this.removeEventListener(Event.ENTER_FRAME,enterFrameHandelr);
			}
		}
		
		protected function enterFrameHandelr(event:Event):void{
			bulidflag = false;
			this.removeEventListener(Event.ENTER_FRAME,enterFrameHandelr);
			bulid();
			if(this.width != 0 && this.height != 0){
				this.dispatchEvent(new LayoutEvent(LayoutEvent.BUILD));
			}
		}
		
		
		
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
			if(index>super.numChildren){
				index = super.numChildren
			}
			var d:DisplayObject = super.addChildAt(child,index)
			updataChild(child)
			if(child.width >0 && child.height > 0)
				bulidflag = true;
			return d;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject{
			if(child == null && this.contains(child) == false){
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
		
		public function refreshLayout():void{
			resetMaxChild()
			bulid();
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
		
		
		protected function bulid():void{
			
		}

	}
}