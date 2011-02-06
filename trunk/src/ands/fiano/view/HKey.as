package ands.fiano.view
{
	import flash.text.TextField;

	public class HKey extends Key
	{
		override protected function draw():void
		{
			graphics.beginFill(0x0,0.5);
			graphics.drawRect(0,0,56,28);
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(2,2,52,24);
			
			input.width = 54;
		}
	}
}