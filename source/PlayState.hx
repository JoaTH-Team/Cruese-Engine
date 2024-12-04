package;

import flixel.FlxState;
import haxe.io.Path;
import sys.FileSystem;

using StringTools;

class PlayState extends FlxState
{
	var scriptArray:Array<HScript> = [];

	public static var trackerFolder:Int = 0;

	override public function create()
	{
		loadScript();
		callOnScripts("onCreate", []);
		super.create();
		callOnScripts("onCreatePost", []);
	}

	function loadScript()
	{
		var gameFolder:String = PolyHandler.getModIDs()[trackerFolder];
		trace(gameFolder);
		var folderToCorrect:String = 'mods/$gameFolder/data/';
		var readFolder = FileSystem.readDirectory(folderToCorrect);
		for (file in readFolder)
		{
			if (file.endsWith(".hxs"))
			{
				var scriptPath = Path.join([folderToCorrect, file]);
				scriptArray.push(new HScript(scriptPath));
			}
		}
	}

	function callOnScripts(funcName:String, funcArgs:Array<Dynamic>)
	{
		for (i in scriptArray)
		{
			i.executeFunction(funcName, funcArgs);
		}
	}

	override public function update(elapsed:Float)
	{
		callOnScripts("onUpdate", [elapsed]);
		super.update(elapsed);
		callOnScripts("onUpdatePost", [elapsed]);
	}
}
