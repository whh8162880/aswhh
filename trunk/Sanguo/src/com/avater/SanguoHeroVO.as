package com.avater
{
	import com.avater.vo.UserVO;

	public class SanguoHeroVO extends UserVO
	{
		public function SanguoHeroVO()
		{
			super();
		}
		
		/**
		 * 属于谁的 
		 */		
		public var own:String = "";
		
		public var url:String = "";
		
		public var moveArea:Array
		
		
	}
}