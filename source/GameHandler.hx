package;

import flixel.FlxG;
import openfl.Lib;

// just a bunch of function can be used
class GameHandler
{
	// public static var version:String = Lib.application.meta.get("version");

	public static function exitGame(?exitActually:Bool = false)
	{
		if (exitActually)
			Sys.exit(0);
		else
			FlxG.switchState(new GameSelectionState());
	}
}