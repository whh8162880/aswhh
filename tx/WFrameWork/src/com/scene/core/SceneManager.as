package com.scene.core
{
    import com.event.RFEventDispatcher;
    import com.scene.events.SceneEvent;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Stage;
    import flash.utils.Dictionary;

    public class SceneManager extends RFEventDispatcher
    {
        private var sceneDict:Dictionary;

        private var _currentScene:SceneBase

        private var container:DisplayObjectContainer;

		public var stage:Stage;
        public function SceneManager(stage:Stage)
        {
			this.stage = stage;
            sceneDict = new Dictionary()
        }

        public function setContainer(container:DisplayObjectContainer):void
        {
            if (!container)
                return;
            this.container = container;
        }

        private var _width:int = -1;

        private var _height:int = -1;

        public function setSize(width:int, height:int):void
        {
            _width = width;
            _height = height;
        }

        /**
         * 是否存在场景
         * @param sceneName
         *
         */
        public function hasScene(sceneName:String):Boolean
        {
            return sceneDict.hasOwnProperty(sceneName);
        }


        /**
         * 注册场景
         * @param scene
         *
         */
        public function regScene(scene:SceneBase):void
        {
            if (!scene)
                return;
            scene.setManage(this);
            scene.setSize(_width, _height);
            if (sceneDict.hasOwnProperty(scene.name))
            {
                if (sceneDict[scene.name] == scene)
                {
                    return;
                }
                throw new ArgumentError("该场景名称" + scene.name + "已经存在，请更换名字或者先卸载原有场景");
            }
            sceneDict[scene.name] = scene;
//			DebugTrace("add scene "+scene.name);
        }

        public function removeScene(sceneName:String):void
        {
            var scene:SceneBase = sceneDict[sceneName]
            if (scene)
            {
                scene.disponse();
                scene.setManage(null);
            }
            sceneDict[sceneName] = null
            delete sceneDict[sceneName];
//			DebugTrace("remove scene "+sceneName);
        }

        public function showScene(sceneName:String):void
        {
            if (sceneName == null)
                return;
            currentScene = sceneDict[sceneName]
        }

        public function get currentScene():SceneBase
        {
            return _currentScene;
        }

        public function set currentScene(value:SceneBase):void
        {
            if (!value || _currentScene == value)
                return;

            if (!sceneDict[value.name])
            {
                regScene(value);
            }
            if (_currentScene)
            {
                _currentScene.removeEventListener(SceneEvent.SLEEP, sceneEndHandler);
                _currentScene.sleep();
                endEffect(_currentScene);
            }

            startEffect(value);


            _currentScene = value;
            if (!_currentScene.initialized)
            {
                _currentScene.initialize();
            }

            _currentScene.start();

            _currentScene.addEventListener(SceneEvent.SLEEP, sceneEndHandler);
        }

        private function startEffect(scene:SceneBase):void
        {
            if (!scene)
            {
                return;
            }
            container.addChild(scene);
        }

        private function endEffect(scene:SceneBase):void
        {
            if (container.contains(scene))
            {
                container.removeChild(scene);
            }
        }


        private function sceneEndHandler(event:SceneEvent):void
        {
            var scene:SceneBase = SceneBase(event.target)
            if (_currentScene == scene)
            {
                showScene(scene.nextScene)
                if (scene)
                    scene.nextScene = null
            }
        }

    }
}
