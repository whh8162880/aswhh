package com.model.user
{
	import com.OpenFile;
	import com.model.Model;
	import com.model.log.Log;
	import com.socket.TXSocketServer;
	import com.socket.TxClient;
	import com.theworld.module.game.avatar.player.HeroVO;
	import com.unit.Npc;
	import com.unit.User;
	import com.utils.work.Work;
	
	import flash.events.TimerEvent;
	import flash.filesystem.File;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	/**
	 * 储存者所有人物的信息 
	 * @author wang
	 * 
	 */	
	public class UserModel extends Model
	{
		private var timer:Timer;
		public function UserModel(socketServer:TXSocketServer)
		{
			registerClassAlias("HeroVO",HeroVO);
			super(socketServer);
		}
		override protected function init():void{
			userDict = new Dictionary();
			writeByte = new ByteArray();
			var str:String = File.applicationDirectory.nativePath;
			configFilePath = str.slice(0,str.lastIndexOf("/")) +"/user/";
			timer = new Timer(10*60*1000);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
		}
		
		/**
		 * 每10分钟保存所有玩家信息一次 
		 * @param event
		 */		
		private function timerHandler(event:TimerEvent):void{
			saveAll();
		}
		
		private var userDict:Dictionary
		public function getUser(id:String):User{
			var user:User = userDict[id];
			if(!user){
				var b:ByteArray = getFile(id+".user");
				var vo:HeroVO
				if(b){
					vo = b.readObject();
				}else{
					vo = new HeroVO();
					vo.guid = id;
				}
				user = new User(vo,socketServer);
				userDict[id] = user;
			}
			return user;
		}
		
		private var writeByte:ByteArray;
		public function save(id:String,islog:Boolean=false):void{
			var user:User = userDict[id];
			if(!user){
				Log.print("error user : "+id);
				return;
			}
			writeByte.position = 0;
			writeByte.length = 0;
			writeByte.writeObject(user.vo);
			var file:File = OpenFile.write(writeByte,configFilePath+id+".user");
			if(!file){
				Log.print("write user data error at "+file.nativePath);
			}else if(islog){
				Log.print("write complete : " + id);
			}
		}
		
		public function saveAndClose(id:String):void{
			save(id);
			userDict[id] = null;
			delete userDict[id];
			Log.print('save and close '+id);
		}
		
		public function saveAll():void{
			Log.print("save all user data");
			var arr:Array = [];
			for each(var user:User in userDict){
				arr.push(user.vo.guid);
			}
			Work.addTask("server_usermodel",arr,save,true);
		}
	}
}