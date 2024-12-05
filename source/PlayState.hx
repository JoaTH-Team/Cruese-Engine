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
		
		var gameFolder:String = PolyHandler.getModIDs()[trackerFolder];
		trace(gameFolder);
		var folderToCorrect:String = 'mods/$gameFolder/data/';
		var readFolder:Array<String> = FileSystem.readDirectory(folderToCorrect);
		if (FileSystem.exists(readFolder[0]) && FileSystem.isDirectory(readFolder[0]))
		{
			for (file in readFolder)
			{
				if (file.endsWith(".hxs"))
				{
					loadScript(file);
				}
			}
		}

		callOnScripts("onCreate", []);

		super.create();

		callOnScripts("onCreatePost", []);
	}

	function loadScript(dir:String):HScript
	{
		var script:HScript = new HScript(dir);
		scriptArray.push(script);
		script.execute();
		return script;
	}

	function callOnScripts(funcName:String, funcArgs:Array<Dynamic>)
	{
		for (i in 0...scriptArray.length)
		{
			final script:HScript = scriptArray[i];

			/* if (script.disposed) {
				if (scriptArray.exists(script)) scriptArray.remove(script);
				continue;
			}*/

			script.executeFunc(funcName, funcArgs);
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
		while (scriptArray.length > 0) scriptArray.pop().destroy();
	}
}
