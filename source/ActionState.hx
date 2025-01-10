package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.text.FlxText;

using StringTools;

// This class will likely add some common action thing to do like missing folder, crash handler and stuff
class ActionState extends FlxState
{
	public static var gonnaDoWhat:String = "";
	public static var gonnaDisplayThis:String = "";

	override function create()
	{
		super.create();

		trace("Action will do: " + gonnaDoWhat);

		var text:FlxText = new FlxText(3, 3, 0, "Error: " + gonnaDoWhat.toUpperCase(), 24);
		text.font = "_sans";
		add(text);
		
		switch (gonnaDoWhat)
		{
			case "missing folder":
				var eror:FlxText = new FlxText(text.x, text.y + 50, 0,
					"Hey, you will need to\nadd aleast 1 mods inside the `mods` folder!\nAdd one and press `F5` to reload game", 20);
				eror.font = text.font;
				add(eror);
			case "display crash":
				trace(Std.string(gonnaDisplayThis) + "\nPress `F5` to reload game");
				var eror:FlxText = new FlxText(text.x, text.y, 0, Std.string(gonnaDisplayThis) + "\nPress `F5` to reload game", 20);
				eror.font = text.font;
				add(eror);
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
					// FlxG.switchState(new InitialState());
					FlxG.resetGame();
				}
		}
	}
}