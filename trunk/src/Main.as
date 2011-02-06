package
{
    import ands.fiano.IKeyboard;
    import ands.fiano.KeyManager;
    import ands.fiano.Menu;
    import ands.fiano.Recorder;
    import ands.fiano.instruments.Piano;
    import ands.fiano.sound.standingwave.StandingwaveInstrument;
    import ands.fiano.view.Keyboard;
    import ands.fiano.view.PianoKeyboard;

    import flash.display.Sprite;
    import flash.events.Event;

    import swc.Assets;

    [SWF(width="650", height="500", frameRate="30")]
    dynamic public class Main extends Sprite
    {
        public var keyManager:KeyManager = new KeyManager();

        public var menu:Menu;
        public var keyboard:Keyboard;
        public var pianoKeyboard:PianoKeyboard
        public var background:Assets;
        public var recorder:Recorder

        [Embed(source="/../assets/spec.xml", mimeType="application/octet-stream")]
        private static var config:Class;

        public function Main()
        {
            addEventListener(Event.ADDED_TO_STAGE, init);
        }

        public function init(event:Event):void
        {
            keyManager.addKeyboard(createComputerKeyboardView());
            keyManager.addKeyboard(createInstrument());
            keyManager.addKeyboard(createKeyboardView());
            keyManager.addKeyboard(createRecorder());
            keyManager.listen(stage);

            menu = new Menu(this);
            stage.addChild(menu);
        }

        private function createComputerKeyboardView():IKeyboard
        {
            addChild(background = new Assets);
            keyboard = new Keyboard;
            addChild(keyboard);
            return keyboard;
        }

        private function createKeyboardView():IKeyboard
        {
            pianoKeyboard = new PianoKeyboard;
            addChild(pianoKeyboard);
            return pianoKeyboard;
        }

        private function createInstrument():IKeyboard
        {
            return new StandingwaveInstrument(XML(new config), new Piano);
        }

        private function createRecorder():IKeyboard
        {
            return recorder = new Recorder;;
        }
    }
}