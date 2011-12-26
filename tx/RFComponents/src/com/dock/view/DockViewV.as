package com.dock.view
{
	import com.dock.icon.IDockIcon;
	import com.tween.TweenHelper;
	
	import flash.display.DisplayObject;

	public class DockViewV extends DockView
	{
		public function DockViewV(itemHeight:int)
		{
			super(0, itemHeight);
		}
		
		protected var intoIndex:int;
		
		protected var intoHeight:int;
		
		protected var bgw:int;
		protected var bgh:int;
		override public function setSize(w:int, h:int, e:int=0):void{
			bgw = w;
			bgh = h;
			drawbg(w,h);
			this.e = 0;
		}
		
		override public function getIndex(icon:IDockIcon):int{
			var i:int;
			var dy:int;
			var d:DisplayObject = icon as DisplayObject;
			intoHeight = d.height;
			dy = (d.y - y) + intoHeight/2 + itemH;
			for each(var dockicon:DisplayObject in iconList){
				if(dy<(dockicon.y+dockicon.height)){
					intoIndex = i;
					return i;
				}
				i++;
			}
			intoIndex = i;
			return i;
		}
		
		override public function tweenTo(icon:DisplayObject, i:int):void{
			var tox:int = bgw - icon.width >> 1;
			var toy:int = 0;
			var index:int;
			for each(var dockicon:DisplayObject in iconList){
				if(dockicon == icon){
					if(i>index){
						toy += intoHeight+itemH;
					}
					break;
				}else if(i == index){
					break;
				}
				toy += dockicon.height + itemH;
				index++;
			}
			
			if(icon.y == toy){
				return;
			}
			TweenHelper.to(icon,{x:tox,y:toy},200);
		}
		
		override public function checkDock():void{
			var i:int;
			var tox:int = 0;
			var toy:int = 0;
			for each(var icon:IDockIcon in iconList){
				icon.nextMoveIndex = i++;
				icon.setName(icon.nextMoveIndex.toString());
				tox = bgw - (icon as DisplayObject).width >> 1
				TweenHelper.to(icon as DisplayObject,{x:tox,y:toy},200);
				toy += (icon as DisplayObject).height + itemH;
			}
			if(toy<100){
				toy = 100;
			}
			
			drawbg(bgw,toy+20);
			
//			this.graphics.clear();
//			graphics.beginFill(0,0.5);
//			graphics.drawRect(0,0,50,toy);
//			graphics.endFill();
		}
	}
}