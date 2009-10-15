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
		public function Container(_skin:DisplayObjectContainer = null)
		{
			super();
			_focusPoint = new IntPoint(0,0);
			addToStaged = false;
			inited = false;
			dict = new Dictionary()
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
					this.addDisplayObjectToLayer("skin",_skin,1);
				}
			}
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
			layerDict[name] = _skin;
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
			while(num--){
				var active:SkinInteractiveBase = getChildAt(num) as SkinInteractiveBase;
				if(active == null){
					continue;
				}
				active.refresh(intRectangle);
			}
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
			intRectangleFlag = true;
			if(value){
				_intRectangle = value;
				bulidflag = true;
			}
		}
		
		override protected function bulid():void{
//			switch(_vAlign){
//				case LayoutType.TOP:
//					
//				break;
//				case LayoutType.CENTER:
//				break;
//				case LayoutType.BOTTOM:
//				break;
//			}
//			
//			switch(_hAlign){
//				case LayoutType.LEFT:
//				break;
//				case LayoutType.MIDDLE:
//				break;
//				case LayoutType.RIGHT:
//				break;
//			}
		}
		
		override protected function updataChild(child:DisplayObject):void{
			
			if(_intRectangle){
				_maxWidth = _intRectangle.width;
				_maxHeight = _intRectangle.height
			}else{
				var height:Number = child.height;
				var width:Number = child.width
				if(height>_maxHeight) {
					_maxHeight = height;
				}
				if(width>_maxWidth) {
					_maxWidth = width;
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
			bulidflag = true
		}
		
		override public function set height(value:Number):void{
			if(!_intRectangle) {
				_intRectangle = new IntRectangle(0,0,-1,-1)
			}
			this._intRectangle.height = value;
			bulidflag = true
		}
	}
}