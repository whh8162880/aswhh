package rfcomponents.box
{
	import flash.display.DisplayObject;

	public class VBox extends Box
	{
		public function VBox()
		{
			super();
		}
		
		override protected function refreshPoint():void{
			w = 0;
			var i:int;
			var d:DisplayObject;
			for (i=0; i < numChildren; i++) 
			{
				d = getChildAt(i);
				if(d.width > w){
					w = d.width;
				}
			}
			
			h = 0;
			for (i=0; i < numChildren; i++) 
			{
				d = getChildAt(i);
				d.x = w;
				h += d.height + _gap;
				
				d.y = (w - d.width)/2;
			}
			
			h -= _gap;
		}
	}
}