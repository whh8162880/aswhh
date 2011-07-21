package com.view
{
	import com.theworld.components.panel.TXPanel;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import rfcomponents.SkinBase;
	import rfcomponents.zother.DragHelp;
	import rfcomponents.zother.MathDragHelp;
	
	public class MapViewPanel extends TXPanel
	{
		private var drag:DragHelp
		public function MapViewPanel()
		{
			super();
		}
		
		private var itemrenders:Array;
		private var itemrenderDict:Dictionary;
		private var w:int;
		private var h:int;
		override protected function bindComponents():void{
			itemrenders = [];
			var h:int = _height/100;
			var w:int = _width/100;
			
			var len:int = w*h;
			while(len--){
				itemrenders.push(new MapViewItemRender());
			}
			
			itemrenderDict = new Dictionary();
			
			drag = new MathDragHelp(_skin);
			drag.bindDragTarget(_skin);
			drag.xlock = drag.ylock = true;
			drag.addEventListener(Event.CHANGE,dragChangeHandler);
		}
		
		private var lineView:Shape;
		override protected function bindView():void{
			lineView = new Shape();
			var g:Graphics = lineView.graphics;
			h = _height/100;
			w = _width/100;
			var i:int = w;
			g.lineStyle(1,0);
			while(i-->1){
				g.moveTo(i*100,0);
				g.lineTo(i*100,_height);
			}
			
			i = h
			while(i-->1){
				g.moveTo(0,i*100);
				g.lineTo(_width,i*100);
			}
			
			ml = mt = t = l = 100;
			mr = r = _width - 100;
			mu = u = _height - 100;
		}
		
		/**
		 * 数据格式？
		 *  1 
		 * 		bs.length = 4*4 = 16;
		 * 
		 *  2
		 *		bs.length = 9 
		 *  5
		 *  	bs.length = 9
		 *  10
		 * 		bs.length = 9
		 *  20
		 * 		bs.length = 9
		 *  50
		 * 		bs.length = 9
		 *  100
		 *  	bs.length = 9
		 * @param mapres
		 * @param bs
		 * @param w
		 * 
		 */		
		public function initRender(x:int,y:int,mapres:Array,bs:Array,w:int,h:int,ez:int):void{
			this.mapx = x;
			this.mapy = y;
			this.mapw = w;
			this.maph = h;
			var i:int;
			var j:int;
			var b:ByteArray;
			for each(b in bs){
				var item:MapViewItemRender = renderItemRender(mapres,b,i,j,1);
				item.x = i*100;
				item.y = j*100;
				addChild(item.skin);
					
				i++;
				if(i>=w){
					i=0;
					j++;
				}
			
				if(j>=h){
					break;
				}
			}
			
			addChild(lineView);
		}
		
		/**
		 * 100*100 
		 */
		public function renderItemRender(mapres:Array,b:ByteArray,x:int,y:int,ez:int):MapViewItemRender{
			var type:String = x+"_"+y;
			var item:MapViewItemRender = itemrenderDict[type];
			if(!item){
				item = itemrenders.pop();
				itemrenderDict[type] = item;
			}
			item.render(mapres,b,x,y,ez);
			
			return item;
		}
		
		public function removeItemRender(x:int,y:int):int{
			var type:String = x+"_"+y;
			var item:MapViewItemRender = itemrenderDict[type];
			if(item){
				itemrenderDict[type] = null;
				delete itemrenderDict[type];
				item.dispose();
				itemrenders.push(item);
				return item.x;
			}
			return 0;
		}
		
		
		private var mapx:int;
		private var mapy:int;
		private var mapw:int;
		private var maph:int;
		
		private var l:int;
		private var r:int;
		private var t:int;
		private var u:int;
		private var ml:int;
		private var mr:int;
		private var mt:int;
		private var mu:int;
		private function dragChangeHandler(event:Event):void{
			move(drag.dx,drag.dy);
		}
		
		
		public function move(dx:int,dy:int):void{
			var rr:int = getTimer();
			var i:int;
			var j:int;
			var xlen:int = w-1;
			var ylen:int = h-1;
			var skin:MapViewItemRender
			var type:String
			var temp:int;
			l += dx;
			r += dx;
			t += dy;
			u += dy
			if(dx<0 && l<=ml){
				for(j=0;j<h;j++){
					removeItemRender(0,j);
					for(i=1;i<w;i++){
						type = i+"_"+j;
						skin = itemrenderDict[type];
						skin.dx -= 1;
						itemrenderDict[skin.dx+"_"+j] = skin;
						temp = skin.x += dx;
						skin.updata();
					}
					type = xlen+"_"+j;
					skin = itemrenders.pop();
					skin.x = temp+100;
					skin.dx = xlen;
					skin.dy = j;
					itemrenderDict[type] = skin;
					skin.updata();
				}
				l += 100;
				r += 100;
				mapx-=1;
			}else if(dx>0 && r>=mr){
				for(j=0;j<h;j++){
					temp = removeItemRender(xlen,j);
					for(i=xlen-1;i>=0;i--){
						type = i+"_"+j;
						skin = itemrenderDict[type];
						skin.dx += 1;
						itemrenderDict[skin.dx+"_"+j] = skin;
						skin.x += dx;
						skin.updata();
					}
					type = 0+"_"+j;
					skin = itemrenders.pop();
					skin.x = -100+l-ml;
					skin.dx = 0;
					skin.dy = j;
					itemrenderDict[type] = skin;
					skin.updata();
				}
				r -= 100;
				l -= 100;
				mapx+=1;
			}else{
				for each(skin in itemrenderDict){
					skin.x += dx;
				}
			}
			
			if(dy<0 && t<=mt){
				for(i=0;i<w;i++){
					removeItemRender(i,0);
					for(j=1;j<h;j++){
						type = i+"_"+j;
						skin = itemrenderDict[type];
						skin.dy -= 1;
						itemrenderDict[i+"_"+skin.dy] = skin;
						temp = skin.y += dy;
						skin.updata();
					}
					type = i+"_"+ylen;
					skin = itemrenders.pop();
					skin.y = temp+100;
					skin.dx = i;
					skin.dy = ylen;
					itemrenderDict[type] = skin;
					skin.updata();
				}
				t += 100;
				u += 100;
				mapy-=1
			}else if(dy>0 && u>=mu){
				for(i=0;i<w;i++){
					temp = removeItemRender(i,ylen);
					for(j=ylen-1;j>=0;j--){
						type = i+"_"+j;
						skin = itemrenderDict[type];
						skin.dy += 1;
						itemrenderDict[i+"_"+skin.dy] = skin;
						skin.y += dy;
						skin.updata();
					}
					type = i+"_"+0;
					skin = itemrenders.pop();
					skin.y = -100+t-mt;
					skin.dx = i;
					skin.dy = 0;
					itemrenderDict[type] = skin;
					skin.updata();
				}
				t -= 100;
				u -= 100;
				mapy+=1
			}else{
				for each(skin in itemrenderDict){
					skin.y += dy;
				}
			}
			
			
			
			trace(mapx,mapy)
		}
		
	}
}