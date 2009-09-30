package com.ai.astar
{
	import com.youbt.utils.ArrayUtil;
	
	public class RFAStarOpenList
	{
		private var list:Array
		private var wayList:Array
		private var w:int;
		private var h:int;
		public function RFAStarOpenList()
		{
			this.w = w;
			this.h = h;
			list = [];
			wayList = []
			
		}
		//[x,y,f,g,h,p]
		private var minH:int = 999999999
		public var minNode:Array
		public function add(x:int,y:int,g:int,h:int,parent:Array):void{
			var index:int = x*w+y
			var node:Array = list[index];
			if(node==null){
				node = [x,y]
			}else if(node[2]<g+h){
				return;
			}
//			else{
//				ArrayUtil.remove(wayList,node)
//			}
			node[2] = g+h			//F
			node[3] = g				//G
			node[4] = h				//H
			node[5] = parent		//P
			
			if(minH>h){
				minH = h
				minNode = node
			}
			
			list[index] = node
			
			wayList.splice(getPushIndex(node[2]),0,node)
			
		}
		
		public function reset(w:int,h:int):void{
			this.w = w;
			this.h = h;
			list.length = 0;
			wayList.length = 0;
			
			minH = 999999999
			minNode = null
		}
		
		public function size():int{
			return wayList.length
		}
		
		public function popBastNode():Array{
			return wayList.shift();
		}
		
		public function getList():Array{
			return list;
		}
		
		private function getPushIndex(f:int):int{
			//todo
			var length:int = wayList.length-1
			if(length < 0){
				return 0
			}
			
			var flag:int
			var num:int = length + 1
			var index:int = 0 
			
			while(num>1){
				flag = num & 1
				num = (num+flag)>>1
				if(f<=wayList[index][2]){
					index -= num
					if(index<0) index = 0
				}else{
					index += num
					if(index>=length){
						index = length-1
					}
				}
			}
			
			if(f>wayList[index][2]){
				return ++index
			}else{
				return index
			}
		}
		

	}
}