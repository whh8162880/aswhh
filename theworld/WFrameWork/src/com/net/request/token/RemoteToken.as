package com.net.request.token
{
	import com.net.request.event.RemoteOperationEvent;
	
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	import flash.utils.getQualifiedClassName;


	/**
	*  远端返回信息处理成功
	*/
	[Event(name="remote_operation_succesed", type="cn.sevencool.framework.events.RemoteOperationEvent")]
	
	/**
	* 远端服务出错，失败 
	*/
	[Event(name="remote_operation_fault", type="cn.sevencool.framework.events.RemoteOperationEvent")]
	
	/**
	* 远端服务返回数据格式错误或者数据处理出错，失败 
	*/
	[Event(name="remote_operation_data_failed", type="cn.sevencool.framework.events.RemoteOperationEvent")]
	
	/**
	* RPC操作产生的进度事件
	*/	
	[Event(name="progress",type="flash.events.ProgressEvent")]
		
	
	/**
	 * 远端交互凭据。
	 * 
	 * @author eas
	 */
	public class RemoteToken extends AsyncToken
	{
		/**
		 * 构造函数 
		 * @param CurrentOperation 操作对象,可以为string
		 * @param target 发布事件目标
		 * 
		 */
		public function RemoteToken(CurrentOperation:Object=null,target:IEventDispatcher=null)
		{
			super(target); 
			currentOperation = CurrentOperation;
			//trace(getOperationName()+' been Called!');
		}
		
		public var currentOperation:Object;
	
		internal function getOperationName():String
		{
			var name:String = 'unknown operation';
			if((currentOperation)&&(!(currentOperation is String)))
			{
				name = getQualifiedClassName(currentOperation);
				name = name.slice(name.indexOf('::')+2);
			}	
			if(currentOperation is String)
			{
				name = currentOperation as String;
			}
			return name;
		}
		
		/**
		 *  成功 
		 * @param msg
		 * @param data
		 * 
		 */
		public function dispatchSuccessed(msg:String='',data:* =''):Boolean
		{
			if(!hasEventListener(RemoteOperationEvent.REMOTE_OPERATION_SUCCESED))
				return false;
			var event:RemoteOperationEvent  = new RemoteOperationEvent(RemoteOperationEvent.REMOTE_OPERATION_SUCCESED,msg,data);
			
			
			//trace(getOperationName()+' Successed!',msg);
			currentOperation=null;
			
			return dispatchEvent(event);
		}
		
		/**
		 *  取回数据处理失败 
		 * @param msg
		 * @param data
		 * 
		 */
		public function dispatchFailed(msg:String='',data:*=''):Boolean
		{
			if(!hasEventListener(RemoteOperationEvent.REMOTE_OPERATION_DATA_FAILED))
				return false;
			var event:RemoteOperationEvent  = new RemoteOperationEvent(RemoteOperationEvent.REMOTE_OPERATION_DATA_FAILED,msg,data);
			
			trace(getOperationName()+' Failed!',msg,data);
			currentOperation=null;
			
			return dispatchEvent(event);
		}
		
		/**
		 * 远端操作失败
		 * 在io错误，安全错误之类发生时使用 
		 * @param msg
		 * @param data
		 * 
		 */
		public function dispatchFault(msg:String='',data:*=''):Boolean
		{
			if(!hasEventListener(RemoteOperationEvent.REMOTE_OPERATION_FAULT))
				return false;
				
			var event:RemoteOperationEvent  = new RemoteOperationEvent(RemoteOperationEvent.REMOTE_OPERATION_FAULT,msg,data);
			trace(getOperationName()+' Fault!',msg,data);
			currentOperation=null;
			return dispatchEvent(event);
		}
		
		/**
		 * 抛出进度事件 
		 * @param progressEvent
		 * @return 
		 * 
		 */
		public function dispatchProgress(progressEvent:ProgressEvent):Boolean
		{
			if(!hasEventListener(ProgressEvent.PROGRESS))
				return false;
			
			trace(getOperationName()+' ProgressEvent',
								Math.round(progressEvent.bytesLoaded/progressEvent.bytesTotal*100)+'%',
								Math.round(progressEvent.bytesLoaded/1000)+'k',Math.round(progressEvent.bytesTotal/1000)+'k');
			return dispatchEvent(progressEvent);
								
		}
	}
}