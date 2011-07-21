package com.components.test
{
	import flash.display.Sprite;
	
	import rfcomponents.list.itemrender.ListItemRender;
	import rfcomponents.zother.rendermachine.ColorRenderMachine;
	import rfcomponents.zother.rendermachine.RenderMachine;
	
	public class TestListItemRender extends ListItemRender
	{
		public function TestListItemRender()
		{
			create(100,20);
			this.machine = new ColorRenderMachine();
		}
		
		override protected function doData():void{
			label = _data.toString();
		}
	}
}