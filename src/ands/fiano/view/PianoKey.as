package ands.fiano.view
{
	import ands.fiano.sound.standingwave.StandingwaveInstrument;
	import ands.fiano.sound.standingwave.performance.NotePlayer;
	import ands.fiano.sound.standingwave.pitch.ChromaticPitch;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	import swc.HalfKeyBMP;
	import swc.HalfKeyPressedBMP;

	public class PianoKey extends Sprite implements IKey
	{
		private static var half:BitmapData = new HalfKeyBMP(8,22);
		private static var halfPressed:BitmapData = new HalfKeyPressedBMP(8,22);
		private static var KeyLenght:int = 42;
		private static var FillLenght:int = KeyLenght - 1;

		public var isHalfKey:Boolean;
		public var pitch:ChromaticPitch;

		public function PianoKey(pitch:ChromaticPitch)
		{
			this.pitch = pitch;
			isHalfKey = pitch.toString().charAt(1) == "#";

			release();

			buttonMode = true;
			useHandCursor = true;

			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			addEventListener(MouseEvent.ROLL_OVER, rollOverHandler);
			addEventListener(MouseEvent.ROLL_OUT, rollOutHandler);
		}

		private function rollOverHandler(event:MouseEvent):void
		{
			if(event.buttonDown)
			{
				mouseDownHandler(event);
			}
		}

		private function rollOutHandler(event:MouseEvent):void
		{
			if(event.buttonDown)
			{
				mouseUpHandler(event);
			}
		}

		private function mouseDownHandler(event:MouseEvent):void
		{
			NotePlayer.echoNotes(pitch, StandingwaveInstrument.instrument);
			press();
		}

		private function mouseUpHandler(event:MouseEvent):void
		{
			release();
		}

		public function press():void
		{
			graphics.clear();
			if(isHalfKey)
			{
				graphics.beginBitmapFill(halfPressed);
				graphics.drawRect(0,0,8,22);
			}
			else
			{
				graphics.beginFill(0x0, 0.6);
				if(pitch.ordinal == 96)
				{
					graphics.drawRect(0,0,14,KeyLenght);
				}
				else
				{
					graphics.drawRect(0,0,13,KeyLenght);
				}
				graphics.beginFill(0xFFFFFF, 1);
				graphics.drawRect(1,0,12,FillLenght);
				graphics.beginFill(0x0, 1);
				graphics.drawRect(0,FillLenght-3,13,1);
			}
		}

		public function release():void
		{
			graphics.clear();
			if(isHalfKey)
			{
				graphics.beginBitmapFill(half);
				graphics.drawRect(0,0,8,22);
			}
			else
			{
				graphics.beginFill(0x0, 0.6);
				if(pitch.ordinal == 96)
				{
					graphics.drawRect(0,0,14,KeyLenght);
				}
				else
				{
					graphics.drawRect(0,0,13,KeyLenght);
				}
				graphics.beginFill(0xFFFFFF, 1);
				graphics.drawRect(1,0,12,FillLenght);
				graphics.beginFill(0x0, 1);
				graphics.drawRect(0,FillLenght-8,13,1);
			}
		}
	}
}