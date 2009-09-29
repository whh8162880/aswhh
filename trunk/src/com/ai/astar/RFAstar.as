package com.ai.astar
{
	import com.ai.IPathfinding;
	/**
	 * A* 寻路
	 * @author whh
	 * 
	 */	
	public class RFAstar implements IPathfinding
	{
		private const maxLength:int = 10000;
		
		
		private var map:Array
		
		private var openList:RFAStarOpenList
		
		private var aSurOff:Array
		
		
		
		public function RFAstar()
		{
			openList = new RFAStarOpenList()
			aSurOff = [
				[-1,-1],[0,-1],[1,-1],
				[-1, 0],       [1, 0],
				[-1, 1],[0, 1],[1, 1]
			]
			
//			aSurOff = [
//						[0,-1]
//				[-1, 0],       [1, 0],
//						[0, 1]
//			]
//			var map:Array = []
//			
//			for(var i:int = 0;i<100;i++){
//				map.push([])
//				for(var j:int = 0;j<80;j++){
//					map[i][j] = 1
//				}
//			}
//			
//			map[99][79] = 0
//			
//			go(map,0,0,99,79)
			
		}
		
		private var h:int
		private var w:int
		
		public function getList():Array{
			return openList.getList();
		}
		
		private var tempMap:Array
		public function go(map:Array,xfrom:int,yfrom:int,xto:int,yto:int):Array{
			if(map == null){
				return null
			} 
			
//			if(map[xfrom][yfrom] != 0){
//				return null
//			}
//			
//			if(map[xto][yto] != 0){
//				return null
//			}
			
			if(xfrom==xto && yfrom==yto){
				return null
			}
			
			if(yfrom>map.length){
				return null
			}
			if(xfrom>map[0].length){
				return null
			}
			
			tempMap = map
			
			this.map = []
			
			this.h = map.length
			this.w = map[0] ? map[0].length : 0
			var i:int
			var j:int
			while(i<w){
				var temparray:Array = [];
				j = 0
				while (j<h) {
					temparray.push(map[j][i] ? 0 : 1);
					j++
				}
				this.map.push(temparray);
//				trace("["+temparray+"],")
				i++
			}
			
			openList.reset(w,h);
			
			return find(xfrom,yfrom,xto,yto)
		}
		
		
		private var currentLength:int
		public function find(xfrom:int,yfrom:int,xto:int,yto:int):Array{
			var i:int
			var j:int
			var arr:Array
			
			
			currentLength = 0
			openList.add(xfrom,yfrom,0,Math.abs(xto - yto)*10+Math.abs(yto - yfrom)*10,null)
			var node:Array
			while(openList.size()){
				if(currentLength>maxLength) 
					break;
				node = openList.popBastNode()
				var x:int = node[0]
				var y:int = node[1]
				var g:int = node[3]
				if(map[x][y] == 1){
					continue
				}
				map[x][y] = 1
				if((x == xto && y ==yto) == true){
					return format(node);
				}
				
				for each(arr in aSurOff){
					i = arr[0]+x
					j = arr[1]+y
					if((i>=0 && j>=0 && i<w && j<h && !map[i][j]/* && ((tempMap[i][y] || tempMap[x][j]) || (i==x || j==y))*/) == false) 
						continue;
						
					openList.add(i,j,i == x && j == y ?  0 : Math.abs( i - x + j - y) == 1 ? 10+g : 14+g,(Math.abs(xto - i)+Math.abs(yto - j))*10,node)
				}
				
				currentLength++
			}
			
//			node = openList.popBastNode()
			
			return null
			
		}
		
		private function format(node:Array):Array{
			var arr:Array = []
			var i:int = 0
			while(node){
				arr.push([node[4],node[0],node[1]])
				node = node[5]
				i++
			}
//			arr.shift()
//			i = arr.length
//			if(i>0){
//				arr[i-1][3] = -1;
//			}
			arr.reverse();
			arr.shift()
			
			while(i<arr.length){
				if(i != arr.length -1){
					arr[i].push(i)
				}else{
					arr[i].push(-1)
				}
				i++
			}
			return arr;
		}
	}
}