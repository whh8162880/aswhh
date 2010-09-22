package com
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.utils.ByteArray;
	
	import mx.controls.Alert;

	public class OpenFile extends EventDispatcher
	{
		public function OpenFile()
		{
		}
		
		public static function browseForDirectory(browseHandler:Function,title:String=""):void{
			new BrowseForDirectory(title,browseHandler);
		}
		
		public static function browseForOpen(browseHandler:Function,title:String="",fileTypes:Array = null):void{
			new BrowseForOpen(fileTypes,title,browseHandler);
		}
		
		public static function browseForOpenMultiple(browseHandler:Function,title:String="",fileTypes:Array = null):void{
			new BrowseForOpenMultiple(fileTypes,title,browseHandler);
	    }
		
		public static function browseForSave(browseHandler:Function,title:String=""):void{
			new BrowseForSave(title,browseHandler);
		}
	    
		public static function open(file:File):ByteArray{
			if(!file || !file.exists){
				return null;
			}
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ );
			var fileDate:ByteArray = new ByteArray();
			stream.readBytes( fileDate, 0, stream.bytesAvailable );
			stream.close();
			return fileDate;
		}
		
		public static function write(data:*,path:String):void{
			var stream:FileStream;
			var byte:ByteArray
			if(data is ByteArray){
				byte = data as ByteArray;
			}else{
				byte = new ByteArray();
				byte.writeObject(data);
				byte.position = 0;
			}
			
			try{
				var _file:File =new File(path);
				stream = new FileStream();
				stream.open( _file, FileMode.WRITE );
				stream.writeBytes( byte );
				stream.close();
			}catch(e:Error){
				
			}
		}
		
		
	}
}
import flash.events.Event;
import flash.events.FileListEvent;
import flash.filesystem.File;
import flash.net.FileFilter;

class BrowseForDirectory{
	protected var openHandler:Function
	protected var title:String;
	protected var file:File;
	public function BrowseForDirectory(title:String,openHandler:Function){
		this.title = title;
		this.openHandler = openHandler;
		this.file = new File();
		file.addEventListener(Event.SELECT,selectHandler);
		file.addEventListener(FileListEvent.SELECT_MULTIPLE,selectMultipleHandler);
		file.addEventListener(Event.CANCEL,cancelHandler);
	}
	
	protected function selectMultipleHandler(event:FileListEvent):void{
		if(openHandler != null){
			openHandler(event.files)
		}
	}
	
	protected function selectHandler(event:Event):void{
		if(file.exists && openHandler != null){
			openHandler(file)
		}
	}
	
	protected function cancelHandler(event:Event):void{
		if(openHandler != null){
			openHandler(null)
		}
	}
	
	protected function doOpen():void{
		file.browseForDirectory(title);
	}
}



class BrowseForOpen extends BrowseForDirectory{
	protected var fileTypes:Array;
	public function BrowseForOpen(fileTypes:Array,title:String,openHandler:Function){
		this.fileTypes = fileTypes;
		super(title,openHandler);
	}
	
	override protected function doOpen():void{
		file.browseForOpen(title,fileTypes);
	}
}

class BrowseForOpenMultiple extends BrowseForOpen{
	
	public function BrowseForOpenMultiple(fileTypes:Array,title:String,openHandler:Function){
		super(fileTypes,title,openHandler);
	}
	
	override protected function doOpen():void{
		file.browseForOpenMultiple(title,fileTypes);
	}
}

class BrowseForSave extends BrowseForDirectory{
	public function BrowseForSave(title:String,openHandler:Function){
		super(title,openHandler);
	}
	
	override protected function doOpen():void{
		file.browseForSave(title);
	}
}