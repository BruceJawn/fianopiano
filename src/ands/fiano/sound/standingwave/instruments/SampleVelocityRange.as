package ands.fiano.sound.standingwave.instruments {
    import com.noteflight.standingwave3.elements.*;

    public class SampleVelocityRange {

        public var maxVelocity:Number;
        public var start:uint;
        public var sourceCache:Array;
        public var minVelocity:Number;
        public var tuning:Number = 0
        public var loopEnd:uint;
        public var source:SamplerSource;
        public var loopDecay:Number = 0
        public var loopStart:uint;
        public var gain:Number = 0

        public function SampleVelocityRange(sample:Sample,
                                            minVelocity:Number=0,
                                            maxVelocity:Number=127,
                                            start:uint=0,
                                            loopStart:uint=0,
                                            loopEnd:uint=0,
                                            tuning:Number=0,
                                            loopDecay:Number=0,
                                            gain:Number=0){
            this.sourceCache = [];
            this.sample = sample;
            this.minVelocity = minVelocity;
            this.maxVelocity = maxVelocity;
            this.start = start;
            this.loopStart = loopStart;
            this.loopEnd = loopEnd;
            this.tuning = tuning;
            this.loopDecay = loopDecay;
            this.gain = gain;
        }

        public function matchesVelocity(v:Number):Boolean
        {
            return v <= maxVelocity && v >= minVelocity;
        }

        public function set sample(value:Sample):void
        {
            if (value == null){
                return;
            };
            source = new SamplerSource(new AudioDescriptor(AudioDescriptor.RATE_44100,
                                        value.descriptor.channels), value);
            if (((loopStart) && (loopEnd))){
                source.firstFrame = start;
                source.startFrame = loopStart;
                source.endFrame = loopEnd;
                source.frequencyShift = 1;
            } else {
                source.firstFrame = start;
                source.frequencyShift = 1;
            };
        }
    }
}
