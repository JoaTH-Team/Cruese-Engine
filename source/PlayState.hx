package;

import flixel.FlxState;
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

		for (script in scriptArray) {
			script?.set('addScript', function(path:String) {
				scriptArray.push(new HScript('$path.hxs'));
			});
		}

		super.create();

		callOnScripts("createPost", []);
	}

	function callOnScripts(funcName:String, funcArgs:Array<Dynamic>)
	{
		for (i in 0...scriptArray.length)
		{
			final script:HScript = scriptArray[i];
			script.call(funcName, funcArgs);
		}
	}

	override public function update(elapsed:Float)
	{
		callOnScripts("update", [elapsed]);
		super.update(elapsed);
		callOnScripts("updatePost", [elapsed]);
	}

	override public function destroy() {
		callOnScripts("destroy", []);
		super.destroy();

		for (script in scriptArray)
			script?.destroy();
		scriptArray = [];
	}
}
