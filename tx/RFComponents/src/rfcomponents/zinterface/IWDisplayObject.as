package rfcomponents.zinterface
{
	public interface IWDisplayObject extends ISize
	{
		function set x(value:Number):void;
		
		function get x():Number;
		
		function set y(value:Number):void;
		
		function get y():Number;
		
		function moveto(x:int,y:int):void;
		
		function set enabled(value:Boolean):void;
		
		function get enabled():Boolean;
		
	}
}