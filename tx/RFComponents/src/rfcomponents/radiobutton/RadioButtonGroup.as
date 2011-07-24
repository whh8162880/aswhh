package rfcomponents.radiobutton
{
	import flash.events.Event;
	import flash.utils.Dictionary;

	public class RadioButtonGroup
	{
		private static var groupDict:Dictionary = new Dictionary();
		public static function getGroup(name:String,autoCreate:Boolean = false):RadioButtonGroup{
			var group:RadioButtonGroup = groupDict[name];
			if(!group){
				if(autoCreate){
					group = new RadioButtonGroup(name);
					groupDict[name] = group;
				}
			}
			return group;
		}
		
		private var name:String;
		private var list:Array;
		public function RadioButtonGroup(name:String)
		{
			this.name = name;
			list = [];
		}
		
		private var _selectRadioButton:RadioButton;
		public function set selectRadioButton(radioButton:RadioButton):void{
			_selectRadioButton = radioButton;
		}
		public function get selectRadioButton():RadioButton{
			return _selectRadioButton;
		}
		
		/**
		 *  
		 * @param radioButton
		 * 
		 */		
		public function addRadioButton(radioButton:RadioButton):void{
			if(list.indexOf(radioButton)==-1){
				radioButton.addEventListener(Event.SELECT,radioButtonSelectHandler);
				list.push(radioButton);
				if(!_selectRadioButton){
					radioButton.selected = true;
				}
			}
		}
		
		/**
		 * 
		 * @param radioButton
		 * 
		 */		
		public function removeRadioButton(radioButton:RadioButton):void{
			var i:int = list.indexOf(radioButton);
			if(i==-1){
				return;
			}
			radioButton.removeEventListener(Event.SELECT,radioButtonSelectHandler);
			list.splice(i,1);
		}
		
		protected function radioButtonSelectHandler(event:Event):void{
			var target:RadioButton = event.currentTarget as RadioButton;
			if(target.selected){
				if(_selectRadioButton){
					_selectRadioButton.selected = false;
					_selectRadioButton.addEventListener(Event.SELECT,radioButtonSelectHandler);
				}
				_selectRadioButton = target;
				_selectRadioButton.removeEventListener(Event.SELECT,radioButtonSelectHandler);
			}
		}
	}
}