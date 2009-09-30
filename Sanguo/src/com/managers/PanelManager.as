package com.managers
{
	import mx.core.Application;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	public class PanelManager
	{
		public function PanelManager()
		{
		}
		
		private static var nativeWindow:Application;
		private static var layers:Array
		public static function regNativeWindow(_nativeWindow:Application):void{
			nativeWindow = _nativeWindow;
			layers = []
			for (var i:int = 0;i<4;i++){
				var layer:UIComponent = new UIComponent()
				PopUpManager.addPopUp(layer,nativeWindow);
				layers.push(layer);
			}
		}
		
		public static function addToApplicationLayer(target:UIComponent):void{
			addToLayer(target,1);
		}
		
		public static function addToPopUpLayer(target:UIComponent):void{
			addToLayer(target,2);
		}
		
		public static function addToLayer(target:UIComponent,layer:int):void{
			if(layer<0) layer = 0 ;
			else if(layer>=layers.length) layer = layers.length-1;
			
			var layerUI:UIComponent = layers[layer];
			PopUpManager.addPopUp(target,layerUI);
		}
		
		
		public static function getPanel(panel:Class,data:Object,showLayer:int = -1):UIComponent{
			var panelUI:UIComponent = CreateItemManager.getItem(panel) as UIComponent;
			if(panelUI && panelUI.hasOwnProperty("data")){
				panelUI["data"] = data;
			}
			if(panelUI && showLayer != -1){
				addToLayer(panelUI,showLayer);
			}
			return panelUI;
		}
		
		public static function removePanel(panel:UIComponent):void{
			CreateItemManager.removeItem(panel);
		}

	}
}