package com.theworld.utils
{
	import com.theworld.module.game.city.CityModel;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class TXHelp
	{
		public function TXHelp()
		{
		}
		
		public static var txdict:Dictionary = new Dictionary();
		public static function getmodel(name:String,cls:Class):EventDispatcher{
			if(!txdict[name]){
				txdict[name] = new cls();
			}
			return txdict[name];
		}
		
		public static function get cityModel():CityModel{
			return getmodel("CityModel",CityModel) as CityModel;
		}
	}
}