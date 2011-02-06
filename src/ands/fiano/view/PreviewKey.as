package ands.fiano.view
{
    import ands.fiano.sound.standingwave.pitch.ChromaticPitch;
    
    import flash.display.Sprite;
    import flash.events.MouseEvent;

    public class PreviewKey extends Sprite implements IKey
    {
        public function PreviewKey()
        {
            graphics.beginFill(0xFFFFFF, 0);
            graphics.drawRect(0,0,15,38);
            graphics.beginFill(0x0);
            graphics.drawRect(0,38,16,1);

            addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
            addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
        }

        private function mouseDownHandler(event:MouseEvent):void
        {
        }

        private function mouseUpHandler(event:MouseEvent):void
        {
        }

        public function press():void
        {
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 0);
			graphics.drawRect(0,0,15,38);
			graphics.beginFill(0x0);
			graphics.drawRect(0,44,16,1);
        }

        public function release():void
        {
			graphics.clear();
			graphics.beginFill(0xFFFFFF, 0);
			graphics.drawRect(0,0,15,38);
			graphics.beginFill(0x0);
			graphics.drawRect(0,38,16,1);
        }
    }
}