package com.display.skin.skins
{
	import com.display.skin.SkinInteractiveBase;
	
	import flash.display.Shape;

	public class ListInteractive extends SkinInteractiveBase
	{
		public function ListInteractive()
		{
			var defulat:Shape = getSkin(0)
			skin = [
			defulat,
			/*mouseover*/getSkin(0.4,0xFFFFFF),
			/*selected*/getSkin(0.6),
			/*mouseoverselected*/getSkin(0.8),
			/*disabledDefault*/defulat,
			/*disabledmouseover*/defulat,
			/*disabledselected*/defulat,
			/*disabledselectedmouseover*/defulat]
			enabled = true
			super(skin);
		}
		
	}
}