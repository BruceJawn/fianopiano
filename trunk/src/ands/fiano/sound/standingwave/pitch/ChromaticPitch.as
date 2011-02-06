package ands.fiano.sound.standingwave.pitch {

    public class ChromaticPitch extends TemperedPitch
    {
        public static const FLAT_PITCH_NAMES:Array = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"];
        public static const D_SHARP:int = 3;
        public static const F_SHARP:int = 6;
        public static const D_FLAT:int = 1;
        public static const MIDDLE_C_OCTAVE:int = 4;
        public static const MIDDLE_C:ChromaticPitch = ChromaticPitch.pitchAt(C, MIDDLE_C_OCTAVE);
        public static const E_FLAT:int = 3;
        public static const STEP_PITCH_CLASSES:Array = [0, 2, 4, 5, 7, 9, 11];
        public static const A_FLAT:int = 8;
        public static const STANDARD_A:ChromaticPitch = ChromaticPitch.pitchAt(A, MIDDLE_C_OCTAVE);
        public static const A:int = 9;
        public static const B:int = 11;
        public static const C:int = 0;
        public static const D:int = 2;
        public static const E:int = 4;
        public static const F:int = 5;
        public static const G:int = 7;
        public static const PITCHES_PER_OCTAVE:uint = 12;
        public static const A_SHARP:int = 10;
        public static const C_SHARP:int = 1;
        public static const G_SHARP:int = 8;
        public static const SHARP_PITCH_NAMES:Array = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"];
        public static const B_FLAT:int = 10;
        public static const G_FLAT:int = 6;
        public static const STEP_NAMES:String = "CDEFGAB";

        public function ChromaticPitch(ordinal:int)
        {
            super(ordinal);
        }

        override public function get pitchesPerOctave():uint
        {
            return (PITCHES_PER_OCTAVE);
        }

        public static function pitchAt(pc:int, oct:int):ChromaticPitch
        {
            return new ChromaticPitch(pc + oct * PITCHES_PER_OCTAVE);
        }

        public static function pitchFromString(str:String):ChromaticPitch
        {
            var value:Number = parseInt(str);
            if (!(isNaN(value))){
                return new ChromaticPitch(value);
            };
            var step:int = STEP_NAMES.indexOf(str.charAt(0));
            if (step < 0){
                throw (new Error(("Unrecognized pitch step " + str)));
            };
            var pc:int = STEP_PITCH_CLASSES[step];
            str = str.substring(1);
            if (str.charAt(0) == "#"){
                pc++;
                str = str.substring(1);
            } else {
                if (str.charAt(0) == "b"){
                    pc--;
                    str = str.substring(1);
                };
            };
            var oct:Number = parseInt(str);
            if (isNaN(oct)){
                throw (new Error(("Unrecognized octave: " + str)));
            };
            return (ChromaticPitch.pitchAt(pc, oct));
        }
    }
}
