package ands.fiano.instruments
{
    import flash.utils.ByteArray;
    import ands.fiano.sound.standingwave.instruments.IInstrumentWavSet;

    public class Piano implements IInstrumentWavSet
    {
        [Embed(source="/../assets/C1.wav", mimeType="application/octet-stream")]
        public static var C1:Class;
        [Embed(source="/../assets/C2.wav", mimeType="application/octet-stream")]
        public static var C2:Class;
        [Embed(source="/../assets/C3.wav", mimeType="application/octet-stream")]
        public static var C3:Class;
        [Embed(source="/../assets/C4.wav", mimeType="application/octet-stream")]
        public static var C4:Class;
        [Embed(source="/../assets/C5.wav", mimeType="application/octet-stream")]
        public static var C5:Class;
        [Embed(source="/../assets/C6.wav", mimeType="application/octet-stream")]
        public static var C6:Class;
        [Embed(source="/../assets/C7.wav", mimeType="application/octet-stream")]
        public static var C7:Class;
        [Embed(source="/../assets/Fs1.wav", mimeType="application/octet-stream")]
        public static var Fs1:Class;
        [Embed(source="/../assets/Fs2.wav", mimeType="application/octet-stream")]
        public static var Fs2:Class;
        [Embed(source="/../assets/Fs3.wav", mimeType="application/octet-stream")]
        public static var Fs3:Class;
        [Embed(source="/../assets/Fs4.wav", mimeType="application/octet-stream")]
        public static var Fs4:Class;

        private static var _wavs:Object = {
            "C1.wav":C1,
            "C2.wav":C2,
            "C3.wav":C3,
            "C4.wav":C4,
            "C5.wav":C5,
            "C6.wav":C6,
            "C7.wav":C7,
            "Fs1.wav":Fs1,
            "Fs2.wav":Fs2,
            "Fs3.wav":Fs3,
            "Fs4.wav":Fs4
        };

        public function getWavSampleBytes(name:String):ByteArray
        {
            return new (_wavs[name]);
        }
    }
}
