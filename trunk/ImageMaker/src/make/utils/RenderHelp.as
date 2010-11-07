package make.utils
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	public class RenderHelp
	{
		public function RenderHelp(func:Function,time:int=10)
		{
			this.time = time;
			this.func = func;
		}
		
		public var time:int;
		
		public var func:Function;
		
		private var index:int;
		
		private var isRender:Boolean
		
		private var data:Object;
		
		public function render(data:Object = null):void{
			this.data = data;
			if(isRender){
				return;
			}
			isRender = true;
			index = setTimeout(doRender,time);
		}
		
		public function cancel():void{
			clearTimeout(index);
		}
		
		private function doRender():void{
			isRender = false;
			func(data);
		}
	}
}