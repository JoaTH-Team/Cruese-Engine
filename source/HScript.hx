package;

import crowplexus.hscript.Interp.LocalVar;
import crowplexus.iris.Iris;
import crowplexus.iris.IrisConfig.RawIrisConfig;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxRuntimeShader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import sys.io.File;

class HScript extends Iris
{
	var locals(get, set):Map<String, LocalVar>;

	function get_locals():Map<String, crowplexus.hscript.LocalVar>
	{
		var result:Map<String, crowplexus.hscript.LocalVar> = new Map();
		@:privateAccess
		for (key in interp.locals.keys())
		{
			result.set(key, {r: interp.locals.get(key).r, const: interp.locals.get(key).const});
		}
		return result;
	}

	function set_locals(local:Map<String, crowplexus.hscript.LocalVar>)
	{
		@:privateAccess
		interp.locals = local;
		return local;
	}

	public function getAll():Dynamic 
	{
		var balls:Dynamic = {};

		for (i in locals.keys())
			Reflect.setField(balls, i, get(i));
		for (i in interp.variables.keys())
			Reflect.setField(balls, i, get(i));

		return balls;
	}

	public function new(file:String)
	{
		final rawConfig:RawIrisConfig = {
			name: file,
			autoPreset: true,
			autoRun: true
		}
		super(File.getContent(file), rawConfig);

		// Some Preset Class
		set('FlxAxes', GameHandler.getFlxAxes());
		set('FlxBackdrop', FlxBackdrop);
		set('FlxBasic', FlxBasic);
		set('FlxCamera', FlxCamera);
		set('FlxCameraFollowStyle', GameHandler.getFlxCameraFollowStyle());
		set('FlxEase', FlxEase);
		set('FlxG', FlxG);
		set('FlxGroup', FlxGroup);
		set('FlxMath', FlxMath);
		set('FlxObject', FlxObject);
		set('FlxRuntimeShader', FlxRuntimeShader);
		set('FlxSound', FlxSound);
		set('FlxSprite', FlxSprite);
		set('FlxSpriteGroup', FlxSpriteGroup);
		set('FlxText', FlxText);
		set('FlxTextAlign', GameHandler.getFlxTextAlign());
		set('FlxTextBorderStyle', GameHandler.getFlxTextBorderStyle());
		set('FlxTimer', FlxTimer);
		set('FlxTween', FlxTween);
		set('FlxTypedGroup', FlxTypedGroup);
		set('createTypedGroup', function(?variable)
		{
			return variable = new FlxTypedGroup<Dynamic>();
		});
		set('createSpriteGroup', function(?variable)
		{
			return variable = new FlxSpriteGroup();
		});
		set("FlxColor", GameHandler.colorWorkaround());
		set("FlxKey", KeyWorkaround);

		set("importScript", function(source:String)
		{
			var name:String = StringTools.replace(source, ".", "/");
			var filePath:String = null;
			for (mod in PolyHandler.getModIDs())
				filePath = "mods/" + mod + "/data/" + name + ".hxs";
			var script:HScript = new HScript(filePath);
			script.execute();
			return script.getAll();
		});
		set("stopScript", function() {
			this.destroy();
		});
		set("trace", function(value:Dynamic) {
			trace(value);
		});
		set("config", GameHandler);
		set("Action", ActionState);
		set("Paths", Paths);
		set("ScriptedClass", ScriptedClass);
		set("ScriptedSubClass", ScriptedSubClass);
		// Same but replace `Class` with `State`
		set("ScriptedState", ScriptedClass);
		set("ScriptedSubState", ScriptedSubClass);
		set("PlayState", PlayState);
		// Some state stuff
		set("game", PlayState.instance);
		set("state", FlxG.state);
		set("add", FlxG.state.add);
		set("remove", FlxG.state.remove);
		set("insert", FlxG.state.insert);
		set("members", FlxG.state.members);

		execute();
	}

	// stop from warming missing function
	// just found that i was using != instead of ==
	public function callFunction(funcName:String, funcArgs:Array<Dynamic>)
	{
		if (funcName == null || !exists(funcName))
			return null;
		return call(funcName, funcArgs);
	}
}