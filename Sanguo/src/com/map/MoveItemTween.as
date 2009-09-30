package com.map
{
	import com.display.tween.Tween;
	import com.display.tween.TweenEvent;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Point;

	public class MoveItemTween extends EventDispatcher
	{
		private var tween:Tween
		private var offsetX:Number;
		private var offsetY:Number;
		private var currentMovePoint:Point
		private var currentDirection:int;
		public function MoveItemTween()
		{
			
		}
		
		public var data:Object;
		public var item:DisplayObject;
		public var path:Array;
		public var el:Number;
		public function init(data:Object,item:DisplayObject,path:Array,el:Number):void{
			this.data = data;
			this.item = item;
			this.path = path;
			this.el = el;
			tween = new Tween();
			
			if(path==null || path.length<2){
				end();
			}
			
			
			
		}
		
		protected function getRealXY(x:int,y:int):Point{
			return new Point(x*el,y*el)
		}
		
		protected var isPlaying:Boolean
		public function start():void{
			if(isPlaying == false){
				var onePath:Array = path.shift();
				currentMovePoint = new Point(onePath[1],onePath[2]);
				var p:Point = getRealXY(onePath[1],onePath[2]);
				offsetX = p.x - item.x;
				offsetY = p.y - item.y;
				donext();
				isPlaying = true;
			}else{
				path.shift();
			}
		}
		
		public function stop():void{
			tween.stop();
			path.length = 0;
		}
		
		protected function donext():Boolean{
			if(this.path.length<1){
				return false;
			}
			
			var onePath:Array = path.shift();
			currentDirection = getDirection(currentMovePoint.x,currentMovePoint.y,onePath[1],onePath[2]);
			var p:Point = getRealXY(onePath[1],onePath[2]);
			p.x -= offsetX;
			p.y -= offsetY;
			tween.target = item;
			tween.duration = 200*((currentMovePoint.x == onePath[1] || currentMovePoint.y==onePath[2]) ? 1 : 2),
			tween.initAIEffect2(item,p,"x","y");
			tween.addEventListener(TweenEvent.TWEEN_END,tweenEndHandler);
			tween.play();
			
			currentMovePoint = new Point(onePath[1],onePath[2]);
			return true
		}
		
		protected function getDirection(bx:int,by:int,ex:int,ey:int):int{
			if(bx<ex) return 7;
			if(by<ey) return 1;
			if(bx>ex) return 3;
			return 5
		}
		
		public function end():void{
			isPlaying = false
			this.dispatchEvent(new MoveItemEvent(MoveItemEvent.MOVE_END,currentMovePoint,currentDirection));
		}
		
		public function disponse():void{
			this.item = null;
			this.tween = null;
			this.path = null;
		}
		
		protected function tweenEndHandler(event:TweenEvent):void{
			var b:Boolean = donext();
			this.dispatchEvent(new MoveItemEvent(MoveItemEvent.MOVE_CHANGE,currentMovePoint,currentDirection));
			if(b== false){
				end();
			}
		}
		
		
	}
}