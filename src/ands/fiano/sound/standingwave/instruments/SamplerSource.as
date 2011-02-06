package ands.fiano.sound.standingwave.instruments
{
    import com.noteflight.standingwave3.modulation.*;
    import com.noteflight.standingwave3.elements.*;
    import com.noteflight.standingwave3.sources.*;

    public class SamplerSource extends AbstractSource {

        public var frequencyShift:Number = 1;
        public var endFrame:Number = 0
        public var pitchModulations:Array;
        public var firstFrame:Number = 0;
        public var startFrame:Number = 0;

        protected var _pitchModulationData:LineData;
        protected var _realizedModulations:Array;
        protected var _phase:Number = 0;

        private var _generator:IDirectAccessSource;

        private static const LOOP_MAX:Number = 30;

        public function SamplerSource(descriptor:AudioDescriptor, generator:IDirectAccessSource){
            super(descriptor, 0, 1);
            pitchModulations = [];

            _generator = generator;
            _pitchModulationData = new LineData();
            _realizedModulations = [];
            _position = 0;
        }

        override public function get duration():Number
        {
            return (frameCount / descriptor.rate);
        }

        protected function realizeModulationData():void
        {
            while (pitchModulations.length > 0) {
                var m:IPerformableModulation = pitchModulations.shift();
                m.realize(_pitchModulationData);
                _realizedModulations.push(m);
            };
        }

        override public function resetPosition():void{
            _phase = 0;
            _position = 0;
        }

        override public function getSample(numFrames:Number):Sample
        {
            realizeModulationData();

            var segment:Array = _pitchModulationData.getSegments(position, ((position + numFrames) - 1));
            var res:Sample = new Sample(descriptor, numFrames, false);
            var offset:Number = (frequencyShift * (_generator.descriptor.rate / _descriptor.rate));
            var tableSize:Number = endFrame?Math.floor(endFrame):_generator.frameCount;
            var phaseAdd:Number = (offset / tableSize);
            var phaseReset:Number = startFrame && endFrame ? (startFrame/tableSize):-1;
            if (_phase == 0 && firstFrame)
            {
                _phase = (firstFrame / tableSize);
            };
            _generator.fill((Math.ceil((_position / offset)) + 1));
            for(var i:int=0;i < segment.length;i += 2)
            {
                _phase = res.wavetableInDirectAccessSource(
                    _generator, tableSize, _phase,
                    phaseAdd, phaseReset,
                    segment[i] - position,
                    segment[i+1] - segment[i] + 1,
                    _pitchModulationData.getModForRange(segment[i], segment[i+1]));
            };
            _position += numFrames;
            return res;
        }

        override public function get frameCount():Number
        {
            if (endFrame){
                return ((LOOP_MAX * descriptor.rate));
            };
            return Math.floor((_generator.frameCount - firstFrame) / (frequencyShift * (_generator.descriptor.rate / _descriptor.rate)));
        }

        override public function clone():IAudioSource
        {
            var res:SamplerSource = new SamplerSource(_descriptor, _generator);
            res.startFrame = startFrame;
            res.endFrame = endFrame;
            res.frequencyShift = frequencyShift;
            res.resetPosition();
            return (res);
        }
    }
}
