package ands.fiano.playback
{
    public class KeyAction
    {
        public static const PRESS:int = 1;
        public static const RELEASE:int = 2;

        public var type:int;
        public var key:int;
        public var timeoffset:int;

        public function KeyAction(type:int=0,key:int=0,timeoffset:int=0)
        {
            this.type = type;
            this.key = key;
            this.timeoffset = timeoffset;
        }
    }
}
