package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

// This class will likely add some common action thing to do like missing folder, crash handler and stuff
class ActionState extends FlxState
{
	public static var gonnaDoWhat:String = "";
	public static var gonnaDisplayThis:String = "";

	override function create()
	{
		super.create();

		trace("Action will do: " + gonnaDoWhat);

		switch (gonnaDoWhat)
		{
			case "missing folder":
				var text:FlxText = new FlxText(0, 0, 0, "Hey, you will need to add aleast 1 mods inside the `mods` folder!\nAdd one and press `F5`", 24);
				text.screenCenter();
				add(text);
			case "display crash":
				var text:FlxText = new FlxText(0, 0, 0, Std.string(gonnaDisplayThis) + "\nPress F5 to reload game", 24);
				text.screenCenter();
				add(text);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		switch (gonnaDoWhat)
		{
			case "missing folder" | "display crash":
				if (FlxG.keys.justPressed.F5)
				{
					FlxG.switchState(new GameSelectionState());
				}
		}
	}
}