package com.mvc
{
	import com.event.RFEventDispatcher;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import rfcomponents.SkinBase;
	import rfcomponents.panel.Panel;
	
	public class Controller extends RFEventDispatcher
	{
		public function Controller(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var view:SkinBase;
		private var model:*;
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//View
		//
		//---------------------------------------------------------------------------------------------------------------
		public function setView(view:SkinBase):void{
			if(this.view){
				this.view.removeEventListener(Event.REMOVED_FROM_STAGE,stageHandler);
				this.view.removeEventListener(Event.ADDED_TO_STAGE,stageHandler);
			}
			this.view = view;
			if(this.view){
				this.view.addEventListener(Event.REMOVED_FROM_STAGE,stageHandler);
				this.view.addEventListener(Event.ADDED_TO_STAGE,stageHandler);
			}
			doSetView(view);
		}
		protected function doSetView(view:SkinBase):void{
			
		}
		public function getView():SkinBase{
			return view;
		}
		public function getDisplayView():DisplayObject{
			if(view){
				return view.skin;
			}
			return null;
		}
		protected function stageHandler(event:Event):void{
			if(event.type == Event.ADDED_TO_STAGE){
				awaken();
			}else{
				sleep();
			}
		}
		
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Model
		//
		//---------------------------------------------------------------------------------------------------------------
		public function setModel(model:*):void{
			this.model = model;
			doSetModel(model);
		}
		
		protected function doSetModel(model:*):void{
			
		}
		
		public function getModel():*{
			return model;
		}
		
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//State
		//
		//---------------------------------------------------------------------------------------------------------------		
		protected function awaken():void{
			
		}	
		protected function sleep():void{
			
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Show && Hide
		//
		//---------------------------------------------------------------------------------------------------------------		
		public function show():void{
			if(view is Panel){
				Panel(view).show();
			}
		}
		public function hide():void{
			if(view is Panel){
				Panel(view).remove();
			}
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Dispose
		//
		//---------------------------------------------------------------------------------------------------------------
		public function dispose():void{
			this.view = model = null;
			this.removeAllListener();
		}
	}
}