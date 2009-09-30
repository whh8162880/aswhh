package com.map
{
	import com.ai.IPathfinding;
	import com.ai.astar.RFAstar;
	
	import flash.events.EventDispatcher;
	
	public class MapDataBase extends EventDispatcher
	{
		
		public var mapData:Array
		public var mapdatavo:MapDataVO
		public var astar:IPathfinding;
		public var maprenderdata:Array;
		public function MapDataBase(mapdata:Array,mapdatavo:MapDataVO,maprenderdata:Array = null,astar:IPathfinding = null){
			if(astar == null){
				astar = new RFAstar();
			}
			this.astar = astar;
			this.updata(mapdata,mapdatavo,maprenderdata); 
		}
		
		public function updata(mapdata:Array,mapdatavo:MapDataVO,maprenderdata:Array = null):void{
			this.mapData = mapdata;
			this.mapdatavo = mapdatavo
			this.maprenderdata = maprenderdata
			this.dispatchEvent(new MapDataEvent(MapDataEvent.UP_DATA,this));
		}
		
		public function getMapdata():Array{
			return mapData;
		}
		
		public function find(xfrom:int,yfrom:int,xto:int,yto:int):Array{
			return astar.go(mapData,xfrom,yfrom,xto,yto);
		}
		
		public function showCenterXY(x:int,y:int):Boolean{
			return false
		}
		

	}
}