package;

import flixel.FlxG;
import flixel.FlxState;

// it checks if there are mods or not
// if there are mods, switch to game selector
class InitialState extends FlxState
{
	override function create()
	{
		PolyHandler.reload();

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

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}