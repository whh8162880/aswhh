package com.display.utils.describe
{
	public class VariablesInfo
	{
		private var typeDescription:XML;
		
		private var propertys:Array;
		public function VariablesInfo(typeDescription:XML)
		{
			this.typeDescription=typeDescription;
		}
		
		public function getPropertys():Array{
			
			if(propertys==null){
				var list:XMLList=typeDescription.descendants("variable");
				
				propertys=new Array();
				var name:String;
				for each(var item:XML in list){
					name=item.@name;
					propertys.push(name);
				}
			}
			
			return propertys;
		}

	}
}