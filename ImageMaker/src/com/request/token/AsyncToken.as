package  com.request.token
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;


	/**
	*  远端返回信息处理成功
	*/
	[Event(name="complete", type="flash.events.Event")]
	/**
	 * 异步操作令牌
	 *  
	 * @author eas
	 * 
	 */
	public class AsyncToken extends EventDispatcher
	{
		public function AsyncToken(target:IEventDispatcher=null)
		{
			super(target);
		}
	}
}