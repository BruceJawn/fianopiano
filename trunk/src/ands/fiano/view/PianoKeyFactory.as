package ands.fiano.view
{
	import ands.fiano.sound.standingwave.pitch.ChromaticPitch;

	public class PianoKeyFactory
	{
		private static var x:int = 0;
		
		public static function create(value:int):PianoKey
		{
			var pitch:ChromaticPitch = new ChromaticPitch(value)
			var key:PianoKey = new PianoKey(pitch);
			if(pitch.toString().charAt(1) == "#")
			{
				key.x = x - 4;
			}
			else
			{
				key.x = x;
				x += 12.3;
			}
			return key;
		}
	}
}