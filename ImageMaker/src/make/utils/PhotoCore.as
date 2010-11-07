package make.utils
{
	public class PhotoCore
	{
		public function PhotoCore()
		{
		}
		
		public static function getPhotoVO(path:String,callback:Function):void{
			new GetPhotoVO(path,callback);
		}
	}
}
import com.OpenFile;

import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.filesystem.File;
import flash.utils.ByteArray;

import make.module.photoscale.view.PhotoView;
import make.vo.PhotoVO;

class GetPhotoVO{
	public function GetPhotoVO(path:String,callback:Function){
		this.path = path;
		this.callback = callback;
		
		photoVO = new PhotoVO();
		
		var file:File = new File(File.desktopDirectory.nativePath+"/testimage/1.JPG");
		var b:ByteArray = OpenFile.open(file);
		photoVO.photoByteArray = b;
		getSwf(b);
	}
	
	private function getSwf(ba:ByteArray):void{
		var result:Loader = new Loader()
		result.contentLoaderInfo.addEventListener(Event.COMPLETE,dispatchSuccess)
		result.loadBytes(ba)
	}
	
	
	private function dispatchSuccess(event:Event):void{
		var li:LoaderInfo = LoaderInfo(event.currentTarget);
		li.removeEventListener(Event.COMPLETE,dispatchSuccess);
		photoVO.photoBitmapdata = (li.content as Bitmap).bitmapData;
		
		if(callback!=null){
			callback(photoVO);
		}
	}
	
	public var path:String;
	
	public var callback:Function;
	
	public var photoVO:PhotoVO;
}