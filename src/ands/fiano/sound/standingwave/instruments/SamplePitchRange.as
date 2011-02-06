package ands.fiano.sound.standingwave.instruments
{
    import ands.fiano.sound.standingwave.pitch.*;
    import com.noteflight.standingwave3.elements.*;

    public class SamplePitchRange
    {

        public var rootPitch:ChromaticPitch;
        public var maxPitch:ChromaticPitch;
        public var minPitch:ChromaticPitch;
        public var velocityMap:Array;

        public function SamplePitchRange(rootPitch:ChromaticPitch=null,
                                         minPitch:ChromaticPitch=null,
                                         maxPitch:ChromaticPitch=null)
        {
            super();
            this.velocityMap = [];
            this.rootPitch = rootPitch;
            this.minPitch = ((minPitch)!=null) ? minPitch : rootPitch;
            this.maxPitch = ((maxPitch)!=null) ? maxPitch : rootPitch;
        }

        public function findSample(v:Number):SampleVelocityRange
        {

            for each (var r:SampleVelocityRange in velocityMap)
            {
                if (r.matchesVelocity(v))
                {
                    return r;
                }
            };
            return null;
        }

        public function addSample(sample:Sample,
                                minVelocity:Number=0,
                                maxVelocity:Number=127,
                                start:uint=0,
                                loopStart:uint=0,
                                loopEnd:uint=0,
                                tuning:Number=0,
                                loopDecay:Number=0,
                                gain:Number=0):SampleVelocityRange
        {
            var velocityRange:SampleVelocityRange =
                new SampleVelocityRange(sample, minVelocity, maxVelocity,
                                        start, loopStart, loopEnd,
                                        tuning, loopDecay, gain);
            velocityMap.push(velocityRange);
            return velocityRange;
        }

        public function matchesPitch(pitch:ChromaticPitch):Boolean
        {
            if (rootPitch == null)
            {
                return true;
            };
            if (pitch.ordinal < minPitch.ordinal)
            {
                return false;
            };
            if (pitch.ordinal > maxPitch.ordinal)
            {
                return false;
            };
            return true;
        }

    }
}
