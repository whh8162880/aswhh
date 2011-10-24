package com.module.plugin
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 *  
	 * @author wang
	 * 
	 */	
	public class PluginManager extends EventDispatcher
	{
		public function PluginManager()
		{
			super();
			pluginDict = new Dictionary();
		}
		
		/**
		 * plugin字典 里面纪录所有注册的plugin 
		 */		
		public var pluginDict:Dictionary;
		
		/**
		 * 注册plugin
		 * @param plugin
		 */		
		public function regPlugin(plugin:Plugin):void{
			var prePlugin:Plugin = pluginDict[plugin.name];
			if(plugin == prePlugin){
				return;
			}
			if(prePlugin){
				prePlugin.sleep();
				prePlugin.dispose();
			}
			plugin.setManager(this);
			pluginDict[plugin.name] = plugin;
		}
		
		/**
		 * 卸载plugin 
		 * @param plugin
		 */		
		public function removePlugin(name:String):void{
			var plugin:Plugin = pluginDict[name];
			if(!plugin){
				return;
			}
			plugin.sleep();
			plugin.dispose();
		}
		
		/**
		 * 获取plugin列表说明 
		 * @return 
		 * 
		 */		
		public function getPluginDisc(name:String = null):String{
			var str:String = '';
			var plugin:Plugin;
			var arr:Array = [];
			if(!name){
				str += "pluginManager下有以下插件\n"
				for each(plugin in pluginDict){
					arr.push(plugin);
				}
				arr.sortOn("name");
				for each(plugin in arr){
					str += "	"+plugin.toString() + "\n";
				}
				return str;
			}
			
			plugin = pluginDict[name];
			if(!plugin){
				return "plugin["+name+"] is unavailable";
			}
			return plugin.toCommandString();
		}
		
		/**
		 * 执行命令 
		 * @param plaginName 	指定的plugin
		 * @param command		执行的命令
		 */		
		public function doCommand(pluginName:String,command:String,...args):void{
			var plugin:Plugin;
			plugin = pluginDict[pluginName];
			if(!plugin){
				return;
			}
			plugin.doCommand(command,args);
		}
		
	}
}