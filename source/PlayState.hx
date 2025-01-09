package;

import flixel.FlxState;
import openfl.Lib;
import sys.FileSystem;

using StringTools;

class PlayState extends FlxState
{
	public var scriptArray:Array<HScript> = [];
	public var luaArray:Array<LuaScript> = [];

	public static var trackerFolder:Int = 0;
	public static var instance:PlayState = null;

	override public function create()
	{
		instance = this;

		var foldersToCheck:Array<String> = [];
		foldersToCheck.push('mods/' + PolyHandler.trackedMods[trackerFolder].id + '/data/');
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
					if (file.endsWith('.lua'))
					{
						luaArray.push(new LuaScript(folder + file));
					}
				}
			}
		}

		for (script in scriptArray) {
			script?.set('addScript', function(path:String) {
				scriptArray.push(new HScript(foldersToCheck[0] + '$path.hxs'));
			});
		}

		for (script in luaArray)
		{
			script?.setFunction('addScript', function(path:String)
			{
				luaArray.push(new LuaScript(foldersToCheck[0] + '$path.lua'));
			});
		}

		callOnScripts("onCreate", []); // how could i forgot this????

		super.create();

		callOnScripts("onCreatePost", []);
	}

	function callOnScripts(funcName:String, funcArgs:Array<Dynamic>)
	{
		for (i in 0...scriptArray.length)
		{
			final script:HScript = scriptArray[i];
			script.call(funcName, funcArgs);
		}
		for (i in 0...luaArray.length)
		{
			final script:LuaScript = luaArray[i];
			script.callFunction(funcName, funcArgs);
		}
	}

	override public function update(elapsed:Float)
	{
		callOnScripts("onUpdate", [elapsed]);
		super.update(elapsed);
		callOnScripts("onUpdatePost", [elapsed]);
	}

	override public function destroy() {
		callOnScripts("onDestroy", []);
		super.destroy();

		for (script in scriptArray)
			script?.destroy();
		scriptArray = [];
	}
}
