package com.dock.view
{
	import com.dock.DockManager;
	import com.dock.icon.DockIcon;
	import com.dock.icon.IDockIcon;
	import com.tween.TweenHelper;
	
	import flash.desktop.Icon;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class DockView extends Sprite implements IDockView
	{
		public function DockView(itemWidth:int,itemHeight:int)
		{
			itemW = itemWidth;
			itemH = itemHeight;
			c_name = toString();
			iconList = [];
		}
		
		protected var itemW:int;
		
		protected var itemH:int;
		
		protected var e:int = 0;
		
		protected var iconList:Array;
		
		public var c_name:String;
		
		public function getList():Array{
			return iconList;
		}
		
		
		public function getIndex(icon:IDockIcon):int{
			var d:DisplayObject = icon as DisplayObject;
			var dx:int = ((d.x + itemW/2) - x)/itemW;
			var dy:int = ((d.y + itemH/2) - y)/itemH;
			var i:int = dy*e + dx;
			var len:int;
			len = iconList.length;
			if(i>len){
				i = len;
			}
			return i;
		}
		
		
		public function setSize(w:int,h:int,e:int = 0):void{
			graphics.clear();
			graphics.beginFill(0xCCCCCC);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			this.e = e;
		}
		
		public function addDockIcon(icon:IDockIcon):void{
			addChild(icon as DisplayObject);
		//	tweenTo(icon as DisplayObject,iconList.length);
			iconList.push(icon);
			checkDock();
		}
		
		public function intoDockIcon(icon:IDockIcon):void{
			addChild(icon as DisplayObject);
			//tweenTo(icon as DisplayObject,icon.nextMoveIndex);
			iconList.splice(icon.nextMoveIndex,0,icon);
		}
		
		public function preRemoveDockIcon(icon:IDockIcon):void{
			var index:int = iconList.indexOf(icon);
			if(index!=-1){
				iconList.splice(index,1);
			}
		}
		
		public function tweenTo(icon:DisplayObject,i:int):void{
			var x:int = int(i % e) * itemW;
			var y:int = int(i / e) * itemH;
			if(icon.x == x && icon.y == y){
				return;
			}
			TweenHelper.to(icon,{x:x,y:y},200);
		}
		
		public function checkDock():void{
			var i:int;
			for each(var icon:IDockIcon in iconList){
				icon.nextMoveIndex = i++;
				icon.setName(icon.nextMoveIndex.toString());
				tweenTo(icon as DisplayObject,icon.nextMoveIndex);
			}
		}
		
		
		protected function drawbg(w:int,h:int):void{
			this.graphics.clear();
			graphics.beginFill(0xCCCCCC);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
		}
	}
}