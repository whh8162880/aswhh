package com.avater
{
	import com.display.LayoutType;
	import com.display.text.Text;
	
	import flash.display.DisplayObjectContainer;
	import flash.filters.GlowFilter;
	
	public class NickNameTitleItem extends AvaterTitleItem
	{
		public function NickNameTitleItem()
		{
			super(null,LayoutType.HORIZONTAL, false);
		}
		
		override protected function initSkin():DisplayObjectContainer{
			var t:Text
			t = new Text(40)
			t.textColor = 0xFFFFFF
			t.setTextType("Lv:{0}")
			t.selectable = false
			t.filters = [new GlowFilter(0, 100, 2, 2, 5, 1, false, false)];
			regDisplayObjectToProperty(t,"level")
			addChild(t);
			
			t = new Text(200);
			t.textColor = 0xFFFFFF
			t.selectable = false
			t.filters = [new GlowFilter(0, 100, 2, 2, 5, 1, false, false)];
			regDisplayObjectToProperty(t,"nickname")
			addChild(t);
			
			return this;
		}
		
		override protected function createSkin():void{
			
		}
	}
}