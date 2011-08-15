package com.effect
{
	import com.tween.Tweener;
	import com.utils.math.IntPoint;
	
	import flash.display.Shape;
	import flash.filters.GlowFilter;
	import flash.utils.getTimer;

	public class FruitCut extends Shape
	{
		protected var tween:Tweener;
		protected var lines:Array;
		protected var liveTime:int;
		public function FruitCut()
		{
			filters = [new GlowFilter(0xFFFFFF*Math.random(), 1, 10, 10, 2, 1, false, false)];
			tween = new Tweener();
			lines = [];
		}
		
		private var times:Array;
		private var currentMoveToPoint:IntPoint;
		private var points:Array;
		public function start(points:Array,duration:int,liveTime:int = 500):FruitCut{
			this.points = points;
			var arr:Array = [];
			var i:int;
			var len:int;
			var tLen:int;
			this.liveTime = liveTime;
			for(i=1;i<points.length;i++){
				len = points[i-1].getLength(points[i].x,points[i].y);
				tLen += len;
				arr.push(len);
			}
			//计算时间
			len = arr.length;
			for(i=0;i<len;i++){
				arr[i] = arr[i]/tLen * duration;
			}
			times = arr;
			var point:IntPoint = points.shift();
			lines.push(new LineVO(point.x,point.y,liveTime));
			currentMoveToPoint = points.shift();
			moveTween(point,currentMoveToPoint,times.shift());
			return this;
		}
		
		protected function moveTween(p0:IntPoint,p1:IntPoint,time:int):void{
			tween.addTask(p0.x,p1.x);
			tween.addTask(p0.y,p1.y);
			tween.onUpdata = updata;
			tween.onNext = complete;
			tween.play(time);
		}
		
		protected function updata(arr:Array):void{
			lines.unshift(new LineVO(arr[0],arr[1],liveTime));
			var i:int = 0;
			var len:int = lines.length;
			var line:LineVO = lines[0];
			graphics.clear();
			graphics.moveTo(line.x,line.y);
			var s:int = getTimer();
			for(i=1;i<len;i++){
				line = lines[i];
				var x:int = line.getLine(s);
				if(x<=0){
					lines.pop();
					i-=1;
					len-=1;
					continue;
				}
				graphics.lineStyle(x,0xFFFFFF);
				graphics.lineTo(line.x,line.y);
			}
		}
		
		protected function complete():void{
			if(!points.length){
				tween.addTask(0,liveTime);
				tween.onUpdata = cUpdata;
				tween.onComplete = cComplete;
				tween.play(liveTime);
				return;
			}
			var point:IntPoint = points.shift();
			moveTween(currentMoveToPoint,point,times.shift());
			currentMoveToPoint = point;
		}
		
		protected function cUpdata(arr:Array):void{
			var i:int = 0;
			var len:int = lines.length;
			var line:LineVO = lines[0];
			graphics.clear();
			graphics.moveTo(line.x,line.y);
			var s:int = getTimer();
			for(i=1;i<len;i++){
				line = lines[i];
				var x:int = line.getLine(s);
				if(x<=0){
					lines.pop();
					i-=1;
					len-=1;
					continue;
				}
				graphics.lineStyle(x,0xFFFFFF,x/5);
				graphics.lineTo(line.x,line.y);
			}
		}
		
		protected function cComplete():void{
			graphics.clear();
			if(parent){
				parent.removeChild(this);
			}
		}
		
	}
}
import flash.utils.getTimer;

class LineVO{
	public var x:int;
	public var y:int;
	public var line:int;
	public var startTime:int;
	public var liveTime:int;
	public function LineVO(x:int,y:int,liveTime:int,line:int = 5){
		this.x = x;
		this.y = y;
		this.line = line;
		this.liveTime = liveTime;
		this.startTime = getTimer();
	}
	
	public function getLine(s:int):int{
		return (1-(s - startTime)/liveTime) * line + 2
	}
}