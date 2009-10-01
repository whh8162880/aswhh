package asgl.files.utils.zip {
	public class ZIPSignature {
		public static const LOCAL_FILE_HEADER:uint = 0x4034B50;
		public static const ARCHIVE_EXTRA_DATA:uint = 0x8064B50
		public static const CENTRAL_FILE_HEADER:uint = 0x2014B50;
		public static const DIGITAL_HEADER:uint = 0x5054B50;
		public static const CENTRAL_DIR_END:uint = 0x6054B50;
	}
}