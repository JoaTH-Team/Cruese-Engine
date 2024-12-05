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

		var foldersToCheck:Array<String> = ['data/'];
		for (mod in PolyHandler.getModIDs())
			foldersToCheck.push('mods/' + mod + '/data/');
		for (folder in foldersToCheck)
		{
			if (FileSystem.exists(folder) && FileSystem.isDirectory(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if (file.endsWith('.hxs'))
					{
						scriptArray.push(new HScript(folder + file));
					}
				}
			}
		}

		callOnScripts("onCreate", []);

		super.create();

		callOnScripts("onCreatePost", []);
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
