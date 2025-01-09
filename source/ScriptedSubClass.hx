package;

import flixel.FlxG;
import flixel.addons.ui.FlxUISubState;
import sys.FileSystem;

using StringTools;

class ScriptedSubClass extends FlxUISubState
{
	public var script:HScript = null;
	public var path:String = "";

	public static var instance:ScriptedSubClass = null;
	public static var trackerFolder:Int = 0;

	public function new(fileName:String, ?args:Array<Dynamic>)
	{
		if (fileName != null)
			path = fileName;
		
		instance = this;
		trackerFolder = PlayState.trackerFolder;
		try
		{
			var filePath = "mods/" + PolyHandler.trackedMods[trackerFolder].id + "/data/classes/" + path + ".hxs";

			if (FileSystem.exists(filePath))
				path = filePath;
			
			script = new HScript(path);
			script.execute();

			scriptExecute("new", args);
		}
		catch (e:Dynamic)
		{
			script = null;
			trace('Error getting script from $fileName!\n$e');
		}

		scriptExecute("new", args);

		super();
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