package ands.fiano.settings
{
    public class KeySetting
    {
        public static var editing:Boolean = false;

        public var key:int = 0;

        public var keyCodes:Array = [
            49,50,51,52,   53,54,55,   56,57,48,189,187,
            81,87,69,82,   84,89,85,   73,79,80,219,221,
            65,83,68,70,   71,72,74,   75,76,186,222,
            90,88,67,86,   66,78,77,   188,190,191,

            45,36,33,
            46,35,34,
            38,
            37,40,39,

            111,106,109,
            103,104,105,107,
            100,101,102,
            97,98,99,13,
            96,110];

        public var keyName:Array = [
            "1+","2+","3+","4+","5+","6+","7+","1++","2++","3++","4++","5++",
            "1","2","3","4","5","6","7","1+","2+","3+","4+","5+",
            "1-","2-","3-","4-","5-","6-","7-","1","2","3","4",
            "1--","2--","3--","4--","5--","6--","7--","1-","2-","3-",

            "4++","5++","6++",
            "1++","2++","3++",
            "4-",
            "1-","2-","3-",

            "4+","5+","6+",
            "7","1+","2+","3+",
            "4","5","6",
            "1","2","3","7-",
            "5-","6-"];

        public var noteValues:Array = [
            60,62,64,65,	67,69,71,	72,74,76,77,79,
            48,50,52,53,	55,57,59,	60,62,64,65,67,
            36,38,40,41,	43,45,47,	48,50,52,53,
            24,26,28,29,	31,33,35,	36,38,40,
            77,79,81,
            72,74,76,
            41,
            36,38,40,

            65,67,69,
            59,60,62,64,
            53,55,57,
            48,50,52,47,
            43,45];

        public var IDP_KEY_MAPPING:Array = [//
            2,3,4,5,		6,7,8,		9,10,11,12,13, //43,
            16,17,18,19,	20,21,22,	23,24,25,26,27,
            30,31,32,33,	34,35,36,	37,38,39,40,
            44,45,46,47,	48,49,50,	51,52,53,
            210,199,201,
            211,207,209,
            200,
            203,208,205,

            69,181,55,//74,
            71,72,73,78,
            75,76,77,
            79,80,81,156,
            82,83
        ]


        public function KeySetting()
        {
        }

        public static var instance:KeySetting;
        public static function getInstance():KeySetting
        {
            return instance ||= new KeySetting;
        }

        private var listeners:Array = [];
        public function addListener(listener:IKeySettingsListener):void
        {
            listeners.push(listener);
        }

        public function getNoteName(keycode:int):String
        {
            return keyName[keyCodes.indexOf(keycode)];
        }

        public function getNoteValue(keycode:int):int
        {
            return noteValues[keyCodes.indexOf(keycode)] + key;
        }

        public function getKeyCodes():Array
        {
            return keyCodes.slice();
        }

        public function getKeyIndex(keycode:int):int
        {
            return keyCodes.indexOf(keycode);
        }
    }
}
