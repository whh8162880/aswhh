package com.display.skin
{
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
		public var enabled:Boolean;
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
		
		public function refresh(intRectangle:IntRectangle = null):void{
			this.intRectangle = intRectangle;
			//call late
			if(refreshFlag == true){
				return;
			}
			this.addEventListener(Event.ENTER_FRAME,enterframehandler);
			refreshFlag = true;
		}
		
		protected function enterframehandler(event:Event):void{
			this.removeEventListener(Event.ENTER_FRAME,enterframehandler);
			refreshFlag = false;
			doRefresh();
		}
		
		protected function doRefresh():void{
			var m:String = mouseover ? "1" : "0";
			var s:String = selected ? "1" : "0";
			var e:String = enabled ? "1" : "0";
			
			var active:String = "skin"+m+s+e;
			
			if(currentshowtype == active){
				return;
			}
			
			remove(currentshowtype);
			
			if(actives.hasOwnProperty(active)){
				add(active)
			}
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
				resize(o as DisplayObject)
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
			this.dispatchEvent(event);
		}
		private var time:int = getTimer();
		protected function resize(d:DisplayObject):void{
			if(!intRectangle){
				return;
			}
			d.x = intRectangle.x;
			d.y = intRectangle.y;
			if(intRectangle.width>0){
				d.width = intRectangle.width
			}else{
				intRectangle.width = d.width;
			}
			if(intRectangle.height>0){
				d.height = intRectangle.height
			}else{
				intRectangle.height = d.height
			}
		}
	}
}
