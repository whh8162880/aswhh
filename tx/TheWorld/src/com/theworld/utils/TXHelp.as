package com.theworld.utils
{
	import com.map.MapModel;
	import com.mvc.Controller;
	import com.mvc.Facade;
	import com.mvc.Model;
	import com.theworld.module.chat.ChatController;
	import com.theworld.module.chat.ChatModel;
	import com.theworld.module.chat.ChatView;
	import com.theworld.module.emote.EmoteModel;
	import com.theworld.module.game.city.CityModel;
	import com.theworld.module.txmap.TXMapController;
	import com.theworld.module.txmap.view.TXMapView;
	
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class TXHelp
	{
		public function TXHelp()
		{
		}
		
		private static var facade:Facade = Facade.instance;
		private static function getmodel(name:String,cls:Class):Model{
			var model:Model = facade.getModel(name);
			if(!model){
				model = new cls();
				facade.regModel(name,model);
			}
			return model;
		}
		
		
		
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//City
		//
		//---------------------------------------------------------------------------------------------------------------
		public static function get cityModel():CityModel{
			return getmodel("cityModel",CityModel) as CityModel;
		}
		
		
		
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Emote
		//
		//---------------------------------------------------------------------------------------------------------------
		public static function get emoteModel():EmoteModel{
			return getmodel("emoteModel",EmoteModel) as EmoteModel;
		}
		
		
		
		//---------------------------------------------------------------------------------------------------------------
		//
		// Chat
		//
		//---------------------------------------------------------------------------------------------------------------
		public static function get chatController():ChatController{
			var name:String = "chatController";
			var cotroller:ChatController = facade.getController(name) as ChatController;
			if(!cotroller){
				cotroller = new ChatController();
				cotroller.setModel(chatModel);
				cotroller.setView(new ChatView());
				facade.regController(name,cotroller);
			}
			return cotroller;
		}
		public static function get chatModel():ChatModel{
			return getmodel("chatModel",ChatModel) as ChatModel;
		}
		
		
		
		//---------------------------------------------------------------------------------------------------------------
		//
		// Map
		//
		//---------------------------------------------------------------------------------------------------------------
		public static function get mapController():TXMapController{
			var name:String = "mapController";
			var cotroller:TXMapController = facade.getController(name) as TXMapController;
			if(!cotroller){
				cotroller = new TXMapController();
				cotroller.setModel(mapModel);
				cotroller.setView(new TXMapView());
				facade.regController(name,cotroller);
			}
			return cotroller;
		}
		public static function get mapModel():MapModel{
			return getmodel("mapModel",MapModel) as MapModel;
		}
		
	}
}