package com.utils.work
{
	public class WorkSpace implements IWork
	{
		public function WorkSpace(id:String){
			this._id = id;
		}
		
		protected var _id:String;
		
		public function get id():String{
			return _id;
		}
		public var datas:Array;
		public var len:int;
		public var index:int;
		public var handler:Function;
		
		public function doFunction():Boolean{
			handler(datas[index]);
			return ++index>=len;
		}
	}
}