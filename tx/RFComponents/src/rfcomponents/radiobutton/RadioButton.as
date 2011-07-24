package rfcomponents.radiobutton
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import rfcomponents.checkbox.CheckBox;
	import rfcomponents.zother.rendermachine.RenderMachine;
	
	public class RadioButton extends CheckBox
	{
		public function RadioButton(skin:Sprite=null, group:String = null,machine:RenderMachine=null)
		{
			super(skin, machine);
			if(group){
				this.group = group;
			}
		}
		
		override public function set selected(value:Boolean):void{
			super.selected = value;
			if(_selected){
				removeEventListener(MouseEvent.CLICK,clickHandler);
			}else{
				addEventListener(MouseEvent.CLICK,clickHandler);
			}
		}
		
		protected var _group:String
		public function set group(name:String):void{
			var radioButtonGroup:RadioButtonGroup;
			if(_group){
				radioButtonGroup = RadioButtonGroup.getGroup(_group);
				if(radioButtonGroup){
					radioButtonGroup.removeRadioButton(this);
				}
			}
			_group = name;
			if(_group){
				radioButtonGroup = RadioButtonGroup.getGroup(_group,true);
				radioButtonGroup.addRadioButton(this);
			}
		}
		public function get group():String{
			return _group;
		}
	}
}