package com.theworld.module.txmap
{
	import com.map.MapModel;
	import com.mvc.Controller;
	import com.net.request.utils.LoaderType;
	import com.theworld.core.CoreGlobal;
	import com.theworld.module.txmap.itemrender.TXMapItemRender;
	import com.theworld.module.txmap.view.TXMapView;
	import com.utils.ResourceManager;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
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
		
		override protected function doSetView(view:SkinBase):void{
			this.view = view as TXMapView;
			this.view.addEventListener(Event.CHANGE,viewChangeHandler);
		}
		override protected function doSetModel(model:*):void{
			this.model = model;
			ResourceManager.requestAsyncResource("txmaprescfg",CoreGlobal.mappath+"maprescfg.dat",LoaderType.STREAM,maprescfgloaderHandler);
		}
		
		private function maprescfgloaderHandler(id:String,data:ByteArray):void{
			data.position = 0;
			data.inflate();
			model.setMapres(data.readObject());
			initSceneSize(4,4);
		}
		
		public function initSceneSize(w:int,h:int):void{
			view.setConfig(w,h,itemw,itemh);
			renderMap();
		}
		
		private function viewChangeHandler(event:Event):void{
			
		}
		
		private function renderMap():void{
//			var arr:Array
//			for each(arr in view.removes){
//				model.cancelRender(arr[0],arr[1],arr[2])
//			}
//			
//			for each(arr in view.edits){
//				model.render(arr[0],arr[1],arr[2])
//			}
		}
		
		
		
		
	}
}