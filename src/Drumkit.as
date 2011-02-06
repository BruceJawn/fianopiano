package
{
	import ands.fiano.IKeyboard;
	import ands.fiano.KeyManager;
	import ands.fiano.instruments.DrumKit;
	import ands.fiano.sound.standingwave.StandingwaveInstrument;
	import ands.fiano.view.Keyboard;

	import flash.display.Sprite;
	import flash.events.Event;

	[SWF(width="650", height="500", frameRate="30")]
	dynamic public class Drumkit extends Sprite
	{
		public var keyManager:KeyManager = new KeyManager();
		public var keyboard:Keyboard;

		[Embed(source="/../assets/drumkit/spec.xml", mimeType="application/octet-stream")]
		private static var config:Class;

		public function Drumkit()
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init(event:Event):void
		{
			keyManager.addKeyboard(createComputerKeyboardView());
			keyManager.addKeyboard(createInstrument());
			keyManager.listen(stage);
		}

		private function createComputerKeyboardView():IKeyboard
		{
			keyboard = new Keyboard;
			addChild(keyboard);
			return keyboard;
		}

		private function createInstrument():IKeyboard
		{
			return new StandingwaveInstrument(XML(new config), new ands.fiano.instruments.DrumKit);
		}
	}
}