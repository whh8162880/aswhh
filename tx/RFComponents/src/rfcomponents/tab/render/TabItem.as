package rfcomponents.tab.render
{
	import flash.display.DisplayObject;
	
	import rfcomponents.button.Button;
	
	public class TabItem extends Button
	{
		public function TabItem()
		{
			super();
		}
		
		public var target:DisplayObject;
		
		override protected function doSelected():void{
			
		}
	}
}