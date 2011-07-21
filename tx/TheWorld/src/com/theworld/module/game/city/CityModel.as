package com.theworld.module.game.city
{
	import com.event.RFEventDispatcher;
	import com.mvc.Model;
	
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class CityModel extends Model
	{
		public function CityModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var citydict:Dictionary;
		private var citys:Array;
		public function decoder(b:ByteArray):void{
			b.position = 0;
			b.inflate();
			citys = b.readObject();
			citydict = new Dictionary();
			for each(var vo:CityVO in citys){
				citydict[vo.guid] = vo;
			}
		}
		
		public function getCityVO(id:String):CityVO{
			return citydict[id];
		}
	}
}