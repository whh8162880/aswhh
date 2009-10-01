package com.display.button
{
	import com.display.Box;
	import com.display.LayoutType;
	
	import flash.display.DisplayObjectContainer;

	public class ButtonBase extends Box
	{
		public function ButtonBase(skin:Object=null,type:String=LayoutType.HORIZONTAL, directionFlag:Boolean=false)
		{
			this.useHandCursor = true;
			this.buttonMode = true;
			super(type, directionFlag,getUseSkin(skin));
		}
		
		override protected function doEnabled():void{
			this._enabled ? addListener() : removeListener();
			setSkinColorNULL(_enabled);
		}
		
		protected function getUseSkin(_skin:Object):DisplayObjectContainer{
			
			return null;
		}
		
		protected function addListener():void{
			
		}
		
		protected function removeListener():void{
			
		}
		
		override protected function createSkin():void{
			
		}
		
		
	}
}










