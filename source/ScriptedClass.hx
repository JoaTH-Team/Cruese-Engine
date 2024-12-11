package;

import flixel.addons.ui.FlxUIState;
import sys.FileSystem;

using StringTools;

// This one will like emulated again the FlxState
// On script, try using `Action.moveTo("data/classes/<file>.hxs", [<have any args if needed>]);`
class ScriptedClass extends FlxUIState
{
	var script:HScript = null;

	public static var instance:ScriptedClass;

	public static var trackerFolder:Int = 0;

	public function new(filePath:String, ?args:Array<Dynamic>)
	{
		super();
		instance = this;
		trackerFolder = PlayState.trackerFolder;
		try
		{
			var foldersToCheck:Array<String> = [];
			foldersToCheck.push('mods/' + PolyHandler.trackedMods[trackerFolder].id + '/data/classes/');
			for (folder in foldersToCheck)
			{
				if (FileSystem.exists(folder) && FileSystem.isDirectory(folder))
				{
					for (file in FileSystem.readDirectory(folder))
					{
						if (file.startsWith(filePath) && file.endsWith('.hxs'))
						{
							filePath = folder + file;
						}
					}
				}
			}
			script = new HScript(filePath, false);
			script.execute(filePath, false);
		}
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
		scriptExecute("onUpdatePost", [elapsed]);
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