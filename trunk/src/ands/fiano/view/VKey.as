package ands.fiano.view
{
	import flash.text.TextField;

	public class VKey extends Key
	{
		override protected function draw():void
		{
			graphics.beginFill(0x0,0.5);
			graphics.drawRect(0,0,28,56);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(2,2,24,52);
			
			input.height = 54;
		}
	}
}