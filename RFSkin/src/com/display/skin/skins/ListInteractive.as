package com.display.skin.skins
{
	import com.display.skin.SkinInteractiveBase;
	
	import flash.display.Shape;

	public class ListInteractive extends SkinInteractiveBase
	{
		public function ListInteractive()
		{
			skin = [
			getSkin(0),
			/*mouseover*/getSkin(0.4,0xFFFFFF),
			/*selected*/getSkin(0.6),
			/*mouseoverselected*/getSkin(0.8),
			/*disabledDefault*/getSkin(0),
			/*disabledmouseover*/getSkin(0),
			/*disabledselected*/getSkin(0),
			/*disabledselectedmouseover*/getSkin(0)]
			enabled = true
			super(skin);
		}
		
	}
}