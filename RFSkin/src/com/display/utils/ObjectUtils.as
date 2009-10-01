package com.display.utils
{
	import com.display.utils.describe.DescribeTypeCache;
	import com.display.utils.describe.VariablesInfo;
	
	import flash.utils.getQualifiedClassName;
	
	public class ObjectUtils
	{
		public function ObjectUtils()
		{
		}
		
		public static function getObjectPropertys(o:Object):Object{
			var qname : String = getQualifiedClassName(o);
			if(qname == "Object"){
				return o;
			}else{
				var variablesInfo : VariablesInfo = DescribeTypeCache.describeType(o).variablesInfo;
				var propertys : Array = variablesInfo.getPropertys();
				var t:Object = {}
				for each(var propName:String  in propertys)
				{
					t[propName] = o[propName]
				}
			}
			return t;
		}

	}
}