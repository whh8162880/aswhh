package com.tween
{
	import flash.utils.Dictionary;

	public class TweenHelper
	{
		public function TweenHelper()
		{
		}
		public static function to(target:Object,obj:Object,duration:int):void{
			if(!target || !obj){
				return;
			}
			var tween:TweenChildren = TweenChildren.tweenDict[target];
			if(tween){
				tween.clear();
			}else{
				tween = new TweenChildren();
			}
			tween.start(target,obj,duration);
		}
		
		
		public static function form(target:Object,obj:Object,duration:int):void{
			if(!target || !obj){
				return;
			}
			var tween:TweenChildren = TweenChildren.tweenDict[target];
			if(tween){
				tween.clear();
			}else{
				tween = new TweenChildren();
			}
			tween.start(target,obj,duration,false);
		}
	}
}
import com.tween.Tweener;

import flash.utils.Dictionary;

class TweenChildren{
	public static var tweenDict:Dictionary = new Dictionary();
	
	
	public var tween:Tweener;
	public var target:Object;
	private var propertys:Array;
	private var n:int;
	
	public function TweenChildren(){
		propertys = [];
	}
	
	public function start(target:Object,obj:Object,duration:int,to:Boolean = true):void{
		if(!target){
			return;
		}
		propertys.length = 0;
		this.target = target;
		if(!tween){
			tween = new Tweener();
		}
		for (var p:String in obj){
			if(target.hasOwnProperty(p) && (target[p] is Number) && target[p] != obj[p]){
				propertys.push(p);
				if(to){
					tween.addTask(target[p],obj[p]);
				}else{
					tween.addTask(obj[p],target[p]);
				}
			}
		}
		n = propertys.length;
		tween.onUpdata = updata;
		tween.onNext = disponse;
		tween.play(duration);
		tweenDict[target] = this;
	}
	
	public function updata(arr:Array):void{
		for (var i:int = 0;i<n;i++){
			target[propertys[i]] = arr[i];
		}
	}
	
	public function clear():void{
		if(tween && tween.isPlaying){
			tween.end();
		}
	}
	
	public function disponse():void{
		clear();
		tween = null;
		tweenDict[target] = null;
		delete tweenDict[target];
	}
}