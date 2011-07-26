package com.theworld.module.txmap
{
	import com.map.MapModel;
	import com.mvc.Controller;
	import com.net.request.utils.LoaderType;
	import com.theworld.core.CoreGlobal;
	import com.theworld.module.txmap.itemrender.TXMapItemRender;
	import com.theworld.module.txmap.view.TXMapView;
	import com.utils.ResourceManager;
	
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import rfcomponents.SkinBase;
	
	public class TXMapController extends Controller
	{
		public function TXMapController(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var view:TXMapView;
		private var model:MapModel;
		private var itemw:int = 120;
		private var itemh:int = 100;
		private var eachw:int = 10;
		private var eachh:int = 10;
		
		override protected function doSetView(view:SkinBase):void{
			this.view = view as TXMapView;
			this.view.addEventListener(Event.CHANGE,viewChangeHandler);
		}
		override protected function doSetModel(model:*):void{
			this.model = model;
			//ResourceManager.requestAsyncResource("txmaprescfg",CoreGlobal.mappath+"maprescfg.dat",LoaderType.STREAM,maprescfgloaderHandler);
		}
		
		
		
		public function initSceneSize(w:int,h:int):void{
			view.setConfig(w,h,itemw,itemh);
			viewChangeHandler();
			view.edits.length = 0;
		}
		
		private function viewChangeHandler(event:Event = null):void{
			var render:TXMapItemRender
//			for each(render in view.removes){
//				render.clear();
//			}
			
			for each(render in view.edits){
				render.rendermap(eachw,eachh);
				//renderMapItemRender(render,render.offsetx,render.offsety,render.width,render.height);
				//render.rendermap();
			}
		}
		
		public function getpoint(x:int,y:int):Array{
			return [x/eachw,y/eachh];
		}
		
		public function getPointArea(x:int,y:int,w:int,h:int):Array{
			return [x/eachw,y/eachh,(x+w)/eachw,(y+h)/eachh];
		}
		
		public function renderMapItemRender(g:SkinBase,x:int,y:int,w:int,h:int):void{
			g.skin.graphics.clear();
			
			w = (x+w)/eachw;
			h = (y+h)/eachh;
			x /= eachw;
			y /= eachh;
			var i:int,j:int
			for(i=x;i<w;i++){
				for(j=y;j<h;j++){
					addToRenderlist(g,i,j,i-x,j-y);
				}
			}
		}
		
		private var renderDict:Dictionary = new Dictionary();
		public function addToRenderlist(skin:SkinBase,x:int,y:int,dx:int,dy:int):void{
			if(!renderDict[skin]){
				renderDict[skin] = [];
			}
			renderDict[skin].push(skin,x,y);
		}
		
		
		private function renderxy(skin:SkinBase,x:int,y:int,i:int,j:int):void{
			var g:Graphics = skin.skin.graphics;
			
		}
	}
}
