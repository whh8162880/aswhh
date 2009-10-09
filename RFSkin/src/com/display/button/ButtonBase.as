package com.display.button
{
	import com.display.Container;
	import com.display.LayoutType;
	import com.display.skin.SkinInteractiveBase;
	
	import flash.display.DisplayObjectContainer;

	public class ButtonBase extends Container
	{
		public function ButtonBase(skin:Object=null,type:String=LayoutType.HORIZONTAL, directionFlag:Boolean=false)
		{
			this.useHandCursor = true;
			this.buttonMode = true;
			super(getUseSkin(_skin));
		}
		
		override protected function doEnabled():void{
			this._enabled ? addListener() : removeListener();
			setSkinColorNULL(_enabled);
		}
		
		protected function getUseSkin(_skin:Object):DisplayObjectContainer{
			if(_skin is SkinInteractiveBase){
				return _skin as DisplayObjectContainer
			}else{
				return new SkinInteractiveBase(_skin);
			}
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










