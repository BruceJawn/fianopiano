package ands.fiano
{
    import ands.fiano.playback.KeyAction;

    import flash.utils.getTimer;

    public class Recorder implements IKeyboard
    {
		private var keyActions:Array;
		private var startTime:int;

		public function start():void
		{
			keyActions = [];
			startTime = getTimer();
		}

		public function getKeyActions():Array
		{
			return keyActions;
		}

		public function end():void
		{
			keyActions = null
		}

        public function actPress(keyCode:int, shift:Boolean):void
        {
			if(keyActions != null)
			{
				keyActions.push(new KeyAction(KeyAction.PRESS, keyCode, getTimer() - startTime));
			}
        }

        public function actRelease(keyCode:int, shift:Boolean):void
        {
			if(keyActions != null)
			{
				keyActions.push(new KeyAction(KeyAction.RELEASE, keyCode, getTimer() - startTime));
			}
        }
    }
}