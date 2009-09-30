package com.display.tween
{
	
	
	import com.youbt.utils.ArrayUtil;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	
	[Event(name="tweenEnd", type="com.tween.TweenEvent")]
    [Event(name="tweenStart", type="com.tween.TweenEvent")]
    [Event(name="tweenUpdate", type="com.tween.TweenEvent")]
    [Event(name="tweenPlay", type="com.tween.TweenEvent")]
    [Event(name="tweenStop", type="com.tween.TweenEvent")]
	
	public class Tween extends EventDispatcher
	{
		protected static var time:Timer;
		protected static var nInterval:int;
		protected static var tweens:Array
		public static function addTween(t:Tween):void{
			
			if(tweens == null){
				tweens = []
			}
			
			if(ArrayUtil.has(tweens,t) == true){
				return;
			}
			
			if(time == null){
				if(nInterval == 0){
					nInterval = 30;
				}
				time = new Timer(nInterval)
				time.addEventListener(TimerEvent.TIMER,timerHandler);
			}
			
			if(time.running == false){
				time.start()
			}
			t.starttime = getTimer();
			t.start();
			
			tweens.push(t);
			
		}
		
		public static function removeTween(t:Tween):void{
			ArrayUtil.remove(tweens,t)
			if(tweens.length == 0){
				time.stop();
			}
		}
		
		public static function setTweenInterval(value:int):void{
			if(value<10) value = 10
			time.delay = value
		}
		
		protected static function timerHandler(event:TimerEvent):void{
			for each(var tween:Tween in tweens){
				if(tween.pause == false){
					tween.doInterval();
					var currentDuration:int = getTimer() - tween.starttime
					tween.currentDuration = currentDuration;
					if(currentDuration > tween.duration){
						tween.end()
					}
				}
			}
			
			event.updateAfterEvent();
		}
		
		public var target:Object;
		public var starttime:int;
		public var duration:int
		public var currentDuration:int
		
		protected var _isPlaying:Boolean
		protected var _pause:Boolean
		protected var _ed:IEventDispatcher
		protected var formArray:Array
		protected var toArray:Array
		protected var currentArray:Array
		
		protected var effectList:Array
		
		protected var currentEffectFunction:Function
		protected var effectNumber:Number = 0.8
		public function Tween()
		{
//			formArray = []
//			toArray = []
			currentArray = []
			
			effectList = [];
			_ed = this
			
			currentEffectFunction = effectFunction
		}
		
		public function play():void{
			_isPlaying = true
			currentDuration = 0
			_ed.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_PLAY))
			doTween(this.duration);
		}
		
		protected function doTween(duration:int = 0):void{
			this.duration = duration
			
			if (this.duration == 0) {
				end();
			} else {
				Tween.addTween(this);
			}
			
//			for (var i:int = 0;i<formArray.length;i++){
//				var b:Number = formArray[i];
//				var e:Number = toArray[i];
//				
//				b = (b == false ? 0 : b);
//				e = (e == false ? 0 : e);
//				
//				formArray[i] = b;
//				toArray[i] = e;
//				currentArray[i] = b;
//			}
			
		}
		
		public function stop():void{
			_ed.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_STOP,false,false,formArray))
		}
		
		public function doInterval():void{
			var p:Number = currentDuration/duration;
			currentArray.length = 0;
			for each(var vo:TweenPropertyVO in effectList ){
				var b:Number = vo._from;
				var e:Number = vo._to;
				var c:Number = vo._current;
				vo._current = currentEffectFunction(b,e,c,p)
				if(vo.property){
					currentArray.push([vo.property,vo._current])
					if(this.target && this.target.hasOwnProperty(vo.property)){
						this.target[vo.property] = vo._current;
					}
				}else{
					currentArray.push(vo._current)
				}
			}
			_ed.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_UPDATE,false,false,formatReturnData()))
		}
		
		public function start():void{
			_ed.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_START))
		}
		
		public function end():void{
			removeTween(this)
			currentArray.length = 0;
			for each(var vo:TweenPropertyVO in effectList ){
				vo._current = vo._to;
				if(vo.property){
					currentArray.push([vo.property,vo._to])
					if(this.target && this.target.hasOwnProperty(vo.property)){
						this.target[vo.property] = vo._current;
					}
				}else{
					currentArray.push(vo._to)
				}
			}
			_isPlaying = false
			_ed.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_END,false,false,formatReturnData()))
			stop();
		}
		
		public function set pause(value:Boolean):void{
			_pause = value
			if(_pause == false){
				this.starttime = getTimer()-currentDuration;
				_ed.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_PLAY))
			}else{
				_ed.dispatchEvent(new TweenEvent(TweenEvent.TWEEN_STOP))
			}
		}
		
		public function get pause():Boolean{
			return _pause
		}
		
		public function get isPlaying():Boolean{
			return _isPlaying
		}
		
		protected function formatReturnData():Object{
			return currentArray;
		}
		
		
		protected function effectFunction(b:Number,e:Number,c:Number,p:Number):Number{
			return b + (e-b)*p;
		}
		
		protected function effectFunction1(b:Number,e:Number,c:Number,p:Number):Number{
			return c+(e-c)*effectNumber
		}
		
		//args type [form,to,"porperty"]
		public function initAIEffect(...args):void{
			effectList.length = 0;
			for each(var arr:Array in args){
				if(arr == null){
					continue;
				}
				effectList.push(new TweenPropertyVO(arr[0],arr[1],arr[2]));
			}
		}
		
		public function initAIEffect2(formObject:Object,toObject:Object,...propertys):void{
			effectList.length = 0;
			for each(var property:String in propertys){
				if(formObject.hasOwnProperty(property) && toObject.hasOwnProperty(property)){
					effectList.push(new TweenPropertyVO(formObject[property],toObject[property],property));
				}
			}
		}
		
		public function setEffectType(type:int,effectNumber:Number = 0.1) : void{
			if(type == 1){
				this.effectNumber = effectNumber
				currentEffectFunction = effectFunction1;
			}else{
				currentEffectFunction = effectFunction;
			}
		}

	}
}

class TweenPropertyVO{
	public function TweenPropertyVO(_from:Number,_to:Number,property:String = null){
		count = 0
		this._from = isNaN(_from) ? 0 : _from 
		this._to = isNaN(_to) ? 0 : _to;
		this.property = property;
		this._current = this._from;
	}
	
	public var _from:Number;
	public var _to:Number;
	public var property:String;
	public var _current:Number;
	
	public var count:int;
}