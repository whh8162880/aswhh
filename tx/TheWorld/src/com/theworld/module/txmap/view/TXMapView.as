package com.theworld.module.txmap.view
{
	import com.theworld.module.txmap.itemrender.TXMapItemRender;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	import rfcomponents.SkinBase;
	import rfcomponents.zother.DragHelp;
	import rfcomponents.zother.MathDragHelp;

	public class TXMapView extends SkinBase
	{
		public function TXMapView()
		{
			create(600,400);
		}
		private var lineView:Shape;
		private var drag:DragHelp
		override protected function bindComponents():void{
			lineView = new Shape();
			addChild(lineView);
			
			drag = new MathDragHelp(_skin);
			drag.bindDragTarget(_skin);
			drag.xlock = drag.ylock = true;
			drag.addEventListener(Event.CHANGE,dragChangeHandler);	
		}
		
		private function dragChangeHandler(event:Event):void{
			move(drag.dx,drag.dy);
		}
		
		private var itemrenderDict:Dictionary;
		private var itemrenders:Array;
		public function setConfig(cw:int,ch:int,sizew:int,sizeh:int):void{
			var i:int;
			var j:int;
			
			itemrenderDict = new Dictionary();
			itemrenders = [];
			
			h = ch;
			w = cw;
			
			this.sizew = sizew;
			this.sizeh = sizeh;
			
			var len:int = w*h;
			
			for(j=0;j<h;j++){
				for(i=0;i<w;i++){
					var skin:TXMapItemRender = new TXMapItemRender();
					skin.create(sizew,sizeh,Math.random()*0xFFFFFF,false);
					skin.dx = i;
					skin.dy = j;
					skin.x = i*sizew;
					skin.offsetx = skin.x - sizew;
					skin.y = j*sizeh;
					skin.offsety = skin.y - sizeh;
					itemrenderDict[i+"_"+j] = skin;
					edits.push(skin);
					skin.updata();
					addChild(skin.skin);
				}
			}
			//create(w*100,h*100);
			
			var g:Graphics = lineView.graphics;
			i = w+1;
			g.lineStyle(1,0);
			while(i-->1){
				g.moveTo(i*sizew,0);
				g.lineTo(i*sizew,h*sizeh);
			}
			
			i = h+1;
			while(i-->1){
				g.moveTo(0,i*sizeh);
				g.lineTo(w*sizew,i*sizeh);
			}
			
			ml = mt = t = l = sizew;
			mr = r = w*sizew - sizew;
			mu = u = h*sizeh - sizeh;
		}
		
		
		public function removeItemRender(x:int,y:int):void{
			var type:String = x+"_"+y;
			var item:TXMapItemRender = itemrenderDict[type];
			if(item){
				itemrenderDict[type] = null;
				delete itemrenderDict[type];
				item.dispose();
				itemrenders.push(item);
				removes.push([item.offsetx,item.offsety,item]);
			}
		}
		
		/**
		 * 100*100 
		 */
		
		
		public var mapx:int;
		public var mapy:int;
		
		private var sizew:int;
		private var sizeh:int;
		private var l:int;
		private var r:int;
		private var t:int;
		private var u:int;
		private var ml:int;
		private var mr:int;
		private var mt:int;	
		private var mu:int;
		
		private var w:int;
		private var h:int;
		public var removes:Array = [];
		public var edits:Array = [];
		public function move(dx:int,dy:int):void{
			var dt:int = getTimer();
			var i:int;
			var j:int;
			var xlen:int = w-1;
			var ylen:int = h-1;
			var skin:TXMapItemRender
			var type:String
			var temp:int;
			l += dx;
			r += dx;
			t += dy;
			u += dy
			if(dx<0 && l<=ml){
				mapx+=1;
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
					skin.x = temp+sizew;
					skin.offsetx = (xlen+mapx-1)*sizew;
					skin.dx = xlen;
					skin.dy = j;
					itemrenderDict[type] = skin;
					skin.updata();
					edits.push(skin);
				}
				l += sizew;
				r += sizew;
			}else if(dx>0 && r>=mr){
				mapx-=1;
				for(j=0;j<h;j++){
					removeItemRender(xlen,j);
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
					skin.x = -sizew+l-ml;
					skin.offsetx = mapx*sizew;
					skin.dx = 0;
					skin.dy = j;
					itemrenderDict[type] = skin;
					skin.updata();
				}
				r -= sizew;
				l -= sizew;
			}else{
				for each(skin in itemrenderDict){
					skin.x += dx;
				}
			}
			
			if(dy<0 && t<=mt){
				mapy+=1
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
					skin.y = temp+sizeh;
					skin.offsety = (ylen+mapy-1)*sizeh;
					skin.dx = i;
					skin.dy = ylen;
					itemrenderDict[type] = skin;
					skin.updata();
					edits.push([skin.offsetx,skin.offsety,skin]);
				}
				t += sizeh;
				u += sizeh;
			}else if(dy>0 && u>=mu){
				mapy-=1
				for(i=0;i<w;i++){
					removeItemRender(i,ylen);
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
					skin.y = -sizeh+t-mt;
					skin.offsety = mapy*sizeh;
					skin.dx = i;
					skin.dy = 0;
					itemrenderDict[type] = skin;
					skin.updata();
				}
				t -= sizeh;
				u -= sizeh;
			}else{
				for each(skin in itemrenderDict){
					skin.y += dy;
				}
			}
			
			if(edits.length){
				dispatchEvent(new Event(Event.CHANGE));
				removes.length = 0;
				edits.length = 0;
			}
			
			trace(getTimer()-dt);
			
			//trace(mapx,mapy)
		}
	}
}