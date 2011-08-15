package com.utils.key
{
	import flash.display.Stage;
	import flash.events.Event;
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
		public static var defaultFocus:KeyboardManager
		public static function setStage(stage:Stage):void{
			if(_stage) return;
			_stage = stage;
		}
		
		public static function setFocus(target:IEventDispatcher):void{
			state = target;
			startListener();
		}
		
		private static function addTarget(target:IEventDispatcher):void{
			if(!target){
				return;
			}
		}
		
		private static function removeTarget(target:IEventDispatcher):void{
			if(!target){
				return;
			}
			if(!defaultFocus && state == target){
				removeListener();
				state = null;
			}else{
//				_stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
				state = defaultFocus;
			}
		}
		
		private static function enterFrameHandler(event:Event):void{
			_stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			state = defaultFocus;
		}
		
		private static function startListener():void{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP,keyHandler);
			_stage.addEventListener(MouseEvent.CLICK,stageClickHandler);
//			trace("_stage add")
		}
		
		private static function removeListener():void{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyHandler);
			_stage.removeEventListener(KeyboardEvent.KEY_UP,keyHandler);
			_stage.removeEventListener(MouseEvent.CLICK,stageClickHandler);
//			trace("_stage remove")
		}
		
		private static function keyHandler(event:KeyboardEvent):void{
			if(_stage.focus == state){
				return;
			}
			if(state){
				//trace("focus",state)
				event.stopImmediatePropagation();
				var e:KeyboardEvent = new KeyboardEvent(event.type,false,false,event.charCode,event.keyCode,event.keyLocation,event.ctrlKey,event.altKey,event.shiftKey);
				state.dispatchEvent(e);
				
			}else{
				removeListener();
			}
		}
		
		private static function stageClickHandler(event:MouseEvent):void{
			if(event.currentTarget == state){
				removeListener();
			}
		}
		
		private var keymap:Dictionary
		private var target:IEventDispatcher
		private var usedKeymap:Dictionary
		private var keylist:Array
		public function KeyboardManager(target:IEventDispatcher=null)
		{
//			if(!_stage) {
//				setStage(RFSystemManager.getInstance().stage);
//			}
			keylist = []
			keymap = new Dictionary();
			usedKeymap = new Dictionary();
			super(target);
		}
		
		public function init(target:IEventDispatcher):void{
			this.target = target
			this.addEventListener(KeyboardEvent.KEY_DOWN,keydownHandler);
			this.addEventListener(KeyboardEvent.KEY_UP,keyupHandler);
		}
		
		public function start():void{
			addTarget(this);
		}
		
		public function sleep():void{
			removeTarget(this);
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
		//	trace("down",target,code)
			keylist.push(code);
			var keyString:String = getKeyAction(keylist,event.ctrlKey,event.shiftKey,event.altKey);
			var vo:KeyVO = keymap[keyString]
			if(vo!=null && vo.keyFunction != null){
				vo.keyFunction();
//				keylist.length = 0;
			}
			event.stopImmediatePropagation();
//			trace("down keylist : "+keylist)
		}
		
		public function keyupHandler(event:KeyboardEvent):void{
			var code:int = event.keyCode;
		//	trace("up",target,code,usedKeymap[code])
			if(code == 17 || code == 16){
				return;
			}
			
			usedKeymap[code] = false;
			var i:int = keylist.indexOf(code);
			if(i!=-1){
				keylist.splice(i,1);
			}
			delete usedKeymap[code]
			
			event.stopImmediatePropagation();
//			trace("up keylist : "+keylist)
		}
		
		public function reset():void{
			for(var s:String in usedKeymap){
				usedKeymap[s] = null;
				delete usedKeymap[s];
			}
			
			keylist.length = 0;
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
	import com.utils.key.KeyStroke;

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