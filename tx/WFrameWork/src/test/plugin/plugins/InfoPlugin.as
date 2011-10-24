package test.plugin.plugins
{
	import com.module.plugin.Plugin;
	/**
	 * 获取信息 
	 * @author wang
	 * 
	 */	
	public class InfoPlugin extends Plugin
	{
		public function InfoPlugin()
		{
			super("info");
			disc = "游戏信息插件"
		}
		
		override protected function init():void{
			regCommand("do",doAction,"执行命令");
		}
		
		public function doAction():void{
			//先获取好友列表
			manager.doCommand("friend","getlist",friendlistCallback);
			manager.doCommand("friend","addFriend","wang",addFriendCallback);
			manager.doCommand("friend","getlist",friendlistCallback);
			manager.doCommand("team","addTeam","wang");
		}
		
		private function friendlistCallback(value:Array):void{
			trace("有 " + value.length + " 个好友");
		}
		
		private function addFriendCallback(target:String,result:Boolean):void{
			if(result){
				trace("添加好友 " + target + " 成功");
			}
		}
	}
}