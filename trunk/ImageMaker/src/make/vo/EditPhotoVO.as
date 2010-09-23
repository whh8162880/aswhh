package make.vo
{
	public class EditPhotoVO
	{
		public function EditPhotoVO()
		{
		}
		
		/**
		 * 照片路径 
		 */		
		public var formPath:String;
		
		/**
		 * 保存路径 
		 */		
		public var toPath:String;
		
		/**
		 * 保存后宽度 
		 */		
		public var widht:int;
		
		
		/**
		 * 保存后高度 
		 */		
		public var height:int;
		
		
		/**
		 * 图片质量 
		 */		
		public var quality:Number;
		
		/**
		 * 前缀 
		 */		
		public var preTitle:String = "PhotoMagic_";
		
		/**
		 * 时间 
		 */		
		public var exifDate:String;
		
		/**
		 *ISO 
		 */		
		public var exifISO:String;
		
		/**
		 * 相机信息 
		 */		
		public var exifCamera:String;
		
		/**
		 * 光圈 
		 */		
		public var exifAperture:String;
		
		
	}
}