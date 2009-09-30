package com.map
{
	public class MapDisplayDataFilter
	{
		public function MapDisplayDataFilter()
		{
		}
		
		public function getDatas(datas:Array,dataLegth:int,x:Number,y:Number,width:Number,height:Number):Array{
			var arr:Array = []
			
			for(var i:int = x;i<width+x;i++){
				for(var j:int = y;j<height+y;j++){
					var t:int = i*dataLegth+j
					if(datas[t]){
						arr.push(datas[t]);
					}
				}
			}
			
			return arr;
		}

	}
}