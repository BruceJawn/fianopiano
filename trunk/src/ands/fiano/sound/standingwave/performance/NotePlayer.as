package ands.fiano.sound.standingwave.performance
{
    import ands.fiano.sound.standingwave.instruments.IInstrument;
    import ands.fiano.sound.standingwave.pitch.ChromaticPitch;

    import com.noteflight.standingwave3.elements.*;
    import com.noteflight.standingwave3.output.*;
    import com.noteflight.standingwave3.performance.*;

    import flash.events.*;

    public class NotePlayer extends EventDispatcher
    {
        public var gain:Number = -6;

        private var audioPlayer:AudioPlayer;

        private var note:PerformableNote;
        private var instrument:IInstrument;

        private var endTime:Number;

        public function NotePlayer(note:PerformableNote, instrument:IInstrument)
        {
            this.note = note;
            this.instrument = instrument;
        }

        private function handlePlayerStop(event:Event):void
        {
            dispatchEvent(event);
        }

        public function stop():void
        {
            if (audioPlayer != null)
            {
                audioPlayer.stop();
                audioPlayer = null;
            };
            dispatchEvent(new Event(Event.SOUND_COMPLETE));
        }

        public function get position():Number
        {
            if (audioPlayer == null)
            {
                return 0;
            }
            return Math.max(0, audioPlayer.position);
        }

        public static function echoNotes(pitch:ChromaticPitch, instrument:IInstrument):NotePlayer
        {
            if(pitch == null)
            {
                return null;
            }
            var note:PerformableNote;
            note = new PerformableNote();
            note.pitch = pitch;
            note.duration = 2.4;
            return new NotePlayer(note, instrument).play();
        }

        public function play():NotePlayer
        {
            endTime = note.duration;

            var performer:AudioPerformer =
                new AudioPerformer(realizePerformanceElements(note),
                        new AudioDescriptor(AudioDescriptor.RATE_44100, AudioDescriptor.CHANNELS_STEREO));
            performer.mixGain = gain;
            audioPlayer = new AudioPlayer();
            audioPlayer.addEventListener(ProgressEvent.PROGRESS, handlePlayerProgress);
            audioPlayer.addEventListener(Event.SOUND_COMPLETE, handlePlayerStop);
            audioPlayer.play(performer);
            return this;
        }

        public function realizePerformanceElements(note:PerformableNote):ListPerformance
        {
            var listPerformance:ListPerformance = new ListPerformance();
            listPerformance.addElement(instrument.realize(note));
            return listPerformance;
        }

        private function handlePlayerProgress(event:ProgressEvent):void
        {
            dispatchEvent(event);
            if (position > endTime)
            {
                stop();
            }
        }
    }
}
