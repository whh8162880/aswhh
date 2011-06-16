package com.theworld.module.game.city
{
	import com.event.RFEventDispatcher;
	
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public class CityModel extends RFEventDispatcher
	{
		public function CityModel(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function decoder(b:ByteArray):void{
			
		}
		
		public function getCityVO():CityVO{
			
		}
	}
}