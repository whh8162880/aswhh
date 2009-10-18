package com.display.keyboard
{
	import com.youbt.manager.RFSystemManager;
	import com.youbt.utils.ArrayUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;

	public class KeyboardManager extends EventDispatcher
	{
		public static var state:IEventDispatcher;
		private static var _stage:Stage;
		private static var _loop:Boolean = false
		public static function setStage(stage:Stage):void{
			if(_stage) return;
			_stage = stage;
		}
		
		private static function addTarget(target:IEventDispatcher):void{
			if(!target){
				return;
			}
			target.addEventListener(MouseEvent.ROLL_OVER,rollHandler);
			target.addEventListener(MouseEvent.ROLL_OUT,rollHandler);
		}
		
		private static function removeTarget(target:IEventDispatcher):void{
			if(!target){
				return;
			}
			target.removeEventListener(MouseEvent.ROLL_OVER,rollHandler);
			target.removeEventListener(MouseEvent.ROLL_OUT,rollHandler);
			if(state == target){
				removeListener();
				state = null;
			}
		}
		
		private static function startListener():void{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP,keyHandler);
//			trace("_stage add")
		}
		
		private static function removeListener():void{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
			_stage.removeEventListener(KeyboardEvent.KEY_UP,keyHandler);
//			trace("_stage remove")
		}
		
		private static function keyHandler(event:KeyboardEvent):void{
			if(state){
				var e:KeyboardEvent = new KeyboardEvent(event.type,false,false,event.charCode,event.keyCode,event.keyLocation,event.ctrlKey,event.altKey,event.shiftKey);
				state.dispatchEvent(e);
				event.stopImmediatePropagation();
			}else{
				removeListener();
			}
		}
		
		private static function rollHandler(event:MouseEvent):void{
			if(!_stage){
				var d:DisplayObject = event.target as DisplayObject
				_stage = d ? d.stage : null
			}
			if(event.type == MouseEvent.ROLL_OVER){
				state = IEventDispatcher(event.target)
				startListener();
			}else{
				state = null
				removeListener();
			}
		}
		
		private var keymap:Dictionary
		private var target:IEventDispatcher
		private var usedKeymap:Dictionary
		private var keylist:Array
		public function KeyboardManager(target:IEventDispatcher=null)
		{
			if(!_stage) {
				setStage(RFSystemManager.getInstance().stage);
			}
			keylist = []
			keymap = new Dictionary();
			usedKeymap = new Dictionary();
			super(target);
		}
		
		public function init(target:IEventDispatcher):void{
			if(this.target != null){
				return;
			}
			this.target = target
			this.target.addEventListener(KeyboardEvent.KEY_DOWN,keydownHandler);
			this.target.addEventListener(KeyboardEvent.KEY_UP,keyupHandler);
		}
		
		public function start():void{
			addTarget(this.target);
		}
		
		public function sleep():void{
			removeTarget(this.target);
		}
		
		public function regFunction(keyFunction:Function,ctrlflag:Boolean = false,shiftflag:Boolean=false,altFlag:Boolean=false,...args):Boolean{
			var keyString:String = getKeyAction(args,ctrlflag,shiftflag,altFlag);
			var keyvo:KeyVO = keymap[keyString]
			if(keyvo==null){
				keyvo = new KeyVO(args,ctrlflag,shiftflag,altFlag,keyFunction)
				keymap[keyString] = keyvo;
				return true
			}else{
				keyvo.keyFunction = keyFunction;
				return true
			}
		}
		
		public function removeFunction(keycodes:Array,ctrlflag:Boolean = false,shiftflag:Boolean=false,altFlag:Boolean=false):void{
//			if(state == null){
//				state = RFSystemManager.getInstance().stage.focus;
//			}
			if(state && state != this){
				return;
			}
			var keyString:String = getKeyAction(keycodes,ctrlflag,shiftflag,altFlag);
			var keyvo:KeyVO = keymap[keyString]
			if(keyvo != null){
				keyvo = null
				keymap[keyString] = null
				delete keymap[keyString]
			}
		}
		
		public function removeFunctionByKeyFunction(keyfuntion:Function):void{
			for each(var vo:KeyVO in keymap){
				if(vo.keyFunction == keyfuntion){
					removeFunction(vo.keycodes,vo.ctrlflag,vo.shiftflag,vo.altFlag);
				}
			}
		}
		
		public function keydownHandler(event:KeyboardEvent):void{
			var code:int = event.keyCode;
			if(usedKeymap[code] == true || code == 17 || code == 16){
				return;
			}
			usedKeymap[code] = true
			keylist.push(code);
			var keyString:String = getKeyAction(keylist,event.ctrlKey,event.shiftKey,event.altKey);
			var vo:KeyVO = keymap[keyString]
			if(vo!=null && vo.keyFunction != null){
				trace(vo.getFormatKeyCode())
				vo.keyFunction();
//				keylist.length = 0;
			}
			
//			trace("down keylist : "+keylist)
		}
		
		public function keyupHandler(event:KeyboardEvent):void{
			var code:int = event.keyCode;
			
			if(code == 17 || code == 16){
				return;
			}
			
			usedKeymap[code] = false;
			ArrayUtil.remove(keylist,code);
			delete usedKeymap[code]
//			trace("up keylist : "+keylist)
		}
		
		protected function getKeyAction(keycodes:Array,ctrlflag:Boolean,shiftflag:Boolean,altFlag:Boolean):String{
			
			var i:int;
			for each(var o:Object in keycodes){
				if(o is KeyStroke){
					o = (o as KeyStroke).getCode();
					keycodes[i] = o
				}
				i++
			}
			
			keycodes.sort();
			return "whhkey_"+ctrlflag.toString()+"_"+shiftflag.toString()+
			       			"_"+altFlag.toString()+"_"+keycodes.join("_");
		}
		
		public function getFunctionList():Array{
			var arr:Array = []
			for each(var vo:KeyVO in keymap){
				arr.push(vo.getFormatKeyCode())
			}
			return arr;
		}
	}
}
	import com.youbt.manager.keyboardClasses.KeySequence;
	import com.display.keyboard.KeyStroke;
	

class KeyVO{
	public function KeyVO(keycodes:Array,ctrlflag:Boolean,shiftflag:Boolean,altFlag:Boolean,keyFunction:Function){
		keycodes.sort();
		this.keycodes = keycodes;
		this.ctrlflag = ctrlflag;
		this.shiftflag = shiftflag;
		this.altFlag = altFlag;
		this.keyFunction = keyFunction;
	}
	
	public var keycodes:Array;
	public var ctrlflag:Boolean
	public var shiftflag:Boolean
	public var altFlag:Boolean
	public var keyFunction:Function
	
	public function getFormatKeyCode():Object{
		var label:String = ctrlflag ? "ctrl+" : "";
		label +=  shiftflag ? "shift+" : "";
		label +=  altFlag ? "alt+" : "";
		for each(var keycode:int in keycodes){
			var keyStroke:KeyStroke = KeyStroke.getKeyStrokeByKeyCode(keycode);
			if(keyStroke)
				label += keyStroke.getDescription()+"+"
		}
		label = label.slice(0,label.length - 1);
		return label;
	}
}