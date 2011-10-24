package com.module.plugin.loader
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class PluginLoader extends EventDispatcher
	{
		public function PluginLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}