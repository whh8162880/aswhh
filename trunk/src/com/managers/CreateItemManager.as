package com.managers
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	public class CreateItemManager
	{
		public function CreateItemManager()
		{
		}
		private static var key:Dictionary = new Dictionary();
		
		public static function getItem(p:Class):Object{
			if(key[p] == null){
				key[p] = [];
				key[p].emptys = [0]
				key[p].dict = new Dictionary()
			}
			
			return getItem2(key[p],p);
		}
		
		private static function getItem2(arr:Array,p:Class):Object{
			var index:int = (arr.emptys as Array).pop();
			var item:Object = arr[index];
			if(item == null){
				item = new p()
				arr[index] = item;
			}
			arr.dict[item] = index;
			if(arr.emptys.length == 0){
				arr.emptys.push(arr.length);
			}
			return item;
		}
		
		public static function removeItem(item:Object,removeStage:Boolean = true):void{
			var str:String = getQualifiedClassName(item);
			var c:Class = getDefinitionByName(str) as Class; 
			var arr:Array = key[c];
			if(item.hasOwnProperty("disponse")){
				item["disponse"]();
			}
			if(arr){
				var o:Object = arr.dict[item];
				if(o!=null){
					var i:int = int(o)
					delete arr.dict[item];
					arr.emptys.push(i);
				}
			}
			
			if(removeStage == true && item is DisplayObject && (item as DisplayObject).parent){
				(item as DisplayObject).parent.removeChild((item as DisplayObject))
			}
			
		}

	}
}