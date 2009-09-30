package asgl.files.media {
	
	public class ID3v1Info {
		public var album:String;
		public var artist:String;
		public var comment:String;
		public var genre:String;
		public var title:String;
		public var track:String;
		public var year:String;
		public function clear():void {
			album = null;
			artist = null;
			comment = null;
			genre = null;
			title = null;
			track = null;
			year = null;
		}
	}
}