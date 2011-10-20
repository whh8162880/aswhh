package rfcomponents.progressbar
{
	import flash.display.Sprite;
	
	import rfcomponents.text.Text;
	
	public class ProgressBar extends Text
	{
		public function ProgressBar(skin:Sprite = null)
		{
			if(skin){
				this.skin = skin;
			}
			super();
		}
		
		protected var current:Number;
		protected var totle:Number;
		public function progress(current:Number,totle:Number):void{
			this.current = current;
			this.totle = totle;
			doProgress();
		}
		
		protected function doProgress():void{
			
		}
	}
}