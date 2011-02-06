package ands.fiano.sound.standingwave.instruments
{
	import flash.utils.ByteArray;

	public interface IInstrumentWavSet
	{
		function getWavSampleBytes(name:String):ByteArray
	}
}