package;

import flixel.FlxG;
import flixel.FlxState;
import haxe.Json;
import openfl.Lib;

// it checks if there are mods or not
// if there are mods, switch to game selector
class InitialState extends FlxState
{
	public static var mustUpdate:Bool = false;
	public static var daJson:Dynamic;

	override function create()
	{
		PolyHandler.reload();
		updateCheck();

		if (PolyHandler.trackedMods.length > 0)
		{
			FlxG.switchState(new GameSelectionState());
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