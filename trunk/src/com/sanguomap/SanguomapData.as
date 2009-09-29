package com.sanguomap
{
	import com.ai.IPathfinding;
	import com.map.MapDataBase;
	import com.map.MapDataVO;
	import com.map.vo.MapItemVO;
	
	import flash.geom.Point;

	public class SanguomapData extends MapDataBase
	{
		public function SanguomapData(mapdata:Array=null, mapdatavo:MapDataVO=null, maprenderdata:Array=null, astar:IPathfinding=null)
		{
			if(!mapdatavo){
				mapdatavo =new MapDataVO(0,0,15,10,48);
			}
			super(mapdata, mapdatavo, maprenderdata, astar);
		}
		
		public function regItems(items:Array):void{
			for each(var item:MapItemVO in items){
				regItem(item);
			}
		}
		
		public function regItem(item:MapItemVO):void{
			if(item == null) {
				return;
			}
			
			if(maprenderdata == null){
				maprenderdata = [];
			}
			
			maprenderdata.push(item);
			
		}
		
	}
}