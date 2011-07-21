package com.mvc
{
	import com.event.RFEventDispatcher;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class Facade extends RFEventDispatcher
	{
		public function Facade()
		{
			super();
			
			modelDict = new Dictionary();
			controllerDict = new Dictionary();
		}
		
		public static var instance:Facade = new Facade();
		
		
		private var modelDict:Dictionary;
		public function regModel(name:String,model:Model):void{
			var temp:Model = modelDict[name];
			if(temp){
				temp.dispose();
			}
			modelDict[name] = model;
		}
		public function getModel(name:String):Model{
			return modelDict[name];
		}
		public function removeModel(name:String):void{
			var temp:Model = modelDict[name];
			if(temp){
				temp.dispose();
			}
			modelDict[name] = null;
			delete modelDict[name]
		}
		
		private var controllerDict:Dictionary;
		public function regController(name:String,ctl:Controller):void{
			var temp:Controller = controllerDict[name];
			if(temp){
				temp.dispose();
			}
			controllerDict[name] = ctl;
		}
		public function getController(name:String):Controller{
			return controllerDict[name];
		}
		public function removeController(name:String):void{
			var temp:Controller = controllerDict[name];
			if(temp){
				temp.dispose();
			}
			controllerDict[name] = null;
			delete controllerDict[name]
		}
		
		
	}
}