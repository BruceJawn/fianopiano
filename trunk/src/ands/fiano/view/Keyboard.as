package ands.fiano.view
{
    import ands.fiano.IKeyboard;
    import ands.fiano.settings.KeySetting;
    import ands.fiano.sound.standingwave.pitch.ChromaticPitch;
    
    import flash.display.Sprite;

    public class Keyboard extends AbstractKeyboard
    {
        private var keys:Vector.<Key> = new Vector.<Key>;

        /**
         * add a key to keyboard, keyboard will create the mapping to the keycode
         * @param key
         */
        public function addKey(key:Key):void
        {
			keys.push(key);
        }

        override public function getKey(keyCode:int):IKey
        {
			var index:int = settings.getKeyIndex(keyCode);
			if(index == -1)
			{
				return DEFAULT_KEY;
			}
            return keys[index];
        }
		
		override protected function updateKeys():void
		{
			keys.forEach(function(key:Key, index:int, keys:Vector.<Key>):void
			{
				key.note = settings.getNoteName(key.keyCode);
			});
		}
		
		public function apply():void
		{
			KeySetting.getInstance().keyName.forEach(function(item:Object, i:int, arr:Array):void
			{
				arr[i] = keys[i].text;
				KeySetting.getInstance().noteValues[i] = getNoteValue(arr[i]);
			});
		}
		
		private function getNoteValue(str:String):int
		{
			var char0:String = str.charAt(0);
			var shift:int = 0;
			var note:int = 0;
			var oct:int = 0;
			if(char0 == "#")
			{
				shift++;
				str = str.substr(1);
			}
			else if(char0 == "b")
			{
				shift--;
				str = str.substr(1);
			}
			char0 = str.charAt(0);
			note = ChromaticPitch.STEP_PITCH_CLASSES[parseInt(char0) - 1];
			str = str.substr(1);
			for(var i:int=0;i<str.length;i++)
			{
				if(str.charAt(i) == "+")
				{
					oct++;
				}
				else
				{
					oct--;
				}
			}
			return ChromaticPitch.pitchAt(note, oct+4).ordinal + shift - KeySetting.getInstance().key;
		}
		
        /**
         * create the default UI
         */
        override protected function createUI():void
        {
            var key:Key;
            var container:Sprite = new Sprite;
			var keyCodes:Array = settings.getKeyCodes();
			
            addChild(container);
            container.x = 0;
            container.y = 347

            function createKey(clazz:Class=null):Key
            {
                if(clazz == null)
                {
                    key = new Key;
                }
                else
                {
                    key = new clazz;
                }
                addKey(key);
				key.keyCode = keyCodes.shift();
                container.addChild(key);
                return key;
            }

            var y:int = 0;
            var offset:int = 31;
            //standard key board (alphabet and number)
            for(var i:int=0;i<12;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }

            y = 28;
            offset += 17;
            for(i=0;i<12;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }

            y = 28*2;
            offset +=5
            for(i=0;i<11;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }

            y = 28*3;
            offset += 15
            for(i=0;i<10;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }

            //starndard control keys and arrows
            y = 0;
            offset = 28 * 15 + 16;
            for(i=0;i<3;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }

            y = 28;
            for(i=0;i<3;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }

            //arrows
            y = 28 * 3
            createKey();
            key.x = offset + 28;
            key.y = y;

            y = 28 * 4;
            for(i=0;i<3;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }

            //numpad
            y = 0;
            offset += 28 * 3 + 15 + 26;
            for(i=0;i<3;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }

            offset -= 28
            y += 28;
            for(i=0;i<3;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }
			
            createKey(VKey);
            key.x = offset + 28 * i;
            key.y = y;

            y += 28;
            for(i=0;i<3;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }

            y += 28;
            for(i=0;i<3;i++)
            {
                createKey();
                key.x = offset + 28 * i;
                key.y = y;
            }
			//enter
			createKey(VKey);
			key.x = offset + 28 * 3;
			key.y = y;
            //zero
            createKey(HKey);
            key.x = offset;
            key.y = y + 28;
            //decimal
            createKey();
            key.x = offset + 2*28;
            key.y = y + 28
			
			updateKeys();
        }
    }
}