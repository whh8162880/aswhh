package com.module.scene.core
{

    import com.module.scene.events.SceneEvent;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.geom.Rectangle;

    [Event(name="start", type="com.clay.module.scene.events.SceneEvent")]
    [Event(name="sleep", type="com.clay.module.scene.events.SceneEvent")]
    [Event(name="jump", type="com.clay.module.scene.events.SceneEvent")]
    [Event(name="panelInitialized", type="com.clay.module.scene.events.SceneEvent")]
    public class SceneBase extends Sprite
    {
        private var _initialized:Boolean

        private var _isStarting:Boolean

        private var _panels:Array

        private var _nextScene:String;

        protected var manager:SceneManager

       // protected var viewFacade:IFacade;

        public function SceneBase(sceneName:String)
        {
            super();
            super.name = sceneName;
            _panels = [];

          //  viewFacade = Facade.getInstance();
        }

        override public function set name(value:String):void
        {
            throw new Error("can't reset name");
        }

        public function setManage(manager:SceneManager):void
        {
            this.manager = manager;
        }

        private var _width:int = -1;

        private var _height:int = -1;

        private var fullSceneFlag:Boolean = true

        public function setSize(width:int, height:int):void
        {
            _width = width;
            _height = height;
//            this.scrollRect = new Rectangle(0, 0, _width, _height)
            fullSceneFlag = false;
        }
		
        public function get initialized():Boolean
        {
            return _initialized;
        }

        public function get isStarting():Boolean
        {
            return _isStarting;
        }

        public function get sceneName():String
        {
            return name;
        }

        public function initialize():void
        {
            _initialized = true
        }

        public function start():void
        {
            if (_isStarting)
            {
                return;
            }
//			DebugTrace(this.name +" start");
            initStart();
            if (_panels.length)
            {
                showPanel(_width, _height)
                initPanel();
                this.dispatchEvent(new SceneEvent(SceneEvent.PANEL_INITIALIZED));
            }

            if (fullSceneFlag)
            {
            }

            _isStarting = true;
            this.dispatchEvent(new SceneEvent(SceneEvent.START))
            this.addEventListener(SceneEvent.JUMP, jumpHandler);
        }

        public function sleep():void
        {
            if (!_isStarting)
            {
                return;
            }
//			DebugTrace(this.name +" sleep");
            doStop();

            _isStarting = false;
            this.dispatchEvent(new SceneEvent(SceneEvent.SLEEP))
            this.removeEventListener(SceneEvent.JUMP, jumpHandler);
        }

        public function set nextScene(name:String):void
        {
            _nextScene = name;
//			DebugTrace(this.name +" set nextScene:" + name);
        }

        public function get nextScene():String
        {
            return _nextScene;
        }

        public function resize(width:int, height:int):void
        {
            showPanel(width, height)
        }

        protected function initStart():void
        {

        }

        protected function doStop():void
        {

        }

        protected function showPanel(width:int = -1, height:int = -1):void
        {
            var stage:Stage = manager.stage;
            if (width == -1)
            {
                width = stage.stageWidth;
            }

            if (height == -1)
            {
                height = stage.stageHeight;
            }

            for each (var vo:PanelDefine in _panels)
            {
                addChildPanel(vo.getPanel(), width, height, vo.halign, vo.valign);
            }

            resizePanel(width, height)

        }

        protected function initPanel():void
        {

        }

        protected function resizePanel(width:int, height:int):void
        {

        }


        protected function addChildPanel(panel:DisplayObject, width:int, height:int, halign:String = null, valign:String = null):void
        {
            if (halign != null)
            {
                switch (halign)
                {
                    case LayoutType.LEFT_H:
                        panel.x = 0;
                        break;
                    case LayoutType.CENTER_H:
                        panel.x = (width - panel.width) / 2;
                        break;
                    case LayoutType.RIGHT_H:
                        panel.x = width - panel.width;
                        break;
                }
            }

            if (valign != null)
            {
                switch (valign)
                {
                    case LayoutType.TOP_V:
                        panel.y = 0;
                        break;
                    case LayoutType.MIDDLE_V:
                        panel.y = (height - panel.height) / 2
                        break;
                    case LayoutType.BOTTOM_V:
                        panel.y = height - panel.height;
                        break;
                }
            }
            if (!contains(panel))
                addChild(panel);
        }

        /**
         * 注册面板
         * 如果面板为swf中得到的MC，则只做一次注册
         * @param panel			可以注册一个基于DisplayObject的类，或者一个基于DisplayObject的实例
         * @param x
         * @param y
         * @param halign
         * @param valign
         *
         */
        public function regPanel(panel:DisplayObject, x:Number = NaN, y:Number = NaN, halign:String = null, valign:String = null):void
        {
			var vo:PanelDefine = getPanel(panel);
			if(!vo){
            	vo = new PanelDefine(panel,x, y, halign, valign);
			}else{
				vo.updata(x, y, halign, valign);
			}
            _panels.push(vo);
        }

        private function getPanel(panel:DisplayObject):PanelDefine
        {
            for each (var vo:PanelDefine in _panels)
            {
                if (vo.displayObject == panel)
                {
                    return vo;
                }
            }

            return null
        }

        private function jumpHandler(event:SceneEvent):void
        {
            nextScene = String(event.data)
            this.sleep();
        }


        public function disponse():void
        {
//			DebugTrace(this.name + " disponse");
        }

    }
}
import flash.display.DisplayObject;


class PanelDefine
{
    public function PanelDefine(displayObject:DisplayObject,x:Number = 0, y:Number = 0, halign:String = null, valign:String = null)
    {
        this.x = x;
        this.y = y;
        this.halign = halign;
        this.valign = valign;
        this._displayObject = displayObject
    }

    private var _displayObject:DisplayObject

    public var panel:Class

    public var x:Number

    public var y:Number

    public var halign:String

    public var valign:String

    public function updata(x:Number = 0, y:Number = 0, halign:String = null, valign:String = null):void
    {
        this.x = x;
        this.y = y;
        this.halign = halign;
        this.valign = valign;
    }

    public function getPanel():DisplayObject
    {
        return _displayObject;
    }

    public function get displayObject():DisplayObject
    {
        return _displayObject;
    }
}

class UnKnow
{
    public function UnKnow()
    {

    }
}