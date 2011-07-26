package com.utils
{
	import flash.utils.Dictionary;
	/**
	 * 插入执行. 
	 *   原理类似于EventDispatcher
	 *   这个属于轻量级的
	 * @author wang
	 * 
	 */
	public class InsertFunction
	{
		private static var insertFunctionDict:Dictionary = new Dictionary();
		/**
		 * 对某个id的事件 插入一条执行代码 
		 * @param id
		 * @param func
		 * 		func 必须要有至少一个参数 function(id:String);
		 */		
		public static function regInsertFunction(id:String,func:Function):void{
			var vo:InsertVO = insertFunctionDict[id];
			if(!vo){
				vo = new InsertVO(id);
				insertFunctionDict[id] = vo;
			}
			vo.regFunction(func);
		}
		
		/**
		 * 移除 
		 * @param id
		 * @param func
		 * 
		 */		
		public static function removeInsertFunction(id:String,func:Function):void{
			var vo:InsertVO = insertFunctionDict[id];
			if(!vo){
				return;
			}
			if(!vo.removeFunction(func)){
				insertFunctionDict[id] = null;
				delete insertFunctionDict[id];
			}
		}
		
		/**
		 * 执行某一事件
		 * @param id
		 * @param args
		 *   执行参数 用户需要自己定规则。
		 *   example: 
		 *   	class A{
		 * 			
		 * 			InsertFunction.regInsertFunction("id",doFunction);
		 * 
		 * 			function doFunction(id:String,name:String,setp:int):void{
		 * 				trace(id,name,setp);
		 * 			}
		 * 		}
		 * 
		 * 		class B{
		 * 			InsertFunction.doInsertFunction("id",name,setp);
		 * 		}
		 */		
		public static function doInsertFunction(id:String,...args):void{
			var vo:InsertVO = insertFunctionDict[id];
			if(!vo){
				return;
			}
			args.unshift(id);
			vo.doFunction(args);
		}
	}
}
/**
 * 事件处理器
 * 严格来说 它不是一个vo 咳咳 
 * @author wang
 * 
 */
class InsertVO{
	public var id:String;
	public var funcs:Array;
	public function InsertVO(id:String){
		this.id = id;
		this.funcs = [];
	}
	/**
	 * 注册一个function
	 * @param func
	 * 
	 */	
	public function regFunction(func:Function):void{
		if(func==null){
			return;
		}
		if(funcs.indexOf(func)==-1){
			funcs.push(func);
		}
	}
	/**
	 *移除一个function 
	 * @param func
	 * 
	 */	
	public function removeFunction(func:Function):Boolean{
		var i:int = funcs.indexOf(func);
		if(i>=0){
			funcs.splice(i,1);
		}
		return funcs.length>0;
	}
	/**
	 * 执行！ 
	 * @param arg
	 * 
	 */	
	public function doFunction(arg:Array):void{
		for each(var f:Function in funcs){
			f.apply(this,arg);
		}
	}
}