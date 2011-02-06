package ands.fiano.view
{
    import ands.fiano.IKeyboard;
    import ands.fiano.settings.IKeySettingsListener;
    import ands.fiano.settings.KeySetting;

    import flash.display.Sprite;

    public class AbstractKeyboard extends Sprite implements IKeyboard, IKeySettingsListener
    {
        public static var DEFAULT_KEY:Key = new Key;
        protected var settings:KeySetting;

        public function AbstractKeyboard()
        {
            settings = KeySetting.getInstance();
            settings.addListener(this);
            createUI();
        }

        public function update():void
        {
            updateKeys();
        }

        protected function updateKeys():void
        {
        }
        /**
         * perform the key press event
         * @param keyCode
         * @param shift
         *
         */
        public function actPress(keyCode:int, shift:Boolean):void
        {
            var key:IKey = getKey(keyCode);
            if(key != null)
            {
                key.press();
            }
        }

        /**
         * perform the key release event
         * @param keyCode
         * @param shift
         *
         */
        public function actRelease(keyCode:int, shift:Boolean):void
        {
            var key:IKey = getKey(keyCode);
            if(key != null)
            {
                key.release();
            }
        }

        /**
         * get key by keyCode
         * @param keyCode
         *          *
         */
        public function getKey(keyCode:int):IKey
        {
            return null
        }

        /**
         * build the UI
         */
        protected function createUI():void
        {
        }
    }
}
