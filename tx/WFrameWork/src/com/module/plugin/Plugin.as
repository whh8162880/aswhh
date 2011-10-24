package com.module.plugin
{
	import com.module.plugin.vo.PluginCommandVO;
	import com.utils.MoreAction;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class Plugin extends EventDispatcher
	{
		/**
		 * 名字 
		 */		
		public var name:String;
		
		/**
		 * 插件功能说明 
		 */		
		public var disc:String;
		
		/**
		 * 管理器 
		 */		
		public var manager:PluginManager;
		
		/**
		 * command 注册储存器 
		 */		
		public var commandDict:Dictionary;
		
		/**
		 * 同种类型请求 回馈管理
		 */		
		public var moreActionDict:Dictionary;
		
		/**
		 * 构造函数
		 * @param name
		 * 
		 */		
		public function Plugin(name:String)
		{
			this.name = name;
			commandDict = new Dictionary();
			moreActionDict = new Dictionary();
			init();
		}
		
		/**
		 * 初始化 
		 */		
		protected function init():void{
			
		}
		
		/**
		 * 多请求服务 
		 * @param name
		 * @param o
		 * 
		 */		
		protected function addAction(name:String,o:*):void{
			var a:MoreAction = moreActionDict[name];
			if(!a){
				a = new MoreAction(name);
				moreActionDict[name] = a;
			}
			a.addAction(o);
		}
		
		protected function removeAction(name:String):void{
			var a:MoreAction = moreActionDict[name];
			if(!a){
				return;
			}
			a.dispose();
			moreActionDict[name] = null;
			delete moreActionDict[name];
		}
		
		protected function getAction(name:String,dispose:Boolean = true):Array{
			var a:MoreAction = moreActionDict[name];
			if(!a){
				return null;
			}
			var arr:Array = a.actions.concat();
			if(dispose){
				a.dispose();
				moreActionDict[name] = null;
				delete moreActionDict[name];
			}
			return arr;
		}
		
		/**
		 * 注册管理器 
		 * @param manager
		 * 
		 */		
		public function setManager(manager:PluginManager):void{
			this.manager = manager;
		}
		
		/**
		 * 注册command 以方便manager调用 
		 * @param name
		 * @param func
		 */		
		public function regCommand(command:String,func:Function,disc:String):void{
			commandDict[command] = new PluginCommandVO().decode(command,func,disc);
		}
		
		/**
		 * 执行command 
		 * @param command
		 * @param func
		 */		
		public function doCommand(command:String,args:Array):void{
			var vo:PluginCommandVO = commandDict[command];
			if(!vo || vo.func == null){
				return;
			}
			vo.func.apply(this,args);
		}
		
		/**
		 * 开始
		 */		
		public function start():void{
			
		}
		
		/**
		 * 休息 
		 */		
		public function sleep():void{
			
		}
		
		/**
		 * 卸载plugin 
		 * 
		 */		
		public function dispose():void{
			for(var type:String in commandDict){
				commandDict[type] = null;
			}
			commandDict = new Dictionary();
			manager = null
		}
		
		/**
		 * plugin说明
		 * @return 
		 */		
		override public function toString():String{
			return name + "		" + disc;
		}
		
		/**
		 * command说明
		 * @return 
		 */
		public function toCommandString():String{
			var arr:Array = [];
			var str:String = name + "有以下可以执行的命令\n";
			var vo:PluginCommandVO
			for each(vo in commandDict){
				arr.push(vo);
			}
			arr = arr.sortOn("command");
			for each(vo in arr){
				str += "	"+vo.toString()+"\n"
			}
			return str;
		}
	}
}