package ands.fiano.sound.standingwave.performance
{
    public class PerformableNoteArticulation
    {

        public var value:String;

        public static const UP_BOW:String = "upBow";
        public static const PIZZICATO:String = "pizzicato";
        public static const MUTED:String = "muted";
        public static const DOWN_BOW:String = "downBow";
        public static const PULL_OFF:String = "pullOff";
        public static const MARCATO:String = "marcato";
        public static const LEGATO:String = "legato";
        public static const OPEN_HAT:String = "openHat";
        public static const SPICCATO:String = "spiccato";
        public static const STACCATO:String = "staccato";
        public static const NORMAL:String = "normal";
        public static const CLOSED_HAT:String = "closedHat";
        public static const HARMONIC:String = "harmonic";
        public static const TENUTO:String = "tenuto";
        public static const FERMATA:String = "fermata";
        public static const STACCATISSIMO:String = "staccatissimo";
        public static const normal:PerformableNoteArticulation = new PerformableNoteArticulation(NORMAL);

        public static const HAMMER_ON:String = "hammerOn";
        public static const MARTELLATO:String = "martellato";

        public function PerformableNoteArticulation(value:String="normal")
        {
            this.value = value;
        }
    }
}
