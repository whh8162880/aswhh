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
		
		private var _file:File
		public function open(imageTypes:FileFilter = null):void
	    {
			_file = new File();
			var imageTypes:FileFilter = new FileFilter("*.*", "*.*");
			_file.addEventListener( Event.SELECT, this.onSelect );
			_file.browseForOpen( "Open", [ imageTypes ] );
	    }
	    
	    private var openData:ByteArray
		private function onSelect( e:Event ):void
	    {
	      var stream:FileStream = new FileStream();
	      stream.open( e.target as File, FileMode.READ );
	      var fileDate:ByteArray = new ByteArray();
	      stream.readBytes( fileDate, 0, stream.bytesAvailable );
	      stream.close();
	      openData = fileDate;
	      this.dispatchEvent(new Event(Event.COMPLETE));
	    }
	    
	    public function getFile():File{
	    	return _file
	    }
	    
	    public function getData():ByteArray{
	    	return openData
	    }
	    
	    public function write(byteArray:ByteArray,path:String):void{
	    	var stream:FileStream;
	    	try{
			    var _file:File = File.desktopDirectory.resolvePath( path );
			    stream = new FileStream();
			    _file.addEventListener(Event.COMPLETE,streamHandler);
			    stream.open( _file, FileMode.WRITE );
			    stream.writeBytes( byteArray );
			    stream.close();
			}catch(e:Error){
				
			}
//		    _file.addEventListener(
	    }
	    
	    private function streamHandler(event:Event):void{
	    	event.target.removeEventListener(Event.COMPLETE,streamHandler);
	    	Alert.show("保存成功!!!");
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