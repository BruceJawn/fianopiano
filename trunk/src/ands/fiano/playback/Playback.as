package ands.fiano.playback
{

    import ands.fiano.KeyManager;

    import flash.events.TimerEvent;
    import flash.ui.Keyboard;
    import flash.utils.ByteArray;
    import flash.utils.Timer;
    import flash.utils.clearInterval;
    import flash.utils.clearTimeout;
    import flash.utils.getTimer;

    import org.osmf.events.TimeEvent;

    public class Playback
    {
        private var manager:KeyManager;
        private var timer:Timer;
        private var actions:Array;
        private var cursor:int;
        private var callback:Function;
        private var factor:int;
        private var t:int = getTimer();
        private var elapsed:int;

        public function stop():void
        {
            cursor = 0;
            elapsed = 0;
            if(timer != null)
            {
                timer.stop();
                timer.removeEventListener(TimerEvent.TIMER, onTimer);
            }
            if(manager != null)
            {
                manager.unlock();
            }
        }

        public function playActionList(manager:KeyManager, actions:Array, callback:Function=null, isSlow:int=0):void
        {
            this.manager = manager;
            this.actions = actions;
            this.callback = callback;
            factor = isSlow?1:0;

            stop();

            manager.lock();

            timer = new Timer(0);
            t = getTimer();
            timer.start();
            timer.addEventListener(TimerEvent.TIMER, onTimer);
        }

        public function onTimer(event:TimerEvent):void
        {
            if(cursor == actions.length)
            {
                stop();
                if(callback != null)
                {
                    callback.apply();
                }
                return;
            }
            elapsed = getTimer() - t;
            if((actions[cursor].timeoffset << factor) < elapsed)
            {
                var delay:int = actions[cursor].timeoffset;
                var keyCode:int = actions[cursor].key;
                var type:int = actions[cursor].type;
                cursor ++;
                if(keyCode > 0)
                {
                    if(type == KeyAction.PRESS)
                    {
                        manager.actPress(keyCode, false);
                    }
                    else
                    {
                        manager.actRelease(keyCode, false);
                    }
                }
            }
        }
    }
}

