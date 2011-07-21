package rfcomponents.zother
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import rfcomponents.SkinBase;
	
	public class MathDragHelp extends DragHelp
	{
		public function MathDragHelp(target:Sprite, rect:Rectangle=null)
		{
			super(target, rect);
		}
		
		override protected function moveHandler(event:MouseEvent):void{
			dx = target.mouseX - prex;
			dy = target.mouseY - prey;
			
			prex = target.mouseX;
			prey = target.mouseY;
			
			this.dispatchEvent(new Event(Event.CHANGE));
		//	event.updateAfterEvent();
		}
	}
}