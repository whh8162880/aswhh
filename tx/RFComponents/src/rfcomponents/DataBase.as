package rfcomponents
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class DataBase extends EventDispatcher
	{
		public function DataBase(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Data
		//
		//---------------------------------------------------------------------------------------------------------------
		protected var _data:Object;
		public function set data(value:Object):void{
			_data = value;
			doData();
		}
		public function get data():Object{
			return _data;
		}
		protected function doData():void{
			
		}
		
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Enabled
		//
		//---------------------------------------------------------------------------------------------------------------
		protected var _enabled:Boolean = true;
		public function set enabled(value:Boolean):void{
			_enabled = value;
			doEnabled();
		}
		public function get enabled():Boolean{
			return _enabled;
		}
		protected function doEnabled():void{
			
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Dispose
		//
		//---------------------------------------------------------------------------------------------------------------
		public function dispose():void{
			
		}
		
		public function clear():void{
			
		}
		
	}
}