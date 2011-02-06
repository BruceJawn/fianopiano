package ands.fiano.sound.standingwave.pitch
{
    public class TemperedPitch extends Pitch
    {

        public function TemperedPitch(ordinal:int)
        {
            super(ordinal);
        }

        public function get octave():int
        {
            return (ordinal - pitchClass) / pitchesPerOctave;
        }

        public function get pitchClass():int
        {
            if (ordinal >= 0)
            {
                return ordinal % pitchesPerOctave;
            };
            return 11 - ((-ordinal - 1) % pitchesPerOctave);
        }

        public function toString():String
        {
            return "[Pitch class=" + pitchClass + " octave=" + octave + "]";
        }

        public function get pitchesPerOctave():uint
        {
            throw new Error("pitchesPerOctave property not implemented");
        }
    }
}
