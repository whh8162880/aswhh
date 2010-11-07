package  com.request.event
{
	import flash.events.Event;

	/**
	 * 远端操作事件 
	 * 用来调用 远端服务之后，回馈的事件
	 * 一般由RemoteToken对象抛出
	 * @author dan
	 * 
	 */
	public class RemoteOperationEvent extends Event
	{
		/**
		 * 成功 
		 */
		public static const REMOTE_OPERATION_SUCCESED : String = 'sc_framework_remote_operation_succesed';
		/**
		 * 完全错误 
		 */
		public static const REMOTE_OPERATION_FAULT : String = 'sc_framework_remote_operation_fault';
		/**
		 *数据出错 
		 */
		public static const REMOTE_OPERATION_DATA_FAILED : String = 'sc_framework_remote_operation_data_progress_failed';
		/**
		 * 信息 
		 */
		public var message : String = 'default msg';
		/**
		 * 数据 
		 */
		public var data : * = 'default data';

		public function RemoteOperationEvent(type : String, _msg : String = null, _data : *= null)
		{
			super( type, false, false);
			
			message=_msg;
			data=_data;
		}

		override public  function clone() : Event
		{
			return new RemoteOperationEvent( type, message, data);
		}

		override public function toString() : String
		{
			return '[RemoteOperationEvent type="' + type + '" bubbles=' + bubbles + ' cancelable=' + cancelable + ' eventPhase=' + eventPhase + ']';
		}
	}
}