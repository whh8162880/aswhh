package test.plugin.plugins
{
	import com.module.plugin.Plugin;
	
	public class TeamPlugin extends Plugin
	{
		public function TeamPlugin()
		{
			super("team");
			disc = "队伍插件"
		}
		
		override protected function init():void{
			regCommand("addTeam",addTeam,"发起组队请求");
		}
		
		
		public function addTeam(target:String):void{
			trace("对" + target + "发起组队请求");
		}
	}
}