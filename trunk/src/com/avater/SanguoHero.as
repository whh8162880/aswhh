package com.avater
{
	import com.avater.image.SanguoAvaterImage;
	import com.display.text.Text;
	import com.display.utils.BitmapFilterUtils;
	import com.youbt.events.RFLoaderEvent;
	
	import flash.events.Event;
	
	public class SanguoHero extends AvaterBase
	{
		private var nickNameTitle:NickNameTitleItem;
		private var titleTitle:AvaterTitleItem
		public function SanguoHero()
		{
			super();
			avaterTitle.gap = 0;
			container.gap = -5;
			nickNameTitle = new NickNameTitleItem()
			avaterTitle.regTitle(nickNameTitle);
			titleTitle = new AvaterTitleItem()
			var t:Text = new Text(120)
			t.setTextColor(0xffff00,0);
			titleTitle.regDisplayObjectToProperty(t,"title")
			titleTitle.addChild(t);
			avaterTitle.regTitle(titleTitle);
			image = new SanguoAvaterImage()
			image.addEventListener(RFLoaderEvent.COMPLETE,imageHandelr);
			container.useHandCursor = true;
			container.buttonMode = true;
			
		}
		
		private function imageHandelr(event:Event):void{
			regActions2(image.getDefaultActions());
			createComplete();
		}
		
		private var sanguoHeroVO:SanguoHeroVO
		override protected function doData():void{
			sanguoHeroVO = _userVO as SanguoHeroVO;
			var url:String = sanguoHeroVO.url
			if(url)
				image.loadImage(url)
			super.doData();
//			"assets/sanguo/bubing.gif"
		}
		
		override protected function rollOver():void{
			if(selected == false)
				this.bitmap.filters = BitmapFilterUtils.getBitmapFilter();
		}
		
		override protected function rollOut():void{
			if(selected == false)
				this.bitmap.filters = []
		}
		
		
		override protected function doSelected():void{
			this.bitmap.filters = BitmapFilterUtils.getBitmapFilter()
			super.doSelected();
		}
		
		override protected function unSelected():void{
			this.bitmap.filters = []
		}
		
	}
}