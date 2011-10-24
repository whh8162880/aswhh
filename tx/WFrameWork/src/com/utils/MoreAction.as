package com.utils
{
	public class MoreAction
	{
		public var type:String;
		public function MoreAction(type:String)
		{
			this.type = type;
			actions = [];
		}
		
		public var actions:Array; 
		public function addAction(o:*):void{
			if(actions.indexOf(o) == -1){
				actions.push(o);
			}
		}
		
		public function removeAction(o:*):void{
			var i:int = actions.indexOf(o);
			if(i!=-1){
				actions.splice(i,1);
			}
		}
		
		public function dispose():void{
			actions.length = 0;
		}
		
	}
}