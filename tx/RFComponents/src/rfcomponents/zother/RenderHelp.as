package rfcomponents.zother
{
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class RenderHelp
	{
		private var types:Array;
		private var typeDict:Dictionary;
		private var index:int;
		private var time:int;
		private var isRender:Boolean;
		public function RenderHelp(time:int)
		{
			typeDict = new Dictionary();
			types = [];
		}	
		
		public function addRender(type:String,func:Function,...args):void{
			var vo:RenderVO = typeDict[type];
			if(!vo){
				vo = new RenderVO(type);
				typeDict[type] = vo;
				types.push(vo);
			}
			vo.func = func;
			vo.args = args;
			if(isRender){
				return;
			}
			isRender = true;
			index = setTimeout(render,time);
		}
		
		private function render():void{
			for each(var vo:RenderVO in types){
				vo.func.apply(this,vo.args);
			}
			clearRender();
		}
		
		public function clearRender(type:String=null):void{
			var vo:RenderVO;
			isRender = false;
			if(!type){
				for each(vo in types){
					typeDict[vo.type] = null;
					delete typeDict[vo.type];
				}
				types.length = 0;
				clearTimeout(index);
				return;
			}
			vo = typeDict[type];
			if(!vo){
				return;
			}
			var i:int = types.indexOf(vo);
			types.splice(i,1);
			if(!types.length){
				clearTimeout(index);
			}
		}
	}
}

class RenderVO{
	public function RenderVO(type:String):void{
		this.type = type;
	}
	
	public var type:String;
	
	public var func:Function;
	
	public var args:Array;
}