package rfcomponents
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	public class SkinBase extends Size
	{
		protected var _name:String;
		public function SkinBase()
		{
			listenerDict  = new Dictionary();
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Skin
		//
		//---------------------------------------------------------------------------------------------------------------
		protected var _skin:Sprite;
		public function set skin(skin:Sprite):void{
			_skin = skin;
			if(!_skin){
				return;
			}
			_width = _skin.width;
			_height = _skin.height;
			_skin.addEventListener(Event.ADDED_TO_STAGE,stageHandler);
			_skin.addEventListener(Event.REMOVED_FROM_STAGE,stageHandler);
			bindComponents();
			bindView();
		}
		public function get skin():Sprite{
			return _skin;
		}
		protected function bindComponents():void{
			
		}
		protected function bindView():void{
			
		}
		
		protected function stageHandler(event:Event):void{
			if(event.type == Event.ADDED_TO_STAGE){
				doAddtoStage();
				setStage(_skin.stage);
			}else{
				doRemoveFromStage();
			}
		}
		protected function doAddtoStage():void{
			
		}
		protected function doRemoveFromStage():void{
			
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//   Create
		//
		//---------------------------------------------------------------------------------------------------------------
		public function create(width:int,height:int,color:int = 0xFFFFFF,line:Boolean = true):void{
			var s:Sprite = new Sprite();
			s.graphics.beginFill(color);
			s.graphics.drawRect(0,0,width,height);
			s.graphics.endFill();
			
			if(line){
				s.graphics.lineStyle(1);
				s.graphics.drawRect(0,0,width-1,height-1);
			}
			
			s.scrollRect = new Rectangle(0,0,width+1,height+1);
			skin = s;
			
			_width = width;
			_height = height;
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//   X
		//
		//---------------------------------------------------------------------------------------------------------------
		public function set x(value:Number):void{
			_skin.x = value;
		}
		public function get x():Number{
			return _skin.x;
		}
		
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//   Y
		//
		//---------------------------------------------------------------------------------------------------------------
		public function set y(value:Number):void{
			_skin.y = value;
		}
		public function get y():Number{
			return _skin.y;
		}
		
		public function moveTo(x:int,y:int):void{
			_skin.x = x;
			_skin.y = y;
		}
		
		
		protected var _selected:Boolean;
		public function set selected(value:Boolean):void{
			_selected = value;
			this.dispatchEvent(new Event(Event.SELECT));
			doSelected();
		}
		public function get selected():Boolean{
			return _selected;
		}
		protected function doSelected():void{
			
		}
		
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Stage
		//
		//---------------------------------------------------------------------------------------------------------------
		protected var stage:Stage;
		protected function setStage(stage:Stage):void{
			this.stage = stage;
			doStage();
		}
		protected function doStage():void{
			
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Resize
		//
		//---------------------------------------------------------------------------------------------------------------
		public function bindResize(stage:Stage):void{
			if(stage){
				this.stage = stage;
				stage.addEventListener(Event.RESIZE,resizeHander);
			}
		}
		public function removeResize():void{
			if(stage){
				stage.removeEventListener(Event.RESIZE,resizeHander);
			}
		}
		protected function resizeHander(event:Event):void{
			doResize(stage.stageWidth,stage.stageHeight);
		}
		protected function doResize(width:int,height:int):void{
			
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Visible
		//
		//---------------------------------------------------------------------------------------------------------------
		public function set visible(value:Boolean):void{
			_skin.visible = value;
			doVisible();
		}
		public function get visible():Boolean{
			return _skin.visible;
		}
		protected function doVisible():void{
			
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//EventDispatch
		//
		//---------------------------------------------------------------------------------------------------------------
		protected var listenerDict:Dictionary;
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			_skin.addEventListener(type,dispatchHandler,useCapture,priority,useWeakReference);
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
			listenerDict[type] = int(listenerDict[type])+1;
		}
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			listenerDict[type] = int(listenerDict[type])-1;
			if(listenerDict[type]<1){
				delete listenerDict[type];
				_skin.removeEventListener(type,dispatchHandler,useCapture);
			}
			super.removeEventListener(type,listener,useCapture);
		}
		protected function dispatchHandler(event:Event):void{
			if(_enabled){
				dispatchEvent(event);
			}
		}

		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Child
		//
		//---------------------------------------------------------------------------------------------------------------
		public function addChild(child:DisplayObject):DisplayObject{
			return _skin.addChild(child);
		}
		public function addChildAt(child:DisplayObject,index:int):DisplayObject{
			return _skin.addChildAt(child,index);
		}
		public function removeChild(child:DisplayObject):DisplayObject{
			if(_skin.contains(child)){
				return _skin.removeChild(child);
			}
			return null;
		}
		public function removeChildAt(index:int):DisplayObject{
			return _skin.removeChildAt(index);
		}

		
		//---------------------------------------------------------------------------------------------------------------
		//
		//RemoveFormStage
		//
		//---------------------------------------------------------------------------------------------------------------
		public function remove():void{
			if(_skin && _skin.parent){
				_skin.parent.removeChild(_skin);
			}
		}
	}
}