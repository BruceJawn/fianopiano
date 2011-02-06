package ands.fiano.playback
{
    import ands.fiano.settings.KeySetting;
    import ands.fiano.sound.standingwave.pitch.ChromaticPitch;

    import flash.utils.ByteArray;
    import flash.utils.Endian;

    public class LytRecord
    {
        [Embed(source="/../data/template.lyt", mimeType="application/octet-stream")]
        private var TEMPLATE:Class;

        private var fileFormatSymbol:String;
        private var keyDef:String;
        private var keyActions:Array;

        private var keySettings:KeySetting = KeySetting.getInstance();

        public function getKeyActions():Array
        {
            return keyActions;
        }

        public function setKeyActions(value:Array):void
        {
            keyActions = value;
        }

        public function save():ByteArray
        {
            var bytes:ByteArray = new TEMPLATE;
            bytes.endian = Endian.LITTLE_ENDIAN;
            bytes.position = bytes.length;
            bytes.writeInt(keyActions.length);
            var act:KeyAction
            for(var i:int=0;i<keyActions.length;i++)
            {
                act = keyActions[i];
                bytes.writeUnsignedInt(act.timeoffset);
                bytes.writeInt(0);
                bytes.writeByte(act.type);
                bytes.writeInt(keySettings.IDP_KEY_MAPPING[keySettings.keyCodes.indexOf(act.key)]);
            }
            return bytes;
        }

        public function parse(bytes:ByteArray):void
        {
            var str:String;
            var version:int;
            var num:int;
            str = bytes.readMultiByte(16,"utf-8");
            version = bytes.readInt();
            num = bytes.readUnsignedByte();
            str = bytes.readMultiByte(num, "ASCI");
            bytes.position += 0x27 - num;
            num = bytes.readUnsignedByte();
            str = bytes.readMultiByte(num, "ASCI");
            bytes.position += 0x13 - num;
            num = bytes.readUnsignedByte();
            str = bytes.readMultiByte(num, "ASCI");
            bytes.position += 0xFF - num;

            //key mapping;
            keySettings.key = bytes.readInt();
            bytes.position += 8;
            var shiftRight:int = bytes.readInt();
            var shiftLeft:int = bytes.readInt();
            bytes.position = 0x17C;

            var hasNote:int;
            var octive:int;
            var note:int;
            var rightChannel:int;
            var shift:int;
            var i:int = 0;
            var skip:Boolean = false;
            var octShift:int;
            keyActions = [];

            if(version > 1)
            {
                while(bytes.position < 0x213B)
                {
                    hasNote = bytes.readInt();
                    if(hasNote == 1)
                    {
                        note = bytes.readByte();
                        shift = bytes.readByte();
                        octive = bytes.readByte();
                        rightChannel = bytes.readByte();
                        bytes.position += 0x44;
                        octShift = rightChannel?shiftRight:shiftLeft;
                        keySettings.keyName[i] = getName(note, octive, shift, octShift);
                        keySettings.noteValues[i] = getValue(note, octive, shift, octShift);

                        if(skip || (i != 12 && i != 58))
                        {
                            skip = false;
                            i++;
                        }
                        else
                        {
                            skip = true;
                        }
                    }
                    else
                    {
                        bytes.position += 0x48;
                    }
                }

                bytes.position += 240;
            }
            var totalActions:int = bytes.readInt();
            totalActions = bytes.readInt();

            var keyMapping:Array = [];
            for(i =0;i<totalActions;i++)
            {
                var tt:int = bytes.readUnsignedInt();
                bytes.readInt();
                var act:KeyAction = new KeyAction();
                act.timeoffset = tt;
                act.type = bytes.readUnsignedByte();
                act.key = bytes.readInt();
                if(act.key == 14)
                {
                    act.key = keySettings.keyCodes[13]
                }
                else if(act.key == 202)
                {
                    act.key = keySettings.keyCodes[203]
                }
                else
                {
                    act.key = keySettings.keyCodes[keySettings.IDP_KEY_MAPPING.indexOf(act.key)];
                }
                keyActions.push(act);
            }
        }

        private function getName(note:int, octive:int, shift:int, octShift:int):String
        {
            var res:String = "";
            if(shift != 0)
            {
                res += shift == 2?"b":"#";
            }
            res += note;
            switch(octive + octShift)
            {
                case 4:
                    break;
                case 5:
                    res += "+";
                    break;
                case 6:
                    res += "++";
                    break;
                case 7:
                    res += "+++";
                    break;
                case 3:
                    res += "-";
                    break;
                case 2:
                    res += "--";
                    break;
                case 1:
                    res += "---";
                    break;
            }
            return res;
        }

        private function getValue(note:int, octive:int, shift:int, octShift:int):int
        {
            switch(note)
            {
                case 1:
                    note = ChromaticPitch.C;
                    break;
                case 2:
                    note = ChromaticPitch.D;
                    break;
                case 3:
                    note = ChromaticPitch.E;
                    break;
                case 4:
                    note = ChromaticPitch.F;
                    break;
                case 5:
                    note = ChromaticPitch.G;
                    break;
                case 6:
                    note = ChromaticPitch.A;
                    break;
                case 7:
                    note = ChromaticPitch.B;
                    break;
            }
            var res:int = note + (octive + octShift) * ChromaticPitch.PITCHES_PER_OCTAVE;
            if(shift != 0)
            {
                res += shift == 2?-1:1;
            }
            return res;
        }
    }

}
/*
1+:60
2+:62
    3+:64
    4+:65
    5+:67
    6+:69
    7+:71
    1++:72
    2++:74
    3++:76
    4++:77
    5++:79
    6++:48
    1:48
    2:50
    3:52
    4:53
    5:55
    6:57
    7:59
    1+:60
    2+:62
    3+:64
    4+:65
    5+:67
    1-:36
    2-:38
    3-:40
    4-:41
    5-:43
    6-:45
    7-:47
    1:48
    2:50
    3:52
    4:53
    1--:24
    2--:26
    3--:28
    4--:29
    5--:31
    6--:33
    7--:35
    1-:36
    2-:38
    3-:40
    4++:77
    5++:79
    6++:81
    1++:72
    2++:74
    3++:76
    4-:41
    1-:36
    2-:38
    3-:40
    4+:65
    5+:67
    6+:69
    7+:59
    7:59
    1+:60
    2+:62
    3+:64
    4:53
    5:55
    6:57
    1:48
    2:50
    3:52
    7-:47
    5-:43
    6-:45
*/
