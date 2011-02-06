package ands.fiano.sound.standingwave
{
    import ands.fiano.IKeyboard;
    import ands.fiano.sound.standingwave.instruments.IInstrumentWavSet;
    import ands.fiano.settings.KeySetting;
    import ands.fiano.sound.standingwave.instruments.IInstrument;
    import ands.fiano.sound.standingwave.instruments.SampledInstrument;
    import ands.fiano.sound.standingwave.performance.NotePlayer;
    import ands.fiano.sound.standingwave.performance.PerformableNoteArticulation;
    import ands.fiano.sound.standingwave.pitch.ChromaticPitch;

    import com.noteflight.standingwave3.utils.AudioUtils;

    public class StandingwaveInstrument implements IKeyboard
    {
        public static var instrument:IInstrument;

        private var openChannle:Vector.<NotePlayer> = new Vector.<NotePlayer>(255);
        private var keySettings:KeySetting = KeySetting.getInstance();

        public function StandingwaveInstrument(spec:XML, waveSet:IInstrumentWavSet)
        {
            instrument = createInstrument(spec, waveSet);
        }

        public function actPress(keyCode:int, shift:Boolean):void
        {
            if(openChannle[keyCode] != null)
            {
                openChannle[keyCode].stop();
            }
            var noteValue:int = keySettings.getNoteValue(keyCode);
            openChannle[keyCode] = NotePlayer.echoNotes(new ChromaticPitch(noteValue), instrument);

        }

        public function actRelease(keyCode:int, shift:Boolean):void
        {
        }

        public function createInstrument(spec:XML, waveSet:IInstrumentWavSet):IInstrument
        {
            var _instrument:SampledInstrument = new SampledInstrument(waveSet);
            _instrument.masterTuning = (("tuning" in spec)) ? parseFloat(spec.tuning.toString()) : 0;
            _instrument.release = (("release" in spec)) ? parseFloat(spec.release.toString()) : 0;
            _instrument.gain = (("gain" in spec)) ? parseFloat(spec.gain.toString()) : 0;

            for each (var zone:XML in spec.zones.zone) {
                var name:String = zone.uri.toString();
                var articulation:PerformableNoteArticulation = new PerformableNoteArticulation();
                if (("articulation" in zone)){
                    articulation.value = zone.articulation.toString();
                };
                var rootPitch:ChromaticPitch = ChromaticPitch.pitchFromString(zone.rootPitch.toString());
                var lowPitch:ChromaticPitch = ChromaticPitch.pitchFromString(zone.lowPitch.toString());
                var highPitch:ChromaticPitch = ChromaticPitch.pitchFromString(zone.highPitch.toString());
                var minVelocity:int = (("minVelocity" in zone)) ? parseInt(zone.minVelocity.toString()) : 0;
                var maxVelocity:int = (("maxVelocity" in zone)) ? parseInt(zone.maxVelocity.toString()) : 127;
                var loopStart:int = (("loopStart" in zone)) ? parseInt(zone.loopStart.toString()) : 0;
                var loopEnd:int = (("loopEnd" in zone)) ? parseInt(zone.loopEnd.toString()) : 0;
                var loopDecay:Number = (("loopDecay" in zone)) ? parseFloat(zone.loopDecay.toString()) : 0;
                var tuning:Number = (("tuning" in zone)) ? parseFloat(zone.tuning.toString()) : 0;
                var start:Number = (("start" in zone)) ? parseFloat(zone.attenuation.toString()) : 0;
                var gain:Number = (("gain" in zone)) ? parseFloat(zone.gain.toString()) : 1;
                gain = AudioUtils.factorToDecibels(gain);
                _instrument.addSample(name, articulation, rootPitch, lowPitch, highPitch, minVelocity, maxVelocity, start, loopStart, loopEnd, tuning, loopDecay, gain);
            };
            return (_instrument);
        }
    }
}
