package com.csv
{
	import com.OpenFile;
	import com.csv.parser.InitCsvParser;
	import com.csv.parser.MapCsvDecode;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	public class CsvManager extends EventDispatcher
	{
		public function CsvManager(target:IEventDispatcher=null)
		{
			super(target);
			csvdecoder = new CSVDecoder();
			csvdict = new Dictionary();
			init();
		}
		
		public static var instance:CsvManager = new CsvManager();
		public static function parser(file:File):void{
			instance.parser(file);
		}
		
		
		public function init():void{
			regParser(new InitCsvParser("0"));
			regParser(new MapCsvDecode("1"));
		}
		
		private var csvdict:Dictionary
		public function regParser(parser:CsvBase):void{
			csvdict[parser.type] = parser;
		}
		
		
		private var csvdecoder:CSVDecoder;
		private var currentFile:File;
		public function parser(file:File):void{
			
			var type:String = file.name.split("_")[0];
			var parser:CsvBase = csvdict[type];
			if(!parser){
				Alert.show("不可解析文件");
				return;
			}
			
			new AlertHelp(parser,file,csvdecoder);
		}
	}
}
import com.OpenFile;
import com.csv.CSVDecoder;
import com.csv.CsvBase;

import flash.filesystem.File;

import mx.controls.Alert;
import mx.events.CloseEvent;

class AlertHelp{
	public var parser:CsvBase;
	public var file:File;
	public var csvdecoder:CSVDecoder;
	public function AlertHelp(parser:CsvBase,file:File,csvdecoder:CSVDecoder){
		this.parser = parser;
		this.file = file;
		this.csvdecoder = csvdecoder;
		Alert.show(parser.getDisc() +"表，是否修改","",Alert.YES|Alert.NO,null,handler); 
	}
	
	private function handler(event:CloseEvent):void{
		if(event.detail == Alert.YES){
			var arr:Array = csvdecoder.decode(OpenFile.openAsTxt(file));
			parser.parser(file,arr);
		}
		parser = null;
		file = null;
		csvdecoder = null;
	}
	
	
}