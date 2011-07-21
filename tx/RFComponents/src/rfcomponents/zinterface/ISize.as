package rfcomponents.zinterface
{
	public interface ISize
	{
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set width(value:Number):void;
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get width():Number;
		
		/**
		 * 
		 * @param value
		 * 
		 */		
		function set height(value:Number):void;
		
		/**
		 * 
		 * @return 
		 * 
		 */		
		function get height():Number;
		
		
		/**
		 * 重设宽高 
		 * @param width
		 * @param height
		 * @return 
		 * 
		 */		
		function resize(width:int,height:int):void;
	}
}