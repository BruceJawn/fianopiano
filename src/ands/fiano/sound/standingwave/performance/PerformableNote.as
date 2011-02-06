package ands.fiano.sound.standingwave.performance
{
    import ands.fiano.sound.standingwave.pitch.*;

    public class PerformableNote
    {
        public var onset:Number = 0;
        public var duration:Number;
        public var pitch:ChromaticPitch = null;
        public var channel:int = 0;
        public var pitchModulations:Array;
        public var velocity:Number = STANDARD_VELOCITY;
        public var articulation:PerformableNoteArticulation = PerformableNoteArticulation.normal;

        public static const MAX_VELOCITY:Number = 127;
        public static const STANDARD_VELOCITY:Number = 100;

        public function PerformableNote()
        {
            this.pitchModulations = [];
        }

        public function cloneNote():PerformableNote{
            var res:PerformableNote = new PerformableNote();
            res.onset = onset;
            res.duration = duration;
            res.pitch = this.pitch;
            res.velocity = this.velocity;
            res.channel = this.channel;
            res.articulation = this.articulation;
            res.pitchModulations = this.pitchModulations.slice();
            return res;
        }
    }
}
