package;

import flixel.FlxState;
import haxe.io.Path;
import sys.FileSystem;

using StringTools;

class PlayState extends FlxState
{
	public var scriptArray:Array<HScript> = [];

	public static var trackerFolder:Int = 0;
	public static var instance:PlayState = null;

	override public function create()
	{
		instance = this;
		
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

	override public function destroy() {
		callOnScripts("destroy", []);
		super.destroy();
		scriptArray = [];
	}
}
