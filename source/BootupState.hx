package;

import lime.utils.Bytes;
import openfl.display.Shader;
import openfl.filters.ShaderFilter;
import flixel.FlxSubState;
import openfl.filters.BitmapFilter;
import openfl.display.BitmapData;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.display.FlxExtendedSprite;
import flixel.addons.plugin.FlxMouseControl;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import io.newgrounds.NG;
import flixel.util.FlxSpriteUtil;
import lime.app.Application;
import openfl.Assets;
import flash.geom.Point;
import lime.app.Application;
import Sys;
import sys.FileSystem;

#if windows
import Discord.DiscordClient;
#end

#if cpp
import sys.thread.Thread;
#end

using StringTools;

class BootupState extends MusicBeatState
{
	public static var loadedStuff:Bool = false;

	override public function create():Void
	{
		#if sys
		if (!sys.FileSystem.exists("assets/replays"))
			sys.FileSystem.createDirectory("assets/replays");
		#end

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}
		
		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add (function (exitCode) {
			DiscordClient.shutdown();
		});
		 
		#end
		super.create();

		FlxG.save.bind('funkin', 'bobandbosip');

		KadeEngineData.initSave();

		Highscore.load();

		FlxG.mouse.visible = false;

		FlxG.sound.playMusic(Paths.music('menuIntro'));
		FlxG.sound.music.stop();
		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			var data:Array<String> = initSonglist[i].split(':');
			var songHighscore = StringTools.replace(data[0], " ", "-");
				switch (songHighscore) {
					case 'Dad-Battle': songHighscore = 'Dadbattle';
					case 'Philly-Nice': songHighscore = 'Philly';
			}
			if (!loadedStuff) {
				FlxG.sound.cache(Paths.inst(songHighscore));
				if (FileSystem.exists(Paths.instEXcheck(songHighscore))) {
					FlxG.sound.cache(Paths.instEX(songHighscore));
				}
			}
		}
		
		loadedStuff = true;

		LoadingState.loadAndSwitchState(new VideoState2("assets/videos/desktop.webm", new PlayState());
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
