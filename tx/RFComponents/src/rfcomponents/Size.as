package rfcomponents
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import rfcomponents.zinterface.ISize;
	import rfcomponents.zother.RenderHelp;
	
	public class Size extends DataBase implements ISize
	{
		protected var _width:int;
		
		protected var _height:int;
		
		protected var renderHelp:RenderHelp;
		
		public static const RENDER_SIZE:String = 'render_size';
		
		public static const RENDER_AREA:String = 'render_area';
		
		public function Size(target:IEventDispatcher=null)
		{
			renderHelp = new RenderHelp(30);
			super(target);
		}
		
		public function renderSize():void{
			renderHelp.addRender(RENDER_SIZE,doSizeRender);
		}
		
		public function set width(value:Number):void
		{
			_width = value;
			renderSize();
		}
		
		public function get width():Number
		{
			return _width;
		}
		
		public function set height(value:Number):void
		{
			_height = value;
			renderSize();
		}
		
		public function get height():Number
		{
			return _height;
		}
		
		public function resize(width:int, height:int):void
		{
			_width = width;
			_height = height;
			renderSize();
		}
		
		protected function doSizeRender():void{
			
		}
		
		public function sizeRender():void{
			renderHelp.clearRender(RENDER_SIZE);
			doSizeRender();
		}
	}
}