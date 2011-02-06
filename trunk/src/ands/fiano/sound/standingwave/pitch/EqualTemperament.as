package ands.fiano.sound.standingwave.pitch
{
    public class EqualTemperament extends Temperament
    {

        public function EqualTemperament(centerFreq:Number=440, centerPitch:ChromaticPitch=null)
        {
            super(centerFreq, centerPitch);
        }

        override protected function initializePitchTable():void
        {
            if (_pitchTable == null)
            {
                _pitchTable = new Array(12);
                _pitchTable[centerPitch.pitchClass] = centerFrequency;

                var freq:Number = centerFrequency;
                var i:int;
                for(i = centerPitch.pitchClass + 1;i < 12;i++)
                {
                    freq = (freq * RATIO_EQUAL_SEMITONE);
                    _pitchTable[i] = freq;
                }
                freq = centerFrequency;
                for(i = centerPitch.pitchClass - 1; i >= 0; i--)
                {
                    freq = (freq / RATIO_EQUAL_SEMITONE);
                    _pitchTable[i] = freq;
                };
            };
        }
    }
}
