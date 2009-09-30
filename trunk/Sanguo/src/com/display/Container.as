package com.display
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class Container extends LayoutBase
	{
		protected var _skin:DisplayObjectContainer;
		protected var dict:Dictionary
		protected var _data:Object
		protected var inited:Boolean
		protected var addToStaged:Boolean
		public function Container(_skin:DisplayObjectContainer = null)
		{
			addToStaged = false;
			inited = false;
			dict = new Dictionary()
			if(_skin){
				this.skin = _skin;
			}else{
				this.skin = initSkin();
			}
			
			this.addEventListener(Event.ADDED_TO_STAGE,toStageHandler);
			this.addEventListener(Event.REMOVED_FROM_STAGE,toStageHandler);
			super();
		}
		
		protected function initSkin():DisplayObjectContainer{
			return null
		}
		
		public function set skin(value:DisplayObjectContainer):void{
			resetSkin(value);
			this._skin = value;
			if(this._skin)
				createSkin();
		}
		
		public function get skin():DisplayObjectContainer{
			return _skin;
		}
		
		protected function createSkin():void{
			
		}
		
		private function resetSkin(value:DisplayObjectContainer):DisplayObjectContainer{
			if(_skin == null){
				return null;
			}
			
			var d:DisplayObjectContainer = _skin.parent;
			if(d != null){
				d.removeChild(_skin);
			}
			
			if(value == null){
				return null;
			}
			
			value.x = _skin.x;
			value.y = _skin.y;
			
			if(d!=null){
				d.addChild(value);
			}
			
			_skin = null
			
			return d;
		}
		
		public function regDisplayObjectToProperty(d:DisplayObject,propertyname:String):void{
			if(dict[propertyname] != null){
				dict[propertyname] = null;
			}
			dict[propertyname] = d;
		}
		
		public function setValue(propertyname:String,value:Object):void{
			var d:DisplayObject = dict[propertyname]
			if(d==null){
				return;
			}
			
			if(d.hasOwnProperty("htmlText") == true){
				d["htmlText"] = value;
			}else if(d.hasOwnProperty("data") == true){
				d["data"] = value;
			}
		}
		
		
		public function set data(value:Object):void{
			inited = false
			_data = value;
			if(_data && addToStaged){
				doData()
				inited = true
			}
		}
		
		public function get data():Object{
			return _data;
		}
		
		protected function doData():void{
			
		}
		
		protected function toStageHandler(event:Event):void{
			if(event.type == Event.ADDED_TO_STAGE){
				addToStaged = true;
				if(_data && inited == false){
					doData();
				}
				addToStage()
			}else{
				addToStaged = false;
				removeFromStage();
			}
		}
		
		protected function addToStage():void{
			
		}
		
		protected function removeFromStage():void{
			
		}
	}
}