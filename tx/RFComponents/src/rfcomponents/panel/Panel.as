package rfcomponents.panel
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Rectangle;
	
	import rfcomponents.SkinBase;
	import rfcomponents.panel.event.PanelEvent;
	import rfcomponents.zother.DragHelp;
	
	public class Panel extends SkinBase
	{
		protected var dragHelp:DragHelp;
		public function Panel()
		{
			super();
		}
		
		public function show(locat:DisplayObjectContainer = null):void{
			if(locat){
				locat.addChild(_skin);
				this.dispatchEvent(new PanelEvent(PanelEvent.SHOW));
			}
		}
		
		public function hide(event:Event = null):void{
			remove();
			this.dispatchEvent(new PanelEvent(PanelEvent.HIDE));
		}
		
		
		override protected function setStage(stage:Stage):void{
			super.setStage(stage);
			if(!dragHelp && dragEnabled){
				dragHelp = new DragHelp(_skin,new Rectangle(0,0,stage.stageWidth,stage.stageHeight));
				setDrag();
			}
			bindResize(stage);
		}
		
		protected function setDrag():void{
			dragHelp.bindDragTarget(_skin,new Rectangle(0,0,_skin.width,30))
		}
		
		override protected function doResize(width:int, height:int):void{
			if(dragHelp){
				dragHelp.setDragRect(new Rectangle(0,0,width,height));
			}
		}
		
		protected var dragEnabled:Boolean = true;
		public function setDragEnabled(value:Boolean):void{
			dragEnabled = value;
			if(dragHelp){
				dragHelp.enabled = value;
			}
		}
	}
}