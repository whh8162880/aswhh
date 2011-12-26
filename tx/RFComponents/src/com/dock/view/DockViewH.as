package com.dock.view
{
	import com.dock.icon.IDockIcon;
	import com.tween.TweenHelper;
	
	import flash.display.DisplayObject;

	public class DockViewH extends DockView
	{
		public function DockViewH(itemWidth:int)
		{
			super(itemWidth,0);
		}
		
		
		protected var bgw:int;
		protected var bgh:int;
		override public function setSize(w:int, h:int, e:int=0):void{
			bgw = w;
			bgh = h;
			drawbg(w,h);
			this.e = 0;
		}
		
//		override public function tweenTo(icon:DisplayObject,i:int):void{
//			var x:int = i * itemW;
//			var y:int = bgh - icon.height >> 1;
//			if(icon.x == x && icon.y == y){
//				return;
//			}
//			TweenHelper.to(icon,{x:x,y:y},200);
//		}
		
		
		protected var intoWidth:int;
		protected var intoIndex:int;
		override public function getIndex(icon:IDockIcon):int{
			var i:int;
			var dx:int;
			var d:DisplayObject = icon as DisplayObject;
			intoWidth = d.height;
			dx = (d.x - x) + intoWidth/2 + itemH;
			for each(var dockicon:DisplayObject in iconList){
				if(dx<(dockicon.x+dockicon.width)){
					intoIndex = i;
					return i;
				}
				i++;
			}
			intoIndex = i;
			return i;
		}
		
		protected var toyy:int;
		
		override public function tweenTo(icon:DisplayObject, i:int):void{
			var tox:int = 0;
			var index:int;
			for each(var dockicon:DisplayObject in iconList){
				if(dockicon == icon){
					if(i>index){
						tox += intoWidth+itemW;
					}
					break;
				}else if(i == index){
					break;
				}
				tox += dockicon.width + itemW;
				index++;
			}
			
			if(icon.x == tox){
				return;
			}
			
			icon.y = toyy;
			
			TweenHelper.to(icon,{x:tox},200);
		}
		
		override public function checkDock():void{
			var i:int;
			var tox:int = 0;
			for each(var icon:IDockIcon in iconList){
				icon.nextMoveIndex = i++;
				icon.setName(icon.nextMoveIndex.toString());
//				tox = bgw - (icon as DisplayObject).width >> 1
				icon.y = toyy;
				TweenHelper.to(icon as DisplayObject,{x:tox},200);
				tox += (icon as DisplayObject).width + itemH;
			}
			if(tox<100){
				tox = 100;
			}
			
			drawbg(tox+20,bgh);
			
			//			this.graphics.clear();
			//			graphics.beginFill(0,0.5);
			//			graphics.drawRect(0,0,50,toy);
			//			graphics.endFill();
		}
		
	}
}