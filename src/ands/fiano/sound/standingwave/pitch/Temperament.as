package ands.fiano.sound.standingwave.pitch
{

    public class Temperament {

        private var _centerFrequency:Number;
        private var _centerPitch:TemperedPitch;
        protected var _pitchTable:Array;
        private var _tonesPerOctave:uint;

        public static const RATIO_MINOR_THIRD:Number = 1.25;
        public static const RATIO_PERFECT_FIFTH:Number = 1.5;
        public static const RATIO_OCTAVE:Number = 2;
        public static const RATIO_EQUAL_SEMITONE:Number = Math.exp(Math.LN2 / 12);
        public static const RATIO_MAJOR_THIRD:Number = 1.33333333333333;

        public function Temperament(centerFreq:Number=440, centerPitch:TemperedPitch=null)
        {
            this._centerFrequency = centerFreq;
            this._centerPitch = (centerPitch!=null) ? centerPitch : ChromaticPitch.STANDARD_A;
            this.initializePitchTable();
        }

        public function pitchClassFrequency(value:int):Number
        {
            return _pitchTable[value];
        }

        public function get centerFrequency():Number
        {
            return _centerFrequency;
        }

        public function get centerPitch():TemperedPitch
        {
            return _centerPitch;
        }
        public function pitchFrequency(pitch:TemperedPitch):Number
        {
            return (pitchClassFrequency(pitch.pitchClass) * (1 << (16 + pitch.octave - _centerPitch.octave))) / 65536;
        }

        protected function initializePitchTable():void
        {
            throw (new Error("initializePitchTable() not implemented"));
        }
    }
}
