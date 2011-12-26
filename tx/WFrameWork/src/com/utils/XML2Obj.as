package com.utils
{
	public class XML2Obj
	{
		public function XML2Obj()
		{
		}
		
		
		public static function xml2obj(xml:XML):Object{
			var o:Object;
			var p:String;
			var temp:XML;
			var xmllist:XMLList;
			
			if(xml.hasSimpleContent() && !xml.attributes().length()){
				return xml.toString();
			}
			
			o = {};
			for each(temp in xml.attributes()){
				p = temp.name();
				o[p] = temp.toString();
			}
			
			xmllist = xml.children();
			while(xmllist.length()){
				temp = xmllist[0];
				p = temp.name();
				if(!p){
					//empty property
					o["value"] = xmllist.toString();
					return o;
				}
				xmllist = xml.child(p);
				if(xmllist.length()>1){
					//array
					var arr:Array = [];
					for each(temp in xmllist){
						arr.push(xml2obj(temp));
					}
					o[p] = arr;
					xml = XML(xml.replace(p,"").toXMLString());
				}else{
					//object
					o[p] = xml2obj(temp);
					xml = XML(xml.replace(p,"").toXMLString());
				}
				xmllist = xml.children()
			}
				
			return o;
		}
	}
}