package ands.fiano.view
{
    import ands.fiano.settings.KeySetting;
    
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;
    import flash.text.TextField;
    import flash.text.TextFormat;

    public class Key extends Sprite implements IKey
    {
        protected var label:TextField;
		protected var input:TextField;
		
        private static var format:TextFormat = new TextFormat("Arial",11,0x333333,true);
		
		private static var tabIndex:int = 1;
			
		public var keyCode:int;

		public function get text():String
		{
			return input.text;
		}
		
        public function Key()
        {
			
			label = new TextField();
			label.x = 8;
			label.y = 4;
			label.selectable = false;
			label.autoSize = "left";
			addChild(label);
			
			input = new TextField();
			input.type = "input";
//			input.autoSize = "left";
			input.multiline = false;
			input.wordWrap = false;
			input.width = 26;
			input.height = 26;
			input.border = true;
			input.background = true;
			input.maxChars = 5;
			input.restrict = "#b1234567+-"
			input.tabIndex = tabIndex++;
			addChild(input);
			input.visible = false;
			
			draw();
        }

        protected function draw():void
        {
            graphics.beginFill(0x0,0.5);
            graphics.drawRect(0,0,28,28);
            graphics.beginFill(0xFFFFFF);
            graphics.drawRect(2,2,24,24);
        }

        public function set note(str:String):void
        {
            if(str == null)
            {
                return;
            }
			
			input.text = str;
			input.visible = KeySetting.editing;
			if(str.charAt(0) == "b" || str.charAt(0) == "#")
			{
				label.text = str.substr(0,2);
				label.x = 6
				str = str.substr(1);
			}
			else
			{
				label.x = 8
            	label.text = str.charAt(0);
			}
			
			if(str.length > 3)
			{
				if(str.charAt(1) == "+")
				{
					label.y = 6;
					graphics.beginFill(0x333333);
					graphics.drawCircle(13,3,1.5);
					graphics.drawCircle(13,6,1.5);
					graphics.drawCircle(13,9,1.5);
				}
				else
				{
					label.y = 2;
					graphics.beginFill(0x333333);
					graphics.drawCircle(13,17,1.5);
					graphics.drawCircle(13,20,1.5);
					graphics.drawCircle(13,23,1.5);
				}
			}
            if(str.length > 2)
            {
                if(str.charAt(1) == "+")
                {
                    label.y = 6;
                    graphics.beginFill(0x333333);
                    graphics.drawCircle(13,6,1.5);
                    graphics.drawCircle(13,9,1.5);
                }
                else
                {
                    label.y = 2;
                    graphics.beginFill(0x333333);
                    graphics.drawCircle(13,17,1.5);
                    graphics.drawCircle(13,20,1.5);
                }
            }
            else if(str.length > 1)
            {
                if(str.charAt(1) == "+")
                {
                    label.y = 5;
                    graphics.beginFill(0x333333);
                    graphics.drawCircle(13,7,1.5);
                }
                else
                {
                    label.y = 3+ (this is VKey?28:0);
                    graphics.beginFill(0x333333);
                    graphics.drawCircle(13,18 + (this is VKey?28:0),1.5);
                }
            }
            label.setTextFormat(format);
        }

        private static var glow:GlowFilter = new GlowFilter(0,1,6,6,2,1,true);
        public function press():void
        {
            filters = [glow];
        }

        public function release():void
        {
            filters = [];
        }
    }
}