package com.display
{
	import com.display.event.LayoutEvent;
	import com.display.skin.SkinInteractiveBase;
	import com.display.utils.geom.IntRectangle;
	import com.youbt.geom.IntPoint;
	import com.youbt.utils.ColorUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class Container extends Layout
	{
		protected var _skin:DisplayObjectContainer;
		protected var dict:Dictionary
		protected var _data:Object
		protected var _enabled:Boolean;
		protected var inited:Boolean
		protected var addToStaged:Boolean
		protected var layerDict:Dictionary;
		protected var _intRectangle:IntRectangle;
		protected var _focusPoint:IntPoint
		protected var _skinlayer:int = 1;
		public function Container(_skin:DisplayObjectContainer = null)
		{
			super();
			_focusPoint = new IntPoint(0,0);
			addToStaged = false;
			inited = false;
			dict = new Dictionary()
			if(!layerDict)
				layerDict = new Dictionary();
			if(_skin){
				this.skin = _skin;
			}else{
				this.skin = initSkin();
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE,toStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,toStageHandler);
		}
		
		public function set focusPoint(value:IntPoint):void{
			if(_focusPoint == null){
				return ;
			}
			this._focusPoint = _focusPoint;
		}
		
		public function get focusPoint():IntPoint{
			return _focusPoint;
		}
		
		protected function initSkin():DisplayObjectContainer{
			return null
		}
		
		public function set skin(value:DisplayObjectContainer):void{
			resetSkin(value);
			this._skin = value;
			if(this._skin){
				createSkin();
				if(_skin != this){
					addSkin();
				}
			}
		}
		
		protected function addSkin():void{
			this.addDisplayObjectToLayer("skin",_skin,_skinlayer);
		}
		
		public function get skin():DisplayObjectContainer{
			return _skin;
		}
		
		protected function createSkin():void{
			
		}
		
		private function resetSkin(value:DisplayObjectContainer):DisplayObjectContainer{
			if(_skin == null){
				return null;
			}
			
			var d:DisplayObjectContainer = _skin.parent;
			if(d != null){
				d.removeChild(_skin);
			}
			
			if(value == null){
				return null;
			}
			
			value.x = _skin.x;
			value.y = _skin.y;
			
			if(d!=null){
				d.addChild(value);
			}
			
			_skin = null
			
			return d;
		}
		
		public function regDisplayObjectToProperty(d:DisplayObject,propertyname:String):void{
			if(dict[propertyname] != null){
				dict[propertyname] = null;
			}
			dict[propertyname] = d;
		}
		
		public function setValue(propertyname:String,value:Object):void{
			var d:DisplayObject = dict[propertyname]
			if(d==null){
				return;
			}
			
			if(d.hasOwnProperty("htmlText") == true){
				d["htmlText"] = value;
			}else if(d.hasOwnProperty("data") == true){
				d["data"] = value;
			}
		}
		
		
		public function set data(value:Object):void{
			inited = false
			_data = value;
			if(_data && addToStaged){
				doData()
				inited = true
			}
		}
		
		public function get data():Object{
			return _data;
		}
		
		protected function doData():void{
		}
		
		public function set enabled(value:Boolean):void{
			if(_enabled == value){
				return;
			}
			_enabled = value;
			doEnabled()
		}
		
		public function get enabled():Boolean{
			return _enabled
		}
		
		protected function doEnabled():void{
			
		}
		
		protected function toStageHandler(event:Event):void{
			if(event.type == Event.ADDED_TO_STAGE){
				addToStaged = true;
				if(_data && inited == false){
					doData();
				}
				addToStage()
			}else{
				addToStaged = false;
				removeFromStage();
			}
		}
		
		protected function addToStage():void{
			
		}
		
		protected function removeFromStage():void{
			
		}
		
		protected function setSkinColorNULL(value:Boolean):void{
			ColorUtils.setToGray(this,value);
		}
		
		public function createBoxLayer(
			boxname:String,
			layer:int,
			_skin:DisplayObjectContainer=null,
			boxType:String = LayoutType.HORIZONTAL,
			directionFlag:Boolean = false,
			hAlign:String = LayoutType.LEFT,
			vAlign:String=LayoutType.MIDDLE
		):DisplayObject{
			var box:Box = new Box(boxType,directionFlag,_skin);
			box.hAlign = LayoutType.LEFT;
			box.vAlign = LayoutType.MIDDLE;
			return addDisplayObjectToLayer(boxname,box,layer);
		}
		
		public function addDisplayObjectToLayer(name:String,_skin:DisplayObject,layer:int):DisplayObject{
			if(!layerDict){
				layerDict = new Dictionary();
			}
			layerDict[name] = _skin;
			_skin.addEventListener(LayoutEvent.RESIZE,_skinrefreshHandelr);
			_skin.addEventListener(LayoutEvent.BUILD,_skinrefreshHandelr);
			if(layer > this.numChildren){
				layer = this.numChildren
			}
			this.addChildAt(_skin,layer);
			return _skin;
		}
		
		public function removeDisplayObject(name:String):void{
			var _skin:DisplayObject = layerDict[name]
			if(_skin == null){
				return;
			}
			_skin.removeEventListener(LayoutEvent.RESIZE,_skinrefreshHandelr);
			_skin.removeEventListener(LayoutEvent.BUILD,_skinrefreshHandelr);
			if(this.contains(_skin)){
				this.removeChild(_skin);
			}
		}
		
		public function getDisplayObjectByLayerName(name:String):DisplayObject{
			return layerDict[name]
		}
		
		public function addChildDisplayObject(name:String,displayObject:DisplayObject):void{
			var displayObjectContainer:DisplayObjectContainer = layerDict[name];
			if(displayObjectContainer != null){
				displayObjectContainer.addChild(displayObject);
			}
		}
		
		private function _skinrefreshHandelr(event:LayoutEvent):void{
			var num:Number = numChildren;
			var target:DisplayObject = event.target as DisplayObject
			if(_intRectangle && _intRectangle.width < 0 ){
				_maxWidth = Math.max(_maxWidth,this.width);
			}
			if(_intRectangle && _intRectangle.height < 0){
				_maxHeight = Math.max(_maxHeight,this.height);
			}
			while(num--){
				var active:SkinInteractiveBase = getChildAt(num) as SkinInteractiveBase;
				if(active == null){
					continue;
				}
				active.refresh(intRectangle,_maxWidth,_maxHeight);
			}
			itemResizeHandelr();
			this.dispatchEvent(event);
		}
		
		public function get intRectangle():IntRectangle{
			if(_intRectangle == null){
				return null;
			}
			_intRectangle.width = this.width;
			_intRectangle.height = this.height;
			_intRectangle.x = this.x;
			_intRectangle.y = this.y;
			return _intRectangle;
		}
		
		protected var intRectangleFlag:Boolean = false
		public function set intRectangle(value:IntRectangle):void{
			if(value){
				intRectangleFlag = true;
				_intRectangle = value;
				bulidflag = true;
			}
		}
		
		override protected function bulid():void{
			for each(var d:DisplayObject in childrens){
				if(d.width == 0 || d.height == 0){
					return;
				}

				if(d.hasOwnProperty("intRectangle")){
					d['intRectangle'] = _intRectangle;
				}
				
				if(d is SkinInteractiveBase){
					(d as SkinInteractiveBase).refresh(_intRectangle,_maxWidth,_maxHeight);
				}
			}
			
			itemResizeHandelr();
		}
		
		protected function itemResizeHandelr():void{
			for each(var d:DisplayObject in childrens){
				if(d.width == 0 || d.height == 0){
					return;
				}

				var focusPoint:IntPoint = new IntPoint()
				if(d.hasOwnProperty("focusPoint")){
					focusPoint = d["focusPoint"]
				}
				if(d.hasOwnProperty("vParentAlign")  && d["vParentAlign"] != LayoutType.ABSOLUTE){
					doLayout(d,d["vParentAlign"],focusPoint);
				}else{
					doLayout(d,_vAlign,focusPoint);
				}
				
				if(d.hasOwnProperty("hParentAlign") && d["hParentAlign"] != LayoutType.ABSOLUTE){
					doLayout(d,d["hParentAlign"],focusPoint);
				}else{
					doLayout(d,_hAlign,focusPoint);
				}
			}
		}
		
		
		protected function doLayout(d:DisplayObject,align:String,focusPoint:IntPoint):void{
			var width:Number = this.width;
			var heiht:Number = this.height;
			var dw:Number = d.width;
			var dh:Number = d.height;
			switch(align){
				case LayoutType.TOP:
					d.y = 0;
				break;
				case LayoutType.CENTER:
					d.y = (heiht - dh)/2;
				break;
				case LayoutType.BOTTOM:
					d.y = heiht - dh;
				break;
				case LayoutType.LEFT:
					d.x = 0;	
				break;
				case LayoutType.MIDDLE:
					d.x = (width - dw)/2
				break;
				case LayoutType.RIGHT:
					d.x = width - dw
				break;
			}
			
			d.x += focusPoint.x;
			d.y += focusPoint.y;
		}
		
		override protected function updataChild(child:DisplayObject):void{
			
			if(_intRectangle && _intRectangle.width >0){
				_maxWidth = _intRectangle.width;
			}else{
				var width:Number = child.width
				if(width>_maxWidth) {
					_maxWidth = width;
				}
			}
			
			if(_intRectangle && _intRectangle.height >0){
				_maxHeight = _intRectangle.height
			}else{
				var height:Number = child.height;
				if(height>_maxHeight) {
					_maxHeight = height;
				}
			}
			
			currentWidth = _maxWidth
			currentHeight = _maxHeight
		}
		
		
		override public function set width(value:Number):void{
			if(!_intRectangle) {
				_intRectangle = new IntRectangle(0,0,-1,-1)
			}
			this._intRectangle.width = value;
			intRectangle = _intRectangle
		}
		
		override public function set height(value:Number):void{
			if(!_intRectangle) {
				_intRectangle = new IntRectangle(0,0,-1,-1)
			}
			this._intRectangle.height = value;
		 	intRectangle = _intRectangle
		}
		
		override public function get width():Number{
			if(!_intRectangle || _intRectangle.width <0){
				return super.width;
			}
			return _intRectangle.width;
			
		}
		
		override public function get height():Number{
			if(!_intRectangle || _intRectangle.height <0){
				return super.height;
			}
			return _intRectangle.height;
			
		}
	}
}