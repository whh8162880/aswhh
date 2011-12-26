package com.dock.view
{
	import com.dock.icon.DockIcon;
	import com.dock.icon.IDockIcon;
	
	import flash.display.DisplayObject;

	public interface IDockView
	{
		function set mouseChildren(value:Boolean):void;
		
		function get x():Number;
		
		function get y():Number;
		
		//
		
		function getList():Array;
		
		function getIndex(icon:IDockIcon):int;
		
		function checkDock():void;
		
		function addDockIcon(icon:IDockIcon):void;
		
		function intoDockIcon(icon:IDockIcon):void;
		
		function preRemoveDockIcon(icon:IDockIcon):void;
		
		function tweenTo(icon:DisplayObject,i:int):void;
	}
}