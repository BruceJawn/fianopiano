package ands.fiano
{
	import ands.fiano.playback.AboutSong;
	import ands.fiano.playback.LytRecord;
	import ands.fiano.playback.Playback;
	import ands.fiano.settings.KeySetting;

	import com.greensock.TweenMax;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Quad;
	import com.greensock.easing.Quart;

	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BevelFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	import swc.Menu;

	public class Menu extends swc.Menu
	{
		public static const PLAY:String = "play";
		public static const RECORD:String = "record";
		public static const READY:String = "ready";
		public static const ABOUT:String = "about";
		public static const SETTINGS:String = "settings";
		public static const INIT:String = "init";
		public static const SELECT_SAMPLE:String = "selectSample";

		private var app:Main;
		private var record:ByteArray;
		private var lyt:LytRecord = new LytRecord();
		private var playBack:Playback = new Playback();

		private var currentState:String;

		public static const SLOW:Boolean = true;
		public static const ORIGINAL:Boolean = false;

		public function Menu(app:Main)
		{
			this.app = app;
			initState();
			app.background.keySwitch.buttonMode=true;
			app.background.keySwitch.useHandCursor=true;

			asMenu(openButton);
			asMenu(playButton);

			//click about

			//click play
			playButton.addEventListener(MouseEvent.CLICK, function(event:Event):void
			{
				if(currentState == PLAY)
				{
						playBack.stop();
						readyState();
						TweenMax.to(app.background.logo, 0.5,{y:85, ease:Quart.easeOut});
						TweenMax.to(app.background.logo, 0.5,{alpha:1, ease:Quart.easeIn});
				}
				else
				{
					if(openButton.mouseY < 26)
					{
						playRecord(ORIGINAL);
					}
					else if(openButton.mouseY < 51)
					{
						playRecord(SLOW);
					}
					else
					{
					}
					playState();
					TweenMax.to(app.background.logo, 0.5,{alpha:0, y:35, ease:Quart.easeOut});
				}
			});

			openButton.addEventListener(MouseEvent.CLICK, function(event:Event):void
			{
				if(openButton.mouseY < 26)
				{
					var file:FileReference = new FileReference();
					var selectHandler:Function;
					var completeHandler:Function;

					file.browse([new FileFilter("idreampiano song file","*.lyt")]);
					file.addEventListener(Event.COMPLETE, completeHandler = function(event:Event):void
					{
						record = file.data
						record.endian = Endian.LITTLE_ENDIAN;
						cleanUp();

						parseRecord();
						readyState();
					});
					file.addEventListener(Event.SELECT, selectHandler = function(event:Event):void
					{
						file.load();
					});

					function cleanUp():void
					{
						file.removeEventListener(Event.COMPLETE, completeHandler);
						file.removeEventListener(Event.SELECT, selectHandler);
					}
				}
				else
				{
				}
			});

			recordButton.addEventListener(MouseEvent.CLICK, function(event:Event):void
			{
				if(currentState == RECORD)
				{
					TweenMax.to(app.background.logo, 0.5,{y:85, ease:Quart.easeOut});
					TweenMax.to(app.background.logo, 0.5,{alpha:1, ease:Quart.easeIn});
					readyState();
					lyt.setKeyActions(app.recorder.getKeyActions());
					app.recorder.end();
				}
				else
				{
					recordState();
					app.recorder.start();
					TweenMax.to(app.background.logo, 0.5,{alpha:0, y:35, ease:Quart.easeOut});
				}
			});

			saveButton.addEventListener(MouseEvent.CLICK, function(event:Event):void
			{
				var file:FileReference = new FileReference();
				file.save(lyt.save(),"record.lyt");
			})

			settingsButton.addEventListener(MouseEvent.CLICK, function(event:Event):void
			{
				var state:String = currentState;
				settingsState();

				KeySetting.editing = true;
				app.keyboard.update();
				var cap:Function;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, cap=function(keyEvent:Event):void
				{
					keyEvent.stopImmediatePropagation();
				},false,10)
				stage.addEventListener(KeyboardEvent.KEY_UP, cap, false,10);


				var cancel:Function;
				var commit:Function;
				var reset:Function;
				function returnToLastState(event:Event):void
				{
					event.currentTarget.removeEventListener(event.type, cancel);
					event.currentTarget.removeEventListener(event.type, commit);
					event.currentTarget.removeEventListener(event.type, reset);
					stage.removeEventListener(KeyboardEvent.KEY_DOWN,cap);
					stage.removeEventListener(KeyboardEvent.KEY_UP,cap);
					if(state == INIT)
					{
						initState();
					}
					else
					{
						readyState();
					}
					KeySetting.editing = false;
					app.keyboard.update();
				}

				app.background.cancelButton.addEventListener(MouseEvent.CLICK, cancel = function(event:Event):void
				{
					returnToLastState(event);
				});
				app.background.commitButton.addEventListener(MouseEvent.CLICK, commit = function(event:Event):void
				{
					app.keyboard.apply();
					returnToLastState(event);
				});
				app.background.resetButton.addEventListener(MouseEvent.CLICK, reset = function(event:Event):void
				{
					app.keyboard.update();
				});
			});

			var glowFilter:GlowFilter = new GlowFilter(0xcccccc,1);
			app.background.keySwitch.addEventListener(MouseEvent.ROLL_OVER,
				function(event:Event):void
				{
					app.background.keySwitch.filters = [glowFilter];
				});
			app.background.keySwitch.addEventListener(MouseEvent.ROLL_OVER,
				function(event:Event):void
				{
					app.background.keySwitch.filters = [];
				});
			app.background.keySwitch.addEventListener(MouseEvent.CLICK,
				function(event:Event):void
				{
					KeySetting.getInstance().key ++
					if(KeySetting.getInstance().key > 7)
					{
						KeySetting.getInstance().key = -4;
					}
					app.background.keySwitch.label.text =
						keyValueToName(KeySetting.getInstance().key);
				});
		}

		private function playState():void
		{
			currentState = PLAY
			enableButton(playButton);
			diableButton(openButton);
			diableButton(recordButton);
			diableButton(settingsButton);
		}

		private function recordState():void
		{
			currentState = RECORD;
			diableButton(playButton);
			diableButton(openButton);
			enableButton(recordButton);
			diableButton(settingsButton);
		}


		private function settingsState():void
		{
			currentState = SETTINGS;
			diableButton(playButton);
			diableButton(openButton);
			diableButton(recordButton);
			diableButton(settingsButton);
			app.background.resetButton.visible = true;
			app.background.commitButton.visible = true;
			app.background.cancelButton.visible = true;
		}

		private function readyState():void
		{
			currentState = READY;
			enableButton(openButton);
			enableButton(recordButton);
			enableButton(settingsButton);
			enableButton(playButton);
			enableButton(settingsButton);

			playBack.stop();
			TweenMax.to(app, 0.5, {y:0, ease:Quart.easeOut})
		}

		private function initState():void
		{
			currentState = INIT;
			diableButton(playButton);
			diableButton(saveButton);
			enableButton(openButton);
			enableButton(recordButton);
			enableButton(settingsButton);
			app.background.resetButton.visible = false;
			app.background.commitButton.visible = false;
			app.background.cancelButton.visible = false;
		}

		private function diableButton(button:SimpleButton):void
		{
			button.enabled = false;
			button.alpha = 0.5;
		}

		private function enableButton(button:SimpleButton):void
		{
			button.enabled = true;
			button.alpha = 1;
		}

		public function parseRecord():void
		{
			record.position = 0;
			lyt.parse(record);
			app.keyboard.update();

			app.background.keySwitch.label.text = keyValueToName(KeySetting.getInstance().key)
		}

		public function playRecord(isSlow:Boolean):void
		{
			playBack.playActionList(app.keyManager, lyt.getKeyActions(), readyState, isSlow?1:0);
		}

		private var valueNameMapping:Array = ["bA","A","bB","B","C","bD","D","bE","E","F","#F","G"]
		private function keyValueToName(value:int):String
		{
			return valueNameMapping[value + 4];
		}

		private function keyNameToValue(name:String):int
		{
			return valueNameMapping[name] - 4;
		}
	}
}
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.MouseEvent;

function asMenu(source:SimpleButton):SimpleButton
{
	source.addEventListener(MouseEvent.ROLL_OUT, function(event:Event):void
	{
		source.hitTestState = source.upState;
	});
	source.addEventListener(MouseEvent.ROLL_OVER, function(event:Event):void
	{
		source.hitTestState = source.overState;
	});
	source.addEventListener(MouseEvent.CLICK, function(event:Event):void
	{
		source.hitTestState = source.upState;
	});
	return source;
}

/* click about
aboutButton.addEventListener(MouseEvent.CLICK, function(event:Event):void
{
var clickHandler:Function;
var keyDownHandler:Function;
var deactiveHandler:Function;

var sequence:Array = [];
var eileenMode:Boolean = false;
var aboutInfo:AboutInfo;

function quitAbout(event:Event=null):void
{
stage.removeEventListener(MouseEvent.CLICK, quitAbout,true);
stage.removeEventListener(KeyboardEvent.KEY_DOWN, quitAbout,true);
stage.removeEventListener(KeyboardEvent.KEY_DOWN, waitingFor,true);
stage.removeEventListener(Event.DEACTIVATE, quitAbout,true);

playBack.stop();
if(record != null)
{
parseRecord();
readyState();
}
else
{
initState();
}

if(!eileenMode)
{
resetLogo();
}
}

function waitingFor(event:KeyboardEvent):void
{
sequence.push(String.fromCharCode(event.charCode).toLowerCase());
if(sequence.join("") == "eileen")
{
TweenMax.to(aboutInfo, 0.5, {alpha:0, ease:Quart.easeOut});
playMariageDeAmour();
aboutButton.visible = false;
}
}

function playMariageDeAmour():void
{
AboutSong.data.position = 0;
lyt.parse(AboutSong.data);
app.keyboard.update();

playBack.playActionList(app.keyManager, lyt.getKeyActions(), quitAbout);
TweenMax.to(app.background.logo, 0.75, {glowFilter:{inner:true, color:0xFFFFFF, alpha:1, blurX:80, blurY:80, strength:5, quality:3}
,onComplete:function():void{
var rose:Rose = new Rose;
rose.x = 200;
rose.y = 45;
app.background.addChild(rose);
rose.filters = [new GlowFilter(0xFFFFFF, 1, 80,80,5,3,true)];
TweenMax.to(rose, 0.75, {glowFilter:{inner:true, color:0xFFFFFF, alpha:1, blurX:0, blurY:0, strength:5, quality:3}});
}});

stage.removeEventListener(KeyboardEvent.KEY_DOWN, waitingFor,true);
stage.addEventListener(KeyboardEvent.KEY_DOWN, quitAbout,true);
}


function resetLogo():void
{
TweenMax.to(app.background.logo, 0.5, {y:85, ease:Quart.easeOut});
TweenMax.to(aboutInfo, 0.5, {alpha:0, ease:Quart.easeOut,
onComplete:function():void
{
stage.removeChild(aboutInfo);
}});
}

stage.addEventListener(MouseEvent.CLICK, quitAbout,true);
stage.addEventListener(KeyboardEvent.KEY_DOWN, waitingFor,true);
stage.addEventListener(Event.DEACTIVATE, quitAbout,true);


TweenMax.to(app.background.logo, 0.5, {y:55, ease:Quart.easeOut});
aboutInfo = new AboutInfo;
stage.addChild(aboutInfo);
aboutInfo.x = 247;
aboutInfo.y = 180;
aboutInfo.filters = [new BevelFilter(2,225), new DropShadowFilter]
TweenMax.to(aboutInfo, 0.5, {alpha:1, ease:Quart.easeOut})

});
*/