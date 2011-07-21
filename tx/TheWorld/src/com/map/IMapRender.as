package com.map
{
	import flash.display.Graphics;

	public interface IMapRender
	{
		function get graphics():Graphics;
		function getoffsetx():int;
		function getoffsety():int;
	}
}