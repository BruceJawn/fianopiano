package ands.fiano.view
{
	import ands.fiano.settings.KeySetting;
	
	import flash.display.Sprite;

	public class PianoKeyboard extends AbstractKeyboard
	{
		public var keys:Array;
		private var keySettings:KeySetting = KeySetting.getInstance();
		
		override public function getKey(keyCode:int):IKey
		{
			return keys[keySettings.getNoteValue(keyCode) - 9];
		}
		
		/**
		 * create the default UI
		 */
		override protected function createUI():void
		{
			var container:Sprite = new Sprite;
			var container2:Sprite = new Sprite;
			var key:PianoKey;
			
			addChild(container)
			container.y = 261;
			container.x = 12;
			addChild(container2)
			container2.y = 261;
			container2.x = 12;
			
			keys = []
			
			for(var i:int = 0;i<88;i++)
			{
				key = PianoKeyFactory.create(9 + i);
				keys.push(key);
				if(key.isHalfKey)
				{
					container2.addChild(key);
				}
				else
				{
					container.addChild(key);
				}
			}
		}
	}
}