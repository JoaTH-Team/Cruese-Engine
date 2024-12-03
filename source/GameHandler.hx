package;

import flixel.FlxG;

// just a bunch of function can be used
class GameHandler
{
	public static function exitGame(?exitActually:Bool = false)
	{
		if (exitActually)
			Sys.exit(0);
		else
			FlxG.switchState(new GameSelectionState());
	}
}