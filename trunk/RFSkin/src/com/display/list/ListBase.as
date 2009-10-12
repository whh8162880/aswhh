package com.display.list
{
	import com.display.Box;
	import com.display.Container;
	import com.display.LayoutType;
	import com.display.label.Label;
	import com.display.managers.CreateItemManager;
	import com.display.skin.skins.ListInteractive;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.getTimer;

	public class ListBase extends Box
	{
		protected var SkinClass:Class
		public function ListBase(SkinClass:Class = null,bgSkin:DisplayObjectContainer=null,layoutType:String = LayoutType.VERTICAL)
		{
			if(SkinClass == null){
				SkinClass = Label;
			}
			this.SkinClass = SkinClass;
			super(layoutType,false,bgSkin);
			this.gap = 0;
		}
		
		public function resetSkinClass(SkinClass:Class):void{
			this.SkinClass = SkinClass;
		}
		
		override protected function doData():void{
			removeAll();
			for each(var o:Object in _data){
				createItem(o)
			}
		}
		
		
		protected function removeAll():void{
			for each(var item:DisplayObject in childrens){
				removeItem(item)
			}
		}
		
		protected function removeItem(item:DisplayObject):void{
			CreateItemManager.removeItem(item);
		}
		
		protected function createItem(o:Object):void{
			var item:Container = CreateItemManager.getItem(SkinClass) as Container;
			addChild(item);
			item.data = o;
			addUnder(item)
		}
		
		protected function addUnder(item:Container):void{
			item.addDisplayObjectToLayer("under",new ListInteractive(),0);
		}
		
		private var t:int = getTimer();
		override protected function bulid():void{
			trace(getTimer() - t)
			t = getTimer();
			super.bulid()
		}
		
	}
}