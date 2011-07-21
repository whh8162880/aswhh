package com.utils
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * 
	 * @author whh
	 * 依赖 stage 
	 * 注意:依赖 stage 如果没有bindStage 程序将报错
	 * 依赖 stage
	 * 依赖 stage
	 * 依赖 stage
	 * 依赖 stage
	 */
	public class Work
	{
		public static var instance:Work = new Work();
		
		/**
		 * 看这里看这里 这个程序执行 依赖stage 所以先执行bindStage方法 再做其他操作 只需要执行一次 
		 * 注意:依赖stage 如果没有执行此操作 程序将报错 
		 * @param stage
		 * 
		 */		
		public static function bindStage(stage:Stage):void{
			instance.bindStage(stage);
		}
		
		/**
		 *  
		 * @param id
		 * @param datas
		 * @param handler
		 * handler	example:
		 * 		public function workHandler(data:*):void{
		 * 			//todo
		 * 		}
		 */		
		public static function addTask(id:String,datas:Array,handler:Function):void{
			instance.addTask(id,datas,handler);
		}
		
		public static function removeTask(id:String):void{
			instance.removeTask(id);
		}
		
		/**
		 * stage 用于监听Event.ENTER_FRAME事件;
		 */		
		private var stage:Stage;
		
		private var dict:Dictionary;
		
		private var eachTime:int;
		
		private var taskCount:int;
		
		public function Work()
		{
			dict = new Dictionary();
		}
		
		/**
		 * @param stage
		 * 
		 */		
		public function bindStage(stage:Stage):void{
			this.stage = stage;
		}
		
		/**
		 * 添加任务 
		 * 注意:依赖stage 如果没有bindStage 程序将报错 
		 * @param id
		 * @param datas
		 * @param handler
		 * 
		 */		
		public function addTask(id:String,datas:Array,handler:Function,doNow:Boolean = false):void{
			var task:WorkSpace
			var len:int;
			
			len = datas ? datas.length : 0;
			if(!len){
				return;
			}
			
			task = dict[id];
			if(!task){
				task = new WorkSpace(id);
				dict[id] = task;
				taskCount++;
				eachTime = (1000/stage.frameRate*calcTime)/taskCount;
			}
			
			task.datas = datas;
			task.handler = handler;
			task.index = 0;
			task.len = len;
			
			if(doNow){
				enterFrameHandler(null)
			}
			
			
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
		}
		
		/**
		 *为什么是0.618? 随便写的呗~ 黄金比例啊
		 *还有0.382 让给flashplayer去做渲染
		 *我是不是太仁慈了 具体这个值应该多少靠谱 嗯 兄弟 你们自己配~
		 */		
		private var calcTime:Number = 0.618;
		
		/**
		 * 移除任务
		 * 注意:依赖stage 如果没有bindStage 程序将报错 
		 * @param id
		 * 
		 */		
		public function removeTask(id:String):void{
			if(dict[id]){
				taskCount --;
				dict[id] = null;
				delete dict[id];
			}
			
			if(taskCount<=0){
				taskCount = 0;
				stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			}else{
				eachTime = (1000/stage.frameRate*calcTime)/taskCount;
			}
		}
		
		/**
		 * completeList 用于记录哪些任务已经完成完毕了 
		 */		
		private var completeList:Array = [];
		/**
		 * 执行任务 
		 * @param event
		 * 
		 */		
		private function enterFrameHandler(event:Event):void{
			var t:int;
			for each(var task:WorkSpace in dict){
				t = getTimer();
				while((getTimer()-t)<eachTime){
					if(task.doFunction()){
						completeList.push(task.id);
						break;
					}
				}
			}
			while(completeList.length){
				removeTask(completeList.pop());
			}
		}
		
	}
}

class WorkSpace{
	public function WorkSpace(id:String){
		this.id = id;
	}
	
	public var id:String;
	public var datas:Array;
	public var len:int;
	public var index:int;
	public var handler:Function;
	
	public function doFunction():Boolean{
		handler(datas[index]);
		return ++index>=len;
	}
}