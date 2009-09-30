package com.ai
{

	 	
	import flash.display.Shape;
	import flash.utils.getTimer;
	
	public final class Astar1 implements IPathfinding
	{
		private var c:Array;
		private var o:Array;
		private var d:int;  // 4 or 8 direction

		private var pa:Array;

		public function Astar1(d:int=4,s:Shape=null){
			this.d=d;
			if(d==4){
				pa = [[1, 0], [-1, 0], [0, 1], [0, -1]];
			}else {
				pa=[[1, 0], [-1, 0], [0, 1], [0, -1],[1,1],[1,-1],[-1,1],[-1,-1]];
			}
		} 
		public function go(map:Array,ox:int,oy:int,dx:int,dy:int):Array
		{
			if(map[oy][ox] != 1) {
				return null
			}
			if (map[dy][dx] != 1) {
				return null
			}
			if(ox==dx && oy==dy){
				return null
			}
			if(oy>map.length){
				return null
			}
			if(ox>map[0].length){
				return null
			}
			
			var tt:int=getTimer()
			o = new Array();
			c= new Array();
			var path:Array = new Array();
			var finded:Boolean = false;
			var sl:Array = new Array();
			var cp:int=0;
			var i:int=0;
			while(i<map.length){
				var temparray:Array = new Array();
				for (var j:int = 0; j<map[0].length; j++) {
					temparray.push(-1);
				}
				c.push(temparray);
				i++
			}
			o.push([0, ox, oy, 0]);
			c[o[0][2]][o[0][1]] = 0;
			var step:int = 1;
			while (!finded) {
				var sx:int = o[0][1];
				var sy:int = o[0][2];
				sl.push(o[0]);
				o.shift();
				for (var t:int = 0; t<d; t++) {
					if (pa[t][1]+sy>-1 && pa[t][0]+sx>-1 && pa[t][1]+sy<map.length && pa[t][0]+sx<map[0].length ){
					 	if(map[pa[t][1]+sy][pa[t][0]+sx] == 1) {
							if (c[pa[t][1]+sy][pa[t][0]+sx]<0) {
								if ((pa[t][1]+sy) == dy && (pa[t][0]+sx) == dx) {
									finded = true;
									cp = step-1;
								}
							c[pa[t][1]+sy][pa[t][0]+sx] = step-1;
							//var h:Number = Math.abs(dx-(pa[t][0]+sx))+Math.abs(dy-(pa[t][1]+sy));
							//var g:int = step; 
							//var f:int = g+h
							var ar:Array=[Math.abs(dx-(pa[t][0]+sx))+Math.abs(dy-(pa[t][1]+sy))+step, pa[t][0]+sx, pa[t][1]+sy, step-1]
							var low:int = 0;
							var high:int = o.length;
							var mid:int
							if (high == 0 || ar[0]>o[high-1][0]) {
								o.push(ar);
							} else {
								while (low<=high) {
									mid = int((low+high)/2);
									if(ar[0]>o[mid][0]){
										low = mid+1;
									} else if (ar[0]<o[mid][0]) {
										high = mid-1;
									} else {
										low = high+1;
									}
								}
								o.splice(low, 0, ar);
								//trace("apush",ar,o.length)
						   }
						}
					 }
				   }
				}
				step++;
				if (step>map.length*map[0].length) {
					return null
				}
				if(o.length==0){
					return null
				}
				if (finded == true) {
					while (cp>0) {
						path.push(sl[cp]);
						cp = sl[cp][3];
					}
					path.reverse();
					path.push([0, dx, dy, -1]);
					return path
					//for(var z:int=0;z<path.length;z++){
						//DrawMap.dp(s,path[z][1],path[z][2])
					//}
				}
				//trace(o.length)
			}
			return null
		}

		private function createCheckArray(arr:Array):void{
			//l1=[]
			var w:int=arr.length;
			var h:int=arr[0].length
			
			for(var i:int=0;i<w;i++){
				var tmp:Array=[]
				for(var j:int=0;j<h;j++){
					tmp.push(-1)
				}
			//	l1.push(tmp)
			}
		}
	}
}