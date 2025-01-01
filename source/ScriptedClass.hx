package;

import flixel.FlxG;
import flixel.addons.ui.FlxUIState;
import sys.FileSystem;

using StringTools;

// This one will like emulated again the FlxState
class ScriptedClass extends FlxUIState
{
	public var script:HScript = null;
	public var path:String = "";

	public static var instance:ScriptedClass = null;
	public static var trackerFolder:Int = 0;

	public function new(fileName:String, ?args:Array<Dynamic>)
	{
		super();
		instance = this;
		trackerFolder = PlayState.trackerFolder;
		try
		{
			var filePath = "mods/" + PolyHandler.trackedMods[trackerFolder].id + "/data/classes/" + fileName + ".hxs";

			if (FileSystem.exists(filePath))
				path = filePath;
			
			script = new HScript(path, false);
			script.execute(path, false);
		}
		catch (e:Dynamic)
		{
			script = null;
			trace('Error getting script from $fileName!\n$e');
		}

		scriptExecute("new", args);
	}

	override function create()
	{
		scriptExecute("onCreate", []);
		super.create();
		scriptExecute("onCreatePost", []);
	}

	override function update(elapsed:Float)
	{
		scriptExecute("onUpdate", [elapsed]);
		super.update(elapsed);

		if (FlxG.keys.justPressed.F4) // emergency exit
		{
			FlxG.switchState(new GameSelectionState());
		}

		scriptExecute("onUpdatePost", [elapsed]);
	}

	override function destroy()
	{
		scriptExecute("onDestroy", []);
		super.destroy();
	}

	function scriptExecute(func:String, args:Array<Dynamic>)
	{
		try
		{
			script?.call(func, args);
		}
		catch (e:Dynamic)
		{
			trace('Error executing $func!\n$e');
		}
	}
}