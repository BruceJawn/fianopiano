package ands.fiano.instruments
{
    import flash.utils.ByteArray;
    import ands.fiano.sound.standingwave.instruments.IInstrumentWavSet;

    public class DrumKit implements IInstrumentWavSet
    {
        [Embed(source="/../assets/drumkit/bass.wav", mimeType="application/octet-stream")]
        public static var Base:Class;
        [Embed(source="/../assets/drumkit/pedalHH.wav", mimeType="application/octet-stream")]
        public static var PedalHH:Class;
        [Embed(source="/../assets/drumkit/lowTom.wav", mimeType="application/octet-stream")]
        public static var LowTom:Class;
        [Embed(source="/../assets/drumkit/snare.wav", mimeType="application/octet-stream")]
        public static var Snare:Class;
        [Embed(source="/../assets/drumkit/closedHH.wav", mimeType="application/octet-stream")]
        public static var ClosedHH:Class;
        [Embed(source="/../assets/drumkit/openHH.wav", mimeType="application/octet-stream")]
        public static var OpenHH:Class;
        [Embed(source="/../assets/drumkit/highTom.wav", mimeType="application/octet-stream")]
        public static var HighTom:Class;
        [Embed(source="/../assets/drumkit/ride.wav", mimeType="application/octet-stream")]
        public static var Ride:Class;

        private static var _wavs:Object = {
            "bass.wav":Base,
            "pedalHH.wav":PedalHH,
            "lowTom.wav":LowTom,
            "snare.wav":Snare,

            "closedHH.wav":ClosedHH,
            "openHH.wav":OpenHH,
            "highTom.wav":HighTom,
            "ride.wav":Ride
        };

        public function getWavSampleBytes(name:String):ByteArray
        {
            return new (_wavs[name]);
        }
    }
}
