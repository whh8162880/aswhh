package test.plugin.plugins
{
	import com.module.plugin.Plugin;
	
	import flash.text.engine.RenderingMode;
	import flash.utils.setTimeout;
	
	public class FriendPlugin extends Plugin
	{
		public function FriendPlugin()
		{
			super("friend");
			disc = '好友插件';
			friendList = [];
		}
		
		private var friendList:Array;
		override protected function init():void{
			regCommand("getlist",getFriendList,"获取好友列表");
			regCommand("addFriend",addFriend,"添加好友");
		}
		
		private function getFriendList(callback:Function = null):void{
			//返回好友列表
			callback(friendList);
		}
		
		private function addFriend(target:String,callback:Function = null):void{
			if(friendList.indexOf(target) == -1){
				friendList.push(target);
			}
			callback(target,true);
		}
	}
}