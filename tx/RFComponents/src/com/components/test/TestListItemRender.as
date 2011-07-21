package com.components.test
{
	import flash.display.Sprite;
	
	import rfcomponents.list.itemrender.ListItemRender;
	
	public class TestListItemRender extends ListItemRender
	{
		public function TestListItemRender()
		{
			create(100,20);
		}
		
		override protected function doData():void{
			label = _data.toString();
		}
		
		override protected function renderFace():void{
			
		}
	}
}