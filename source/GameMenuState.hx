package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;

// in progress
// this class will replace the `GameSelectionState` in future
class GameMenuState extends FlxState
{
	override function create()
	{
		super.create();

		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF444444);
		bg.updateHitbox();
		bg.scrollFactor.set();
		add(bg);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}