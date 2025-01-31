package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.util.FlxTimer;
import haxe.Json;
import openfl.Assets;
import openfl.Lib;
import tjson.TJSON;

typedef InitialData =
{
	playSplashesScreen:Bool,
	loadgameInstant:String,
	willLoadgameInstant:Bool
} 

class InitialState extends FlxState
{
	public static var mustUpdate:Bool = false;
	public static var daJson:Dynamic;
	public static var gameConfig:InitialData;

	override function create()
	{
		gameConfig = TJSON.parse(Assets.getText("gameConfig.json"));

		PolyHandler.reload();
		updateCheck();

		if (PolyHandler.trackedMods.length > 0)
		{
			if (gameConfig.willLoadgameInstant)
			{
				new FlxTimer().start(1, function(timer:FlxTimer)
				{
					FlxG.switchState(new PlayState());
				});
			}
			else if (!gameConfig.willLoadgameInstant)
			{
				if (!gameConfig.playSplashesScreen)
					FlxG.switchState(new GameSelectionState());
				else if (gameConfig.playSplashesScreen)
					FlxG.switchState(new SplashesState());
			}
		}
		else
		{
			ActionState.gonnaDoWhat = "missing folder";
			FlxG.switchState(new ActionState());
		}
		super.create();
	}
	public static function updateCheck()
	{
		var data = GameHandler.getLinkOfFile("https://raw.githubusercontent.com/JoaTH-Team/Cruese-Engine/refs/heads/main/engineVer.json");
		data.onData = (data:String) ->
		{
			var daRawJson:Dynamic = Json.parse(data);
			if (daRawJson.version != Lib.application.meta.get('version'))
			{
				trace('oh noo outdated!!, go update now!!!!');
				daJson = daRawJson;
				mustUpdate = true;
			}
			else
				mustUpdate = false;
		}
		data.onError = (error) -> trace('error: $error');
		data.request();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}