package com.display
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class LayoutBase extends Sprite
	{
		protected var _hgap:int 
		protected var _vgap:int
		protected var _hAlign:String;
		protected var _vAlign:String;
		protected var _buildFlag:Boolean = false;
		public function LayoutBase()
		{
			_hgap = _vgap = 8;
			_hAlign = LayoutType.LEFT;
			_vAlign = LayoutType.TOP;
		}
		
		//--------------------------------------
		public function set hgap(value:int):void{
			if(_hgap == value) return;
			_hgap = value;
			bulidflag = true
		}
		
		public function get hgap():int{
			return _hgap
		}
		
		//---------------------------------------
		public function set vgap(value:int):void{
			if(_vgap == value) return;
			_vgap = value;
			bulidflag= true
		}
		
		public function get vgap():int{
			return _hgap
		}
		
		//---------------------------------------
		public function set vAlign(value:String):void{
			if(_vAlign == value) return;
			_vAlign = value;
			bulidflag= true
		}
		
		public function get vAlign():String{
			return _vAlign
		}
		
		//---------------------------------------
		public function set hAlign(value:String):void{
			if(_hAlign == value) return;
			_hAlign = value;
			bulidflag= true
		}
		
		public function get hAlign():String{
			return _hAlign
		}
		
		public function set bulidflag(value:Boolean):void{
			if(_buildFlag == value){
				return;
			}
			_buildFlag = value;
			if(_buildFlag == true){
				this.addEventListener(Event.ENTER_FRAME,enterFrameHandelr);
			}else{
				this.removeEventListener(Event.ENTER_FRAME,enterFrameHandelr);
			}
		}
		
		private function enterFrameHandelr(event:Event):void{
			bulidflag = false;
			bulid();
		}
		
		
		protected function bulid():void{
			
		}

	}
}