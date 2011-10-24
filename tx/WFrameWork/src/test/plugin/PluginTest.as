package test.plugin
{
	import com.core.Core;
	import com.module.plugin.Plugin;
	
	import test.plugin.plugins.FriendPlugin;
	import test.plugin.plugins.InfoPlugin;
	import test.plugin.plugins.TeamPlugin;

	public class PluginTest
	{
		public function PluginTest()
		{
			var plugin:Plugin;
			
			plugin = new InfoPlugin();
			Core.pluginManager.regPlugin(plugin);
			
			plugin = new FriendPlugin();
			Core.pluginManager.regPlugin(plugin);
			
			plugin = new TeamPlugin();
			Core.pluginManager.regPlugin(plugin);
			
			trace(Core.pluginManager.getPluginDisc());
			trace(Core.pluginManager.getPluginDisc("friend"));
			trace(Core.pluginManager.getPluginDisc("team"));
			
			Core.pluginManager.doCommand("info","do");
		
		}
	}
}