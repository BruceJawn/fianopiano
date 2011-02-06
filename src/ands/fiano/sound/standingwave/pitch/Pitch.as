package ands.fiano.sound.standingwave.pitch
{
    public class Pitch {

        private var _ordinal:int;

        public function Pitch(ordinal:int)
        {
            _ordinal = ordinal;
        }
        public function get ordinal():int
        {
            return _ordinal;
        }
    }
}
