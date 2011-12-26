package com.dock.icon
{
	public interface IDockIcon
	{
		function set mouseEnabled(value:Boolean):void;
		
		function set x(value:Number):void;
		function get x():Number;
		
		function set y(value:Number):void;
		function get y():Number;
		
		function get mouseX():Number;
		
		function get mouseY():Number;
		
		
		function set nextMoveIndex(value:int):void;
		
		function get nextMoveIndex():int;
		
		function setName(value:String):void
	}
}