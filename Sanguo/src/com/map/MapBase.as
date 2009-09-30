package com.map
{
	import com.display.event.LayoutEvent;
	import com.display.tween.Tween;
	import com.display.tween.TweenEvent;
	import com.display.utils.DisplayObjectUtils;
	import com.map.vo.MapItemVO;
	import com.youbt.events.RFLoaderEvent;
	import com.youbt.net.RFStreamLoader;
	import com.youbt.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class MapBase extends EventDispatcher
	{
		protected var mapData:MapDataBase
		protected var mapRender:MapRenderBase
		protected var bgmapurl:String;
		protected var mapSkin:Sprite;
		protected var mapbgSkin:Sprite;
		protected var mapItemSkin:Sprite;
		protected var debugSkin:Sprite;
		protected var itemDict:Dictionary
		protected var el:Number = 0;
		protected var rl:int = 0;
		protected var cl:int = 0;
		protected var currentRect:Rectangle
		protected var mapMoveTween:Tween;
		protected var mapDisplayDataFilter:MapDisplayDataFilter
		
		protected var chindrens:Array;
		protected var currentX:int;
		protected var currentY:int;
		public function MapBase(mapdata:MapDataBase,mapRender:MapRenderBase = null,bgmapurl:String = null)
		{
			
			
			mapSkin = new Sprite();
			mapItemSkin = new Sprite();
			mapbgSkin = new Sprite();
			debugSkin = new Sprite();
			itemDict = new Dictionary();
			chindrens = [];
			
			
			mapSkin.addChild(mapbgSkin);
			mapSkin.addChild(debugSkin);
			mapSkin.addChild(mapItemSkin);
			mapSkin.x = 40;
			mapSkin.y = 40;
			
			setMapdata(mapdata)
			mapRender = mapRender;
			
			this.bgmapurl = bgmapurl;
			updataImage(bgmapurl);
			
			debugSkin.addEventListener(MouseEvent.CLICK,debugSkinclickHandler);
			
			init();
			
			
		}
		
		protected function init():void{
			mapMoveTween = new Tween();
			mapMoveTween.setEffectType(1,0.4);
			
			mapDisplayDataFilter = new MapDisplayDataFilter();
		}
		
		public function setMapdata(mapdata:MapDataBase,moveMap:Boolean = false):void{
			if(mapdata == null){
				return;
			}
			if(this.mapData){
				this.mapData.removeEventListener(MapDataEvent.UP_DATA,mapDataHandler);
			}
			
			var mapdatavo:MapDataVO =  mapdata.mapdatavo
			
			el =mapdatavo.eachLength;
			
			var arr:Array = mapdata.mapData[0]
			if(!arr){
				throw new Error("fuck")
			}
			rl = arr.length
			cl = mapdata.mapData.length
			
			this.mapData = mapdata;
			this.mapData.addEventListener(MapDataEvent.UP_DATA,mapDataHandler);
			
			
			var w:int = mapdatavo.width;
			var h:int = mapdatavo.height;
			
			if(moveMap || graphicsed == false)
				setShowArea(w,h,true);
			
			resetMapItemLayer();
		}
		
		protected function resetMapItemLayer():void{
			var num:int = mapItemSkin.numChildren;
			while(num--){
				updataItemXY(mapItemSkin.getChildAt(num));
			}
		}
		
		protected function mapDataHandler(event:MapDataEvent):void{
			mapRender.setMapdata(event.data as MapDataBase);
		}
		
		public function updataImage(bgurl:String):void{
			if(bgurl == null){
				return;
			}
//			var token:RemoteToken = SWLoadStaticFunction.SWSwfLoader(bgurl);
			var loader:RFStreamLoader = new RFStreamLoader(bgurl)
			loader.addEventListener(RFLoaderEvent.COMPLETE,bgRefreshHandder);
			loader.load();
		}
		
		protected function bgRefreshHandder(event:RFLoaderEvent):void{
			DisplayObjectUtils.clear(mapbgSkin);
			var loader:Loader = event.result as Loader;
			if(loader){
				mapbgSkin.addChild(loader.content);
//				mapbgSkin.scrollRect = rect;
			}
			
			
			//test
//			var width:int = loader.width/48;
//			var height:int = loader.height/48;
			
			
		}
		
		private var graphicsed:Boolean
		private var rect:Rectangle
		public function setShowArea(wCount:int,hCount:int,debugMode:Boolean = true):void{
			var mapdatavo:MapDataVO = mapData.mapdatavo
			rect = new Rectangle();
			rect.x = mapdatavo.x*el;
			rect.y = mapdatavo.y*el;
			rect.width = wCount*el;
			rect.height = hCount*el;
//			rect = new Rectangle(s.x*el,s.y*el,wCount*el,hCount*el)

			moveMap(rect);
			
			if(debugMode && graphicsed == false){
				var gr:Graphics = debugSkin.graphics;
				gr.clear();
				gr.beginFill(0,0);
				gr.lineStyle(2,0xFFFFFF,0.5);
				var i:int=0
				for(i;i<=hCount;i++){
					gr.moveTo(0,i*el)
					gr.lineTo(wCount*el,i*el);
				}
				
				for(i=0;i<=wCount;i++){
					gr.moveTo(i*el,0)
					gr.lineTo(i*el,hCount*el);
				}
				gr.endFill();
				graphicsed = true
			}
		}
		
		
		protected function moveMap(rect:Rectangle,duration:int = 500):void{
//			currentRect
			if(!currentRect){
				currentX = mapData.mapdatavo.x;
				currentY = mapData.mapdatavo.y;
				doMoveMap(rect)
			}else{
				mapMoveTween.target = currentRect;
				mapMoveTween.addEventListener(TweenEvent.TWEEN_UPDATE,mapmovetweenHandler);
				mapMoveTween.addEventListener(TweenEvent.TWEEN_END,mapmovetweenHandler);
				mapMoveTween.initAIEffect2(currentRect,rect,"x","y","width","height");
				mapMoveTween.duration = duration;
				mapMoveTween.play();
				
			}
		}
		
		
		private function mapmovetweenHandler(event:TweenEvent):void{
			if(event.type == TweenEvent.TWEEN_END){
				mapMoveTween.removeEventListener(TweenEvent.TWEEN_UPDATE,mapmovetweenHandler);
				mapMoveTween.removeEventListener(TweenEvent.TWEEN_END,mapmovetweenHandler);
			}	
			
			doMoveMap(mapMoveTween.target as Rectangle)
		}
		
		protected function doMoveMap(rect:Rectangle):void{
			if(!rect){
				return;
			}
			currentRect = rect;
			mapSkin.scrollRect = rect;
//			mapItemSkin.scrollRect = rect;
			
			var p:Point = getXYByItemSkinXY(currentRect.x,currentRect.y)
			if(currentX != p.x || currentY != p.y){
				currentX = p.x;
				currentY = p.y;
//				trace(currentX,currentY)
				var mapdatavo:MapDataVO = mapData.mapdatavo
				mapdatavo.x = currentX;
				mapdatavo.y = currentY
				var arr:Array = mapDisplayDataFilter.getDatas(chindrens,rl,currentX-1,currentY-1,mapdatavo.width+1,mapdatavo.height+1);
				removeOtherDisplayObject(arr);
				addNewDisplayObject(arr);
			}
			
			var gr:Graphics = debugSkin.graphics;
			gr.clear();
			gr.lineStyle(2,0xFFFFFF,0.5);
			var i:int=0
			var w:int = mapData.mapdatavo.width+2
			var h:int = mapData.mapdatavo.height+2
			for(i=0;i<=h;i++){
				gr.moveTo((currentX-1)*el,(i+currentY)*el)
				gr.lineTo((w+currentX)*el,(i+currentY)*el);
			}
			
			for(i=0;i<=w;i++){
				gr.moveTo((i+currentX)*el,(currentY-1)*el)
				gr.lineTo((i+currentX)*el,(h+currentY)*el);
			}
			
			gr.beginFill(0,0);
			gr.drawRect((currentX-1)*el,(currentY-1)*el,(w+currentX)*el,(h+currentY)*el)
			gr.endFill();
			graphicsed = true
		}
		
		//  	4 5	6
		//		3 0	7
		//		2 1	8
		protected const RADIAN:Number = Math.PI/180;
		public function moveBydirection(direction:int,moveStep:int = 10):void{
			var xstep:Number
			var ystep:Number
			var r:Number = RADIAN*(90+(direction-1)*45);
			xstep = Math.cos(r)*moveStep;
			ystep = Math.sin(r)*moveStep;
			
			rect.x += xstep;
			rect.y += ystep;
			
			if(rect.x<0){
				rect.x = 0
			}
			
			if(rect.y<0){
				rect.y=0
			}
			
			if((rect.x + rect.width) > el*rl){
				rect.x=el*rl - rect.width
			}
			
			if((rect.y + rect.height) > el*cl){
				rect.y=el*cl - rect.height
			}
			
			doMoveMap(rect);
			
		}
		
		protected function removeOtherDisplayObject(arr:Array):void{
			var num:int = mapItemSkin.numChildren
			while(num--){
				var d:DisplayObject = mapItemSkin.getChildAt(num);
				if(ArrayUtil.has(arr,d) == false){
					mapItemSkin.removeChild(d);
				}
			}
		}
		
		protected function addNewDisplayObject(arr:Array):void{
			for each(var item:DisplayObject in arr){
				if(mapItemSkin.contains(item) == false){
					updataItemXY(item);
					mapItemSkin.addChild(item);
				}
			}
		}
		
		protected function getXYByItemSkinXY(x:Number,y:Number):Point{
			return new Point(int(Math.round(x/el)),int(Math.round(y/el)));
		}
		
		protected function getXYByItemSkinXY2(x:Number,y:Number):Point{
			return new Point(int(x/el),int(y/el));
		}
		
		public function addChild(item:DisplayObject,x:int = 0,y:int = 0,forceShow:Boolean = false):void{
			
			if(item == null){
				return;
			}
			
			var vo:MapItemVO = itemDict[item];
			if(vo!=null){
				chindrens[vo.x*rl+vo.y] = null
				delete chindrens[vo.x*rl+vo.y]
			}
			
			chindrens[x*rl+y] = item;
			
			if(checkInShowArea(x,y) == false){
				if(forceShow == false){
					return;
				}else if(mapData.showCenterXY(x,y) == false){
					return;
				}
			}
			itemDict[item] = new MapItemVO(item,x,y)
			
			item.addEventListener(LayoutEvent.BUILD,bulidHandler);
			
			
			if(checkInShowArea(x,y) == true){
				updataItemXY(item)
				mapItemSkin.addChild(item);
			}
		}
		
		public function resetItemXY(item:DisplayObject,x:int,y:int):void{
			if(item == null){
				return;
			}
			
			var vo:MapItemVO = itemDict[item];
			if(vo!=null){
				chindrens[vo.x*rl+vo.y] = null
				delete chindrens[vo.x*rl+vo.y]
			}
			
			chindrens[x*rl+y] = item;
			vo.x = x;
			vo.y = y;
			
			if(checkInShowArea(x,y) == true){
				if(mapItemSkin.contains(item) == false){
					mapItemSkin.addChild(item);
				}
			}else{
				if(mapItemSkin.contains(item) == true){
					mapItemSkin.removeChild(item);
				}
			}
		}
		
		public function removeChild(item:DisplayObject):void{
			if(item == null){
				return;
			}
			var vo:MapItemVO = itemDict[item];
			if(vo == null){
				return;
			}
			var temp:int = vo.x*rl+vo.y
			if(chindrens[temp] == item){
				chindrens[temp] = null
				delete chindrens[temp]
			}
			
			if(mapItemSkin.contains(item)){
				mapItemSkin.removeChild(item);
			}
		}
		
		protected function bulidHandler(event:LayoutEvent):void{
			updataItemXY(event.currentTarget as DisplayObject)
		}
		
		protected function updataItemXY(item:DisplayObject):void{
			var vo:MapItemVO = itemDict[item]
			if(vo == null) return;
			var x:int = vo.x;
			var y:int = vo.y;
			var arr:Array = getRealXYbyMapXY(x,y)
			item.x = -item.width/2 + arr[0] + el/2
			item.y = arr[1] + el - item.height; 
		}
		
		protected function getRealXYbyMapXY(x:int,y:int):Array{
//			var s:Point = mapData.mapdatavo.startPoint;
			var offsetx:int = x //- s.x;
			var offsety:int = y //- s.y;
			return [offsetx*el,offsety*el]
		}
		
		protected function check(x:int,y:int):Boolean{
			var mapdatavo:MapDataVO = mapData.mapdatavo;
			if(x<mapdatavo.x || y<mapdatavo.y || x>mapdatavo.x+mapdatavo.width || y>mapdatavo.y+mapdatavo.height){
				return false;
			}
			return true
		}
		
		
		public function find(item:DisplayObject,x:int,y:int):Array{
			var vo:MapItemVO = itemDict[item]
			if(vo==null){
				return []
			}
			var arr:Array= mapData.find(vo.x,vo.y,x,y)
			if(arr)
				arr.unshift([0,vo.x,vo.y,0]);
			return arr;
		}
		
		
		
		public function getView():DisplayObject{
			return mapSkin;
		}
		
		
		protected function debugSkinclickHandler(event:Event):void{
			var x:Number = debugSkin.mouseX;
			var y:Number = debugSkin.mouseY;
			var realPoint:Point=new Point(x,y);
			var mapPoint:Point=getXYByItemSkinXY2(x,y);
			this.dispatchEvent(new MapDataEvent(MapDataEvent.MAP_CLICK,{realPoint:realPoint,mapPoint:mapPoint,el:el}))
		}
		
		protected function checkInShowArea(x:int,y:int):Boolean{
			return mapData.mapdatavo.checkInThis(x,y);
		}
	}
}
	import flash.display.DisplayObject;
	

