package com.utils
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	public class StageCut extends Sprite
	{
		private var underImage:Shape;
		private var bitmapdata:BitmapData;
		private var _stage:Stage
		public function StageCut(stage:Stage)
		{
			super();
			underImage = new Shape();
			addChild(underImage);
			cut = new CutRect(cursor);
			cut.addEventListener(Event.CHANGE,cutChangeHandler);
			cut.addEventListener(MouseEvent.MOUSE_DOWN,cutMouseDownHandler);
			//addChild(cut);
			
			cursor = new Shape();
			//addChild(cursor);
			
			this._stage = stage;
		}
		
		private var _startflag:Boolean
		
		public function startCut(width:int,height:int):void{
			if(_startflag){
				return;
			}			
			
			_startflag = true;
			
			bitmapdata = new BitmapData(width,height,true,0xFFFFFF);
			bitmapdata.draw(_stage);
			
			graphics.beginBitmapFill(bitmapdata);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
			
			var g:Graphics = underImage.graphics;
			
			g.clear();
			g.beginFill(0,0.3);
			g.drawRect(0,0,width,height);
			g.endFill();
			
			
			_stage.addChild(this);
			
			addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
			
		}
		
		private function eschandler():void{
			endCut(false);
		}
		
		public function endCut(b:Boolean = true):void{
			graphics.clear();
			if(parent){
				parent.removeChild(this);
			}
			underImage.graphics.clear();
			if(bitmapdata){
				bitmapdata.dispose();
			}
			
			bitmapdata = null;
			cut.sleep();
			
			if(cut.parent){
				cut.parent.removeChild(cut);
			}
			
			if(cursor.parent){
				cursor.parent.removeChild(cursor);
			}
			
			_startflag = false;
			dispatchEvent(new Event(b ? Event.COMPLETE : "failed",false,false));
		}
		
		private var cut:CutRect;
		private var cursor:Shape;
		private function clickHandler(event:Event):void{
			event.stopImmediatePropagation();
			removeEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
			addChild(cut);
			addChild(cursor);
			cut.start();
		}
		
		private var point:Point = new Point(0,0);
		public var currentBitmapdata:BitmapData
		private function cutChangeHandler(event:Event = null):void{
			var rect:Rectangle = cut.reindex();
			//var rect:Rectangle = getBounds(cut);
			if(rect.width && rect.height){
				currentBitmapdata = new BitmapData(rect.width,rect.height,true,0);
				currentBitmapdata.copyPixels(bitmapdata,rect,point);
				cut.setBitmapdata(currentBitmapdata);
			}
		}
		
		private var cutOffsetx:int;
		private var cutOffsety:int;
		private var preClickTime:int;
		private function cutMouseDownHandler(event:MouseEvent):void{
			var t:int = getTimer();
			if(t - preClickTime < 200){
				endCut();
				return;
			}
			
			preClickTime = t;
			
			cutOffsetx = cut.mouseX;
			cutOffsety = cut.mouseY;
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,cutMouseMoveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP,cutMouseUpHandler);
		}
		
		private function cutMouseMoveHandler(event:MouseEvent):void{
			cut.x = mouseX - cutOffsetx;
			cut.y = mouseY - cutOffsety;
			cutChangeHandler();
		}
		
		private function cutMouseUpHandler(event:MouseEvent):void{
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE,cutMouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP,cutMouseUpHandler);
			cutOffsetx = cutOffsety = 0;
		}
		
	}
}
import flash.display.BitmapData;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.ui.Mouse;

class CutRectPoint extends Sprite{
	public var cursor:Shape;
	private var rollFlag:Boolean;
	private var len:int = 4;
	public function CutRectPoint(cursor:Shape,index:int){
		graphics.lineStyle(1,0xFFFFFF);
		graphics.beginFill(0x0000FF,1);
		graphics.drawRect(-len/2,-len/2,len,len);
		graphics.endFill();
		setIndex(index)
		//		addEventListener(MouseEvent.ROLL_OVER,rollHandler);
		//		addEventListener(MouseEvent.ROLL_OUT,rollHandler);
	}
	
	public var leftflag:Boolean;
	
	public var rightflag:Boolean;
	
	public var topflag:Boolean;
	
	public var underflag:Boolean;
	
	
	public var xs:Array;
	
	public var ys:Array;
	
	public var xhs:Array;
	
	public var yhs:Array;
	
	public var xp:CutRectPoint;
	public var yp:CutRectPoint;
	
	public var xflag:Boolean;
	
	public var yflag:Boolean;
	
	public function listenerlist(xs:Array,ys:Array,xhs:Array,yhs:Array,xp:CutRectPoint,yp:CutRectPoint):void{
		this.xs = xs;
		this.ys = ys;
		this.xhs = xhs;
		this.yhs = yhs;
		this.xp = xp;
		this.yp = yp;
		
		xflag = xhs.length>0;
		yflag = yhs.length>0;
	}
	
	
	public function repoint(x:int,y:int):Boolean{
		
		var offxflag:Boolean = this.x == 0;
		var offyflag:Boolean = this.y == 0;
		
		if(xflag){
			this.x = x;
			if(offxflag){
				offxflag = this.x != 0;
			}
		}else{
			offxflag = false;
		}
		
		if(yflag){
			this.y = y;
			if(offyflag){
				offyflag = this.y != 0;
			}
		}else{
			offyflag = false;
		}
		
		var d:CutRectPoint;
		
		for each(d in xs){
			d.x = x;
		}
		
		for each(d in ys){
			d.y = y;
		}
		
		for each(d in xhs){
			d.x = (x+xp.x)/2;
		}
		
		for each(d in yhs){
			d.y = (y+yp.y)/2;
		}
		
		//trace(offxflag,offyflag)
		
		return offxflag || offyflag;
		
	}
	
	
	
	public var index:int;
	public function setIndex(value:int):void{
		index = value;
		switch(value){
			case 0:
				leftflag = topflag = true;
				rightflag = underflag = false;
				break;
			case 1:
				topflag = true;
				leftflag = rightflag = underflag = false;
				break;
			case 2:
				rightflag = topflag = true;
				leftflag = underflag = false;
				break;
			case 3:
				leftflag = topflag = underflag = false;
				rightflag = true;
				break;
			case 4:
				rightflag  = underflag = true;
				leftflag = topflag = false;
				break;
			case 5:
				underflag = true;
				leftflag = topflag = rightflag = false;
				break;
			case 6:
				leftflag = underflag = true;
				topflag = rightflag = false;
				break;
			case 7:
				leftflag = true;
				underflag = topflag = rightflag = false;
				break;
			
		}
		
		if(rollFlag){
			drawCursor();
		}
	}
	
	public function refresh():void{
		if(leftflag){
			if(topflag){
				index = 0;
			}else if(underflag){
				index = 6;
			}else{
				index = 7;
			}
		}else if(topflag){
			if(rightflag){
				index = 2;
			}else{
				index = 1;
			}
		}else if(rightflag){
			if(underflag){
				index = 4;
			}else{
				index = 3;
			}
		}else{
			index = 5;
		}
		
		if(rollFlag){
			drawCursor();
		}
	}
	
	private function rollHandler(event:MouseEvent):void{
		rollFlag = (event.type == MouseEvent.ROLL_OVER);
		drawCursor();
	}
	
	/**
	 * type 	0 \
	 * 			1 |
	 * 			2 /
	 * 			3 -
	 * 
	 */	
	private function drawCursor():void{
		var g:Graphics = cursor.graphics
		if(!rollFlag){
			g.endFill();
			Mouse.show();
		}
		
		Mouse.hide();
		
	}
}

class CutRect extends Sprite{
	public function CutRect(cursor:Shape){
		points = [];
		for(var i:int = 0;i<8;i++){
			points.push(new CutRectPoint(cursor,i));
		}
		
		/**
		 * 8 point 
		 * 0 ↖  1 ↑  2 ↗
		 * 7 ←        3 →
		 * 6 ↙  5 ↓  4 ↘
		 */	
		//init;
		points[0].listenerlist(/**xs*/[points[7],points[6]],/**ys*/[points[1],points[2]],/**xhs*/[points[1],points[5]],/**yhs*/[points[7],points[3]],points[2],points[6]);
		points[1].listenerlist(/**xs*/[],/**ys*/[points[0],points[2]],/**xhs*/[],/**yhs*/[points[7],points[3]],null,points[5]);
		points[2].listenerlist(/**xs*/[points[3],points[4]],/**ys*/[points[1],points[0]],/**xhs*/[points[1],points[5]],/**yhs*/[points[7],points[3]],points[0],points[4]);
		points[3].listenerlist(/**xs*/[points[2],points[4]],/**ys*/[],/**xhs*/[points[1],points[5]],/**yhs*/[],points[7],null);
		points[4].listenerlist(/**xs*/[points[2],points[3]],/**ys*/[points[6],points[5]],/**xhs*/[points[1],points[5]],/**yhs*/[points[7],points[3]],points[6],points[2]);
		points[5].listenerlist(/**xs*/[],/**ys*/[points[6],points[4]],/**xhs*/[],/**yhs*/[points[7],points[3]],null,points[1]);
		points[6].listenerlist(/**xs*/[points[0],points[7]],/**ys*/[points[5],points[4]],/**xhs*/[points[1],points[5]],/**yhs*/[points[7],points[3]],points[4],points[0]);
		points[7].listenerlist(/**xs*/[points[0],points[6]],/**ys*/[],/**xhs*/[points[1],points[5]],/**yhs*/[],points[3],null);
		
		
		
	}
	
	private var _stage:Stage;
	private var _start:Boolean = false;
	public function start():void{
		if(_start){
			return;
		}
		var d:CutRectPoint
		var i:int;
		for each(d in points){
			d.setIndex(i++);
			addChild(d);
			d.addEventListener(MouseEvent.MOUSE_DOWN,clickHandler);
		}
		
		d = points[4]
		
		addChild(d);
		
		x = parent.mouseX;
		y = parent.mouseY;
		
		_start = true;
		
		d.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,false,false));
		
		
	}
	
	public function sleep():void{
		var d:CutRectPoint
		for each(d in points){
			d.x =d.y = 0
		}
		graphics.clear();
		_start = false;
	}
	
	private var currentd:CutRectPoint;
	private function clickHandler(event:MouseEvent):void{
		if(!_stage){
			_stage = stage;
		}
		
		event.stopImmediatePropagation();
		
		currentd = event.currentTarget as CutRectPoint;
		
		if(currentd){
			_stage.addEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
		}
	}
	
	private function moveHandler(event:MouseEvent):void{
		var b:Boolean = currentd.repoint(mouseX,mouseY);
		var offsetx:int;
		var offsety:int;
		var d:CutRectPoint;
		if(b){
			offsetx = currentd.xflag ? currentd.x : 0;
			offsety = currentd.yflag ? currentd.y : 0;
			
			this.x += offsetx;
			this.y += offsety;
			
			for each(d in points){
				d.x -= offsetx;
				d.y -= offsety;
			}
		}
		
		this.dispatchEvent(new Event(Event.CHANGE,false,false));
		
	}
	
	
	private function mouseUpHandler(event:MouseEvent):void{
		_stage.removeEventListener(MouseEvent.MOUSE_MOVE,moveHandler);
		_stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler)
	}
	
	public function setBitmapdata(bitmapdata:BitmapData):void{
		graphics.clear();
		graphics.beginBitmapFill(bitmapdata/*,new Matrix(1,0,0,1,this.x,this.y)*/);
		graphics.lineStyle(1,0x0000FF);
		var d:CutRectPoint;
		d = points[7]
		graphics.moveTo(d.x,d.y)
		for each(d in points){
			graphics.lineTo(d.x,d.y);
		}
		graphics.endFill();
	}
	
	private var points:Array;
	private var rect:Rectangle = new Rectangle();
	/**
	 * 8 point 
	 * 0 ↖
	 * 1 ↑
	 * 2 ↗
	 * 3 →
	 * 4 ↘
	 * 5 ↓
	 * 6 ↙
	 * 7 ←
	 */	
	public function reindex():Rectangle{
		var left:int = int.MAX_VALUE;
		var right:int = int.MIN_VALUE;
		var top:int = int.MAX_VALUE;
		var under:int = int.MIN_VALUE;
		var x:int;
		var y:int;
		var d:CutRectPoint;
		for each(d in points){
			x = d.x;
			y = d.y;
			if(x<left){
				left = x;
			}else if(x>right){
				right = x;
			}
			
			if(y<top){
				top = y;
			}else if(y>under){
				under = y;
			}
		}
		
		rect.x = left + this.x;
		rect.y = top + this.y;
		rect.width = right - left;
		rect.height = under - top;
		
		return rect;
		
//		for each(d in points){
//			x = d.x;
//			y = d.y;
//			if(x==left){
//				d.leftflag = true;
//			}else if(x==right){
//				d.rightflag = true;
//			}
//			
//			if(y==top){
//				d.topflag = true;
//			}else if(y==under){
//				d.underflag = true;
//			}
//			
//			d.refresh();
//		}
		
		//points = points.sortOn("index",Array.NUMERIC)
	}
}


