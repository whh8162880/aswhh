package com.display.button
{
	import com.display.Container;
	import com.display.LayoutType;
	import com.display.skin.SkinInteractiveBase;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;

	public class ButtonBase extends Container
	{
		protected var skinInteractive:SkinInteractiveBase
		protected var onlySkin:Boolean = false
		public function ButtonBase(skin:Object=null,type:String=LayoutType.HORIZONTAL, directionFlag:Boolean=false)
		{
			this.useHandCursor = true;
			this.buttonMode = true;
			super(getUseSkin(_skin));
		}
		
		override protected function doEnabled():void{
			this._enabled ? addListener() : removeListener();
			skinInteractive.enabled = _enabled;
			skinInteractive.refresh();
			if(onlySkin){
				setSkinColorNULL(_enabled);
			}
		}
		
		protected function getUseSkin(_skin:Object):DisplayObjectContainer{
			if(_skin is SkinInteractiveBase){
				onlySkin = false;
				skinInteractive =  _skin as SkinInteractiveBase
			}else{
				onlySkin = true;
				skinInteractive =  new SkinInteractiveBase(_skin);
			}
			return skinInteractive;
		}
		
		protected function addListener():void{
			this.addEventListener(MouseEvent.ROLL_OVER,rollHandelr);
			this.addEventListener(MouseEvent.ROLL_OUT,rollHandelr);
		}
		
		protected function removeListener():void{
			this.removeEventListener(MouseEvent.ROLL_OVER,rollHandelr);
			this.removeEventListener(MouseEvent.ROLL_OUT,rollHandelr);
		}
		
		override protected function createSkin():void{
			
		}
		
		
		protected function rollHandelr(event:MouseEvent):void{
			var mouseover:Boolean = (event.target == MouseEvent.ROLL_OVER);
			skinInteractive.mouseover = mouseover;
			skinInteractive.refresh();
		}
		
		
	}
}










