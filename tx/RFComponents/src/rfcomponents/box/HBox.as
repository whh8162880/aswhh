package rfcomponents.box
{
	import flash.display.DisplayObject;

	public class HBox extends Box
	{
		public function HBox()
		{
			super();
		}
		
		override protected function refreshPoint():void{
			h = 0;
			var i:int;
			var d:DisplayObject;
			for (i=0; i < numChildren; i++) 
			{
				d = getChildAt(i);
				if(d.height > h){
					h = d.height;
				}
			}
			
			w = 0;
			for (i=0; i < numChildren; i++) 
			{
				d = getChildAt(i);
				d.x = w;
				w += d.width + _gap;
				
				d.y = (h - d.height)/2;
			}
			
			w -= _gap;
		}
	}
}