package asgl.views {
	import flash.display.IBitmapDrawable;
	
	public interface IView {
		function get backgroundColor():uint;
		function get canvas():IBitmapDrawable;
		function get height():uint;
		function get viewType():String;
		function get width():uint;
		function destroy():void;
		function draw(view:IView):void;
		function reset(width:uint, height:uint, backgroundColor:uint=0):void;
	}
}