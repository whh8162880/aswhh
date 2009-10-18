package com.display.panel
{
	import com.display.Box;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class PanelMoveArea extends Box
	{
		protected var panel:DisplayObject;
		public function PanelMoveArea(panel:DisplayObject,type:String=LayoutType.HORIZONTAL, directionFlag:Boolean=false, _skin:DisplayObjectContainer=null)
		{
			this.panel = panel;
			super(type, directionFlag, _skin);
			
		}
		
//		public function addMoveArea
		
	}
}