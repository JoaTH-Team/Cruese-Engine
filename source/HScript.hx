package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxSpriteGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import hscript.*;
import openfl.Lib;
import sys.io.File;

using StringTools;

class HScript extends flixel.FlxBasic
{
	public var locals(get, set):Map<String, {r:Dynamic}>;

	function get_locals():Map<String, {r:Dynamic}>
	{
		@:privateAccess
		return interp.locals;
	}

	function set_locals(local:Map<String, {r:Dynamic}>)
	{
		@:privateAccess
		return interp.locals = local;
	}

	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;

	public var parser:Parser = new Parser();
	public var interp:Interp = new Interp();

	public function new(file:String, ?execute:Bool = true)
	{
		trace("Load File: " + file);
		super();
		parser.allowJSON = parser.allowTypes = parser.allowMetadata = true;

		set('importClass', function(daClass:String, ?asDa:String)
		{
			final splitClassName:Array<String> = [for (e in daClass.split('.')) e.trim()];
			final className:String = splitClassName.join('.');
			final daClass:Class<Dynamic> = Type.resolveClass(className);
			final daEnum:Enum<Dynamic> = Type.resolveEnum(className);

			if (daClass == null && daEnum == null)
				Lib.application.window.alert('Class / Enum at $className does not exist.', 'Hscript Error!');
			else {
				if (daEnum != null) {
					var daEnumField = {};
					for (daConstructor in daEnum.getConstructors())
						Reflect.setField(daEnumField, daConstructor, daEnum.createByName(daConstructor));

					if (asDa != null && asDa != '')
						set(asDa, daEnumField);
					else
						set(splitClassName[splitClassName.length - 1], daEnumField);
				} else {
					if (asDa != null && asDa != '')
						set(asDa, daClass);
					else
						set(splitClassName[splitClassName.length - 1], daClass);
				}
			}
		});

		set("importScript", function(source:String) {
			var name:String = StringTools.replace(source, ".", "/");
			var filePath = "mods/" + PolyHandler.trackedMods[PlayState.trackerFolder].id + "/data/" + name + ".hxs";
			var script:HScript = new HScript(filePath, false);
			script.execute(filePath, false);
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
		// Flixel
		set("FlxG", FlxG);
		set("FlxSprite", FlxSprite);
		set("FlxCamera", FlxCamera);
		set("FlxText", FlxText);
		set("FlxTween", FlxTween);
		set("FlxEase", FlxEase);
		set("FlxColor", GameHandler.colorWorkaround());

		set("FlxTypedGroup", FlxTypedGroup);
		set("FlxSpriteGroup", FlxSpriteGroup);

		set("ScriptedClass", ScriptedClass);
		set("ScriptedSubClass", ScriptedSubClass);
		// Same but replace `Class` with `State`
		set("ScriptedState", ScriptedClass);
		set("ScriptedSubState", ScriptedSubClass);
		set("PlayState", PlayState);

		set("createTypedGroup", function(?variable) 
		{
			return variable = new FlxTypedGroup<Dynamic>();
		});

		set("createSpriteGroup", function(?variable) 
		{
			return variable = new FlxSpriteGroup();
		});

		set("game", PlayState.instance);
		set("state", FlxG.state);
		set("add", FlxG.state.add);
		set("remove", FlxG.state.remove);

		if (execute)
			this.execute(file);
	}

	public function execute(file:String, ?executeCreate:Bool = true):Void
	{
		try
		{
			interp.execute(parser.parseString(File.getContent(file)));
		}
		catch (e:Dynamic)
			Lib.application.window.alert(Std.string(e), 'HScript Error!');

		trace('Script Loaded Succesfully: $file');

		if (executeCreate)
			call('onCreate', []);
	}

	public function set(name:String, val:Dynamic):Void
	{
		interp?.variables.set(name, val);
		locals.set(name, {r: val});
	}

	public function get(name:String):Dynamic
	{
		if (locals.exists(name) && locals[name] != null)
			return locals.get(name).r;
		else if (interp.variables.exists(name))
			return interp?.variables.get(name);

		return null;
	}

	public function existsVar(name:String):Bool
		return interp?.variables.exists(name);

	public function call(name:String, args:Array<Dynamic>)
	{
		if (existsVar(name))
		{
			try
			{
				return Reflect.callMethod(this, get(name), args == null ? [] : args);
			}
			catch (e:Dynamic)
				Lib.application.window.alert(Std.string(e), 'HScript Error!');
		}

		return null;
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

	override function destroy() 
	{
		super.destroy();
		parser = null;
		interp = null;
	}
}
