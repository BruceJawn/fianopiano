package ands.fiano.sound.standingwave.instruments
{
    import ands.fiano.sound.standingwave.performance.*;
    import ands.fiano.sound.standingwave.pitch.*;

    import com.noteflight.standingwave3.elements.*;
    import com.noteflight.standingwave3.filters.*;
    import com.noteflight.standingwave3.formats.*;
    import com.noteflight.standingwave3.generators.*;
    import com.noteflight.standingwave3.modulation.*;
    import com.noteflight.standingwave3.performance.*;

    import flash.events.*;
    import flash.net.*;
    import flash.utils.*;

    public class SampledInstrument extends EventDispatcher implements IInstrument
    {

        public static var GAIN_ADJUST:Number = -14

        public var legatoOffset:Number = 0;
        public var release:Number = 0.1;
        public var gain:Number = 0;
        public var masterTuning:Number = 0;
        public var decay:Number = 0;
        public var attack:Number = 0;

        private var pitchMap:Object;
        private var _sampleTemperament:Temperament;
        private var _playbackTemperament:Temperament;
        private var _releaseGenerator:FadeEnvelopeGenerator;

        private var instrumentWavSet:IInstrumentWavSet;

        public function SampledInstrument(instrumentWavSet:IInstrumentWavSet)
        {
            pitchMap = {};
            this.instrumentWavSet = instrumentWavSet;

            _playbackTemperament =
            _sampleTemperament = new EqualTemperament();
        }
        private function findPitchRange(pitch:ChromaticPitch,
                                          articulation:PerformableNoteArticulation):SamplePitchRange
        {
            for each (var r:SamplePitchRange in pitchMap[articulation.value])
            {
                if (r.matchesPitch(pitch))
                {
                    return r;
                }
            }
            return null;
        }

        public function addSample(name:String,
                                  articulation:PerformableNoteArticulation=null,
                                  rootPitch:ChromaticPitch=null,
                                  minPitch:ChromaticPitch=null,
                                  maxPitch:ChromaticPitch=null,
                                  minVelocity:Number=0,
                                  maxVelocity:Number=127,
                                  start:uint=0,
                                  loopStart:uint=0,
                                  loopEnd:uint=0,
                                  tuning:Number=0,
                                  loopDecay:Number=0,
                                  gain:Number=0):void
        {

            if (articulation == null){
                articulation = PerformableNoteArticulation.normal;
            };
            if (!pitchMap[articulation.value]){
                pitchMap[articulation.value] = [];
            };
            var pitchRange:SamplePitchRange = findPitchRange(rootPitch, articulation);
            if (pitchRange == null){
                pitchRange = new SamplePitchRange(rootPitch, minPitch, maxPitch);
                pitchMap[articulation.value].push(pitchRange);
            };
            var velRange:SampleVelocityRange =
                pitchRange.addSample(null, minVelocity, maxVelocity, start, loopStart, loopEnd, tuning, loopDecay, gain);
            velRange.sample = WaveFile.createSample(instrumentWavSet.getWavSampleBytes(name))
        }

        private function addPitchModulations(source:SamplerSource, modulations:Array):IAudioSource
        {
            source.pitchModulations = modulations;
            return source;
        }

        private function addLegatoModulations(source:SamplerSource, note:PerformableNote):IAudioSource
        {
            if (note.articulation.value == PerformableNoteArticulation.LEGATO){
                source.firstFrame = legatoOffset;
            };
            return source;
        }

        private function addAttackFilter(source:IAudioSource, duration:Number):IAudioSource
        {
            if (duration > 0)
            {
                return new AttackFilter(source, duration);
            }
            return source;
        }

        private function addDecayFilter(source:IAudioSource, duration:Number, start:Number):IAudioSource
        {
            if (duration > 0)
            {
                return new DecayFilter(source, start, duration);
            }
            return source;
        }

        private function addReleaseFilter(source:IAudioSource, duration:Number):IAudioSource
        {
            if (this.release > 0)
            {
                if (!this._releaseGenerator){
                    this._releaseGenerator = new FadeEnvelopeGenerator(source.descriptor, this.release, FadeEnvelopeGenerator.FADE_OUT);
                    this._releaseGenerator.fill();
                };
                return new FadeOutFilter(source, this._releaseGenerator, duration)
            };
            return source;
        }

        public function getAudioSource(note:PerformableNote, cache:Boolean=true):IAudioSource
        {
            //find the pitch range by articalution,
            //samples are arranged by sample range
            //pitchMap[aricalution][range][sample value]
            var samplePitchRange:SamplePitchRange = this.findPitchRange(note.pitch, note.articulation);
            if (samplePitchRange == null){
                samplePitchRange = this.findPitchRange(note.pitch, new PerformableNoteArticulation(PerformableNoteArticulation.NORMAL));
                if (samplePitchRange == null){
                    return (null);
                };
            };
            var sampleVelocityRange:SampleVelocityRange = samplePitchRange.findSample(note.velocity);
            if ((((sampleVelocityRange == null)) || ((sampleVelocityRange.source == null)))){
                return (null);
            };
            var shift:Number = this.getShiftForNote(note.pitch, samplePitchRange.rootPitch, sampleVelocityRange.tuning);
            var duration:Number = ((note.duration + this.release) * sampleVelocityRange.source.descriptor.rate);
            //we first fetch the audio source from the cache
            //but if there are additional effect on the requesed sample
            //or it will be too long, we generate it.
            if (duration > CacheFilter.MAX_CACHE){
                cache = false;
            };
            if (note.pitchModulations.length > 0){
                cache = false;
            };
            if (note.articulation.value != PerformableNoteArticulation.NORMAL){
                cache = false;
            };

            var random:IAudioSource;
            if (sampleVelocityRange.sourceCache[note.pitch.ordinal] && cache)
            {
                random = sampleVelocityRange.sourceCache[note.pitch.ordinal];
            }
            else if (cache)
            {
                var tempSource:IAudioSource = sampleVelocityRange.source.clone();
                SamplerSource(tempSource).frequencyShift = shift;
                tempSource = this.addDecayFilter(tempSource, sampleVelocityRange.loopDecay, (sampleVelocityRange.loopStart / tempSource.descriptor.rate));
                random = new CacheFilter(tempSource);
                sampleVelocityRange.sourceCache[note.pitch.ordinal] = random;
            };
            //
            var res:IAudioSource;
            if (cache)
            {
                res = random.clone();
                res = addReleaseFilter(res, note.duration);
            }
            else
            {
                res = sampleVelocityRange.source.clone();
                SamplerSource(res).frequencyShift = shift;
                res = addPitchModulations((res as SamplerSource), note.pitchModulations);
                res = addLegatoModulations((res as SamplerSource), note);
                res = addDecayFilter(res, sampleVelocityRange.loopDecay, (sampleVelocityRange.loopStart / res.descriptor.rate));
                res = addReleaseFilter(res, note.duration);
            };
            return (res);
        }

        private function getShiftForNote(pitch:ChromaticPitch, root:ChromaticPitch, tuning:Number):Number
        {
            var shift:Number = _playbackTemperament.pitchFrequency(pitch) / _sampleTemperament.pitchFrequency(root);
            if(masterTuning + tuning != 0)
            {
                shift *= Math.exp(Math.LN2 * (masterTuning + tuning) / 1200)
            }
            return shift;
        }
        public function realize(note:PerformableNote, cache:Boolean=true):PerformableAudioSource
        {
            var res:PerformableAudioSource;
            var pitchRange:SamplePitchRange;
            var velocityRange:SampleVelocityRange;
            var source:IAudioSource = getAudioSource(note, cache);
            if (source != null){
                res = new PerformableAudioSource(note.onset, source);
                res.gain = gain;
                pitchRange = findPitchRange(note.pitch, note.articulation);
                if (pitchRange == null){
                    pitchRange = findPitchRange(note.pitch, PerformableNoteArticulation.normal);
                };
                if (pitchRange){
                    velocityRange = pitchRange.findSample(note.velocity);
                    res.gain = (res.gain + velocityRange.gain);
                };
                res.gain = (res.gain + (GAIN_ADJUST + (note.velocity * 0.25)));
                return res;
            };
            return (null);
        }
    }
}
