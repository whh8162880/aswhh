package rfcomponents.tab
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import rfcomponents.SkinBase;
	import rfcomponents.tab.render.TabItem;
	
	public class TabNavigator extends SkinBase
	{
		public function TabNavigator()
		{
			super();
			items = [];
		}
		
		public var d:int = 5;
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Skin X Y
		//
		//---------------------------------------------------------------------------------------------------------------
		protected var _x:Number;
		
		protected var _y:Number;
		
		override public function set skin(skin:Sprite):void{
			_x = skin.x;
			_y = skin.y;
			super.skin = skin;
		}
		
		override public function set x(value:Number):void{
			_x = value;
			if(_skin){
				_skin.x = value;
			}
		}
		
		override public function get x():Number{
			return _x;
		}
		
		override public function set y(value:Number):void{
			_y = value;
			if(_skin){
				_skin.y = value;
			}
		}
		
		override public function get y():Number{
			return _y;
		}
		
		override public function moveTo(x:int, y:int):void{
			this.x = x;
			this.y = y;
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//Module
		//
		//---------------------------------------------------------------------------------------------------------------
		/**
		 * TabItemList 
		 */		
		protected var items:Array;
		
		/**
		 * 添加Tab项 
		 * @param item
		 * @param at
		 * 			-1	最后
		 */		
		public function addItem(item:TabItem,at:int = -1):void{
			if(!item){
				return;
			}
			removeItem(item);
			if(at==-1 || at>=items.length){
				items.push(item);
			}else{
				items.splice(at,0,item);
			}
			refreshItemList();
		}
		
		/**
		 * 删除一个Tab项 
		 * @param item
		 * 
		 */		
		public function removeItem(item:TabItem):void{
			var i:int = items.indexOf(item);
			if(i!=-1){
				removeItemByindex(i);
			}
		}
		
		public function removeItemByindex(index:int):TabItem{
			var item:TabItem = items[index];
			if(!item){
				return null;
			}
			
			items.splice(index,1);
			if(item == _selectItem){
				selectItem = items[0];
			}
			refreshItemList();
		}
		
		/**
		 * 刷新TAB现实 
		 */		
		protected function refreshItemList():void{
			var x:int = _x;
			var y:int = _y;
			for each(var item:TabItem in items){
				item.x = x;
				x += item.width + d;
				item.y = y;
 			}
			_width = x - d - _x;
			_height = item.height;
		}
		
		/**
		 * 当前选择的TAB对象 
		 */		
		protected var _selectItem:TabItem;
		
		public function set selectItem(item:TabItem):void{
			if(!item || items.indexOf(item) == -1){
				return;
			}
			_selectItem = item;
			this.dispatchEvent(new Event(TabEvent.SELECT));
		}
		
		public function get selectItem():TabItem{
			return _selectItem;
		}
		
		public function set selectIndex(index:int):void{
			if(index<0 || index>=items.length){
				return;
			}
			selectItem = items[index]; 
		}
		
		public function get selectIndex():int{
			if(!_selectItem){
				return -1;
			}
			return items.indexOf(selectItem);
		}
		
		
		protected function doSelectedItem(item:TabItem):void{
			
		}
		
	}
}