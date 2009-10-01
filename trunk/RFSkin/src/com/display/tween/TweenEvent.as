package  com.display.tween
{
    import flash.events.Event;
    public class TweenEvent extends Event {


        public static  const TWEEN_END:String="whhtweenEnd";

        public static  const TWEEN_START:String="whhtweenStart";

        public static  const TWEEN_UPDATE:String="whhtweenUpdate";
        
        public static  const TWEEN_PLAY:String="whhtweenPlay";

        public static const TWEEN_STOP:String="whhtweenStop";


        public function TweenEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false,value:Object=null) {
            super(type,bubbles,cancelable);

            this.value=value;
        }
        /**
         */
        public var value:Object;

        override public  function clone():Event {
            return new TweenEvent(type,bubbles,cancelable,value);
        }
    }

}

