package com.display.skin
{
	import com.display.Container;
	import com.display.LayoutType;
	import com.display.event.LayoutEvent;
	import com.display.utils.geom.IntRectangle;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;

	public class SkinInteractiveBase extends Sprite
	{
		/**
		 * skin type 
		 * 
		 */ 
		protected var skin:Object
		protected var actives:Object;
		protected var currentshowtype:String;
		protected var defaultImage:DisplayObject;
		
		protected var currentImage:DisplayObject
		
		protected var intRectangle:IntRectangle;
		
		public function SkinInteractiveBase(skin:Object=null,actives:Object=null)
		{
			this.skin = skin;
			initSkin()
			if(defaultImage)
				refresh()
		}
		
		public function reset(defaultImage:DisplayObject,mouseover:Object = null,selected:Object = null,mouseoverselected:Object = null,disabledDefault:Object = null,disabledselected:Object = null,disabledmouseover:Object = null,disabledselectedmouseover:Object = null):void{
			if(!defaultImage){
				return;
			}
			
			reset2([defaultImage,
			mouseover,
			selected,
			mouseoverselected,
			disabledDefault,
			disabledmouseover,
			disabledselected,
			disabledselectedmouseover])
		}
		
		protected function reset2(images:Array):void{
			if(!images){
				return;
			}
			var imgtypes:Array = ["skin001","skin101","skin011","skin111","skin000","skin100","skin010","skin110"]
			var num:int = images.length;
			if(!actives){
				actives = {}
			}
			for (var i:int = 0;i<num;i++){
				actives[imgtypes[i]] = images[i];
			}
			
			var d:DisplayObject= actives["skin001"]
			if(d){
				defaultImage = d;
			}
		}
		
		/**
		 * skin001 : default
		 * skin000 : defaultDisabled
		 * 
		 * skin101 : mouseover
		 * skin100 : mouseoverDisabled
		 * 
		 * skin011 : selected
		 * skin010 : selectedDisabled
		 * 
		 * skin111 : mouseover-selected
		 * skin110 : mouseover-selected-disabled
		 */ 
		
		public var mouseover:Boolean;
		public var selected:Boolean;
		public var enabled:Boolean = true;
		protected var refreshFlag:Boolean
		
		protected function initSkin():void{
			if(skin is IEventDispatcher){
				(skin as IEventDispatcher).addEventListener(LayoutEvent.BUILD,layoutHadnelr);
			}
			if(skin is MovieClip){
				defaultImage = skin as DisplayObject
				if(actives == null){
					actives = [1,2,3,4,5,6,7,8];
				}else if(actives is Object){
					return;
				}
				reset2(actives as Array);
			}else if(skin is Array){
				reset2(skin as Array);
			}else if(skin is DisplayObject){
				if(actives == null){
					reset(skin as DisplayObject)
				}
			}else if(skin is Object && actives == null){
				actives = skin;
			}
		}
		
		public function refresh(intRectangle:IntRectangle = null,width:Number = -1, height:Number = -1):void{
			if(intRectangle != null){
				this.intRectangle = intRectangle.clone()
				if(width>-1 && intRectangle.width<0){
					this.intRectangle.width = width;
				}
				if(height>-1 && intRectangle.height<0){
					this.intRectangle.height = height;
				}
			}
			
			if(getActive() == currentshowtype &&
			 (this.intRectangle!=null && 
			 (this.width == width && this.height == height))){
				return;
			}
			
			//call late
//			if(refreshFlag == true){
//				return;
//			}
//			this.addEventListener(Event.ENTER_FRAME,enterframehandler);
//			refreshFlag = true;
			doRefresh();
		}
		
		protected function enterframehandler(event:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,enterframehandler);
			refreshFlag = false;
			doRefresh();
		}
		
		protected function getActive():String{
			var m:String = mouseover ? "1" : "0";
			var s:String = selected ? "1" : "0";
			var e:String = enabled ? "1" : "0";
			return "skin"+m+s+e;
		}
		
		protected function doRefresh():void{
			var active:String = getActive();
			
			if(currentshowtype == active){
				resize(currentImage)
				return;
			}
			
			remove(currentshowtype);
			
			if(actives.hasOwnProperty(active)){
				add(active)
			}
			
//			trace(active)
		}
		
		protected function remove(active:String):void{
			var o:Object = actives[active];
			if(o is DisplayObject){
				if(this.contains(o as DisplayObject)){
					this.removeChild(o as DisplayObject);
				}
			}else{
				add("skin001");
			}
		}
		
		protected function add(active:String):void{
			var o:Object = actives[active];
			if(o is DisplayObject){
				currentshowtype = active;
				currentImage = o as DisplayObject
				resize(currentImage)
//				o.x = intRectangle.x
//				o.y = intRectangle.y
//				intRectangle.width >-1 ? o.width = intRectangle.width : 0
//				intRectangle.height >-1 ? o.height = intRectangle.height : 0;
				this.addChild(o as DisplayObject);
			}else if(o is Number){
				if(defaultImage){
					if(this.contains(defaultImage) == false){
						this.addChild(defaultImage);
					}
					(defaultImage as MovieClip).gotoAndStop(o);
				}
			}else if (o == null){
				if(active != "skin001")
					add("skin001")
			}
		}
		
		protected function getSkin(alpha:Number,color:int = 0xFBFBFB):Shape{
			var s:Shape = new Shape()
			s.name = alpha +" : " + color;
			s.graphics.beginFill(color,alpha);
			s.graphics.drawRect(0,0,1,1)
			s.graphics.endFill();
			return s;
		}
		
		
		private function layoutHadnelr(event:LayoutEvent):void{
			this.dispatchEvent(/*new LayoutEvent(LayoutEvent.RESIZE)*/ event);
		}
		private var time:int = getTimer();
		protected function resize(d:DisplayObject):void{
			if(!intRectangle){
				return;
			}
			
			d.x = intRectangle.x;
			d.y = intRectangle.y;
			
			if(intRectangle.width == d.width && intRectangle.height == d.height){
				return;
			}
			
			if(intRectangle.width>0){
				d.width = intRectangle.width
			}else{
//				intRectangle.width = d.width;
			}
			if(intRectangle.height>0){
				d.height = intRectangle.height
			}else{
//				intRectangle.height = d.height
			}
			if((d is Container) == false){
				this.dispatchEvent(new LayoutEvent(LayoutEvent.RESIZE));
			}
		}
		
		
		
		//--------------------------------------
//		public function set hgap(value:int):void{
//			if(skin.hasOwnProperty("hgap")){
//				skin["hgap"] = value;
//			}else{
////				super.hgap = value;
//			}
//		}

//		override public function get width():Number{
//			return currentImage ? currentImage.width : 0;
//		}
//		
//		override public function get height():Number{
//			return currentImage ? currentImage.height : 0;
//		}
		
		public function get hgap():int{
			if(skin.hasOwnProperty("hgap")){
				return skin["hgap"];
			}else{
//				return _hgap
			}
			return 0;
		}
		
		//---------------------------------------
//		public function set vgap(value:int):void{
//			if(skin.hasOwnProperty("vgap")){
//				skin["vgap"] = value;
//			}else{
////				super.vgap = value;
//			}
//		}
		
		public function get vgap():int{
			if(skin.hasOwnProperty("vgap")){
				return skin["vgap"];
			}else{
//				return _vgap
			}
			return 0
		}
		
		//---------------------------------------
//		public function set hParentAlign(value:String):void{
//			if(skin.hasOwnProperty("hParentAlign")){
//				skin["hParentAlign"] = value;
//			}else{
////				super.hParentAlign = value;
//			}
//		}
		
		public function get hParentAlign():String{
			if(skin.hasOwnProperty("hParentAlign")){
				return skin["hParentAlign"];
			}else{
//				return _hParentAlign
			}
			
			return LayoutType.ABSOLUTE
		}
		
		//---------------------------------------
//		public function set vParentAlign(value:String):void{
//			if(skin.hasOwnProperty("vParentAlign")){
//				skin["vParentAlign"] = value;
//			}else{
////				super.vParentAlign = value;
//			}
//		}
		
		public function get vParentAlign():String{
			if(skin.hasOwnProperty("vParentAlign")){
				return skin["vParentAlign"];
			}else{
//				return _vParentAlign
			}
			return LayoutType.ABSOLUTE
		}
		
		//---------------------------------------
//		public function set vAlign(value:String):void{
//			if(skin.hasOwnProperty("vAlign")){
//				skin["vAlign"] = value;
//			}else{
////				super.vAlign = value;
//			}
//		}
		
		public function get vAlign():String{
			if(skin.hasOwnProperty("vAlign")){
				return skin["vAlign"];
			}else{
//				return _vAlign
			}
			return LayoutType.ABSOLUTE
		}
		
		//---------------------------------------
//		public function set hAlign(value:String):void{
//			if(skin.hasOwnProperty("hAlign")){
//				skin["hAlign"] = value;
//			}else{
//				super.hAlign = value;
//			}
//		}
		
		public function get hAlign():String{
			if(skin.hasOwnProperty("hAlign")){
				return skin["hAlign"];
			}else{
//				return _hAlign
			}
			return LayoutType.ABSOLUTE
		}
		
		//---------------------------------------
//		public function set layout(value:String):void{
//			if(skin.hasOwnProperty("layout")){
//				skin["layout"] = value;
//			}else{
//				super.layout = value;
//			}
//		}
		
		public function get layout():String{
			if(skin.hasOwnProperty("layout")){
				return skin["layout"];
			}else{
//				return _hAlign
			}
			return LayoutType.ABSOLUTE
		}
	}
}
