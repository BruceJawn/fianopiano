package ands.fiano.view
{
    import ands.fiano.settings.KeySetting;
    
    import flash.display.Sprite;

    public class PreviewKeyboard extends AbstractKeyboard
    {
		private var keySettings:KeySetting = KeySetting.getInstance();
		
        public static var charNoteMap:Vector.<int> = Vector.<int>([0,0,0,0,0,0,0,0,0,0,0,0,0,57,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,93,88,86,91,48,53,52,50,0,0,0,0,89,84,0,88,72,74,76,77,79,81,83,84,86,0,0,0,0,0,0,0,48,43,40,52,64,53,55,57,72,59,60,62,47,45,74,76,60,65,50,67,71,41,62,38,69,36,0,0,0,0,0,53,60,62,64,65,67,69,71,72,74,79,76,0,81,55,77,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,64,91,48,89,50,52,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,77,0,79,65,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]);
        private var keys:Vector.<PreviewKey> = new Vector.<PreviewKey>(128);

        override protected function getKey(keyCode:int):IKey
        {
            return keys[getNote(keyCode)] || DEFAULT_KEY;
        }

        private function getNote(keyCode:int):int
        {
//			var index:int = keySettings.keyCodes.indexOf(keyCodes);
            return charNoteMap[keyCode];
        }

        /**
         * create the default UI
         */
        override protected function createUI():void
        {
            var key:PreviewKey;
            var i:int;

            function createKey():void
            {
                var nv:int = noteValues.shift()
                key = new PreviewKey();
                addChild(key);
                keys[nv] = key;
                if(nv < 36)
                {
                }
                else if(nv < 48)
                {
                }
                else if(nv < 60)
                {
                }
                else if(nv < 72)
                {
                }
                else if(nv < 84)
                {
                }
                else if(nv < 96)
                {
                }
            }
            for(i=0;i<39;i++)
            {
                createKey();
                key.x = i*15.85 +14;
                key.y = 253;
            }
        }
    }
}

var noteValues:Array = [
	/*24,26,28,29,31,*/33,35, //---
    36,38,40,41,43,45,47, //--
    48,50,52,53,55,57,59, //-
    60,62,64,65,67,69,71, //0
    72,74,76,77,79,81,83, //+
    84,86,88,89,91,93,95, //++
	96,98,//100,101,103,105,107
]