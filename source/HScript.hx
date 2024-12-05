package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import hscript.*;
import openfl.Lib;
import sys.io.File;

class HScript
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

	public function new(file:String)
	{
		trace("Load File: " + file);
		parser.allowJSON = parser.allowTypes = parser.allowMetadata = true;
		set("importClass", function(name:String, ?paths:String)
		{
			var str:String = '';
			if (paths.length > 0)
				str = paths + '.';
			set(name, Type.resolveClass(str + paths));
		});
		set("Handler", GameHandler);
		set("Paths", Paths);
		// Flixel
		set("FlxG", FlxG);
		set("FlxSprite", FlxSprite);
		set("FlxCamera", FlxCamera);
		set("FlxText", FlxText);

		set("game", PlayState.instance);
		set("state", FlxG.state);
		set("add", FlxG.state.add);
		set("remove", FlxG.state.remove);
		execute(file);
	}

	public function execute(file:String):Void
	{
		try
		{
			interp.execute(parser.parseString(File.getContent(file)));
		}
		catch (e:Dynamic)
			Lib.application.window.alert(Std.string(e), 'HScript Error!');

		trace('Script Loaded Succesfully: $file');
	}

	public function set(name:String, value:Dynamic)
		return interp.variables.set(name, value);

	public function get(name:String)
		return interp.variables.get(name);

	public function exists(name:String)
		return interp.variables.exists(name);

	public function call(name:String, args:Array<Dynamic>)
	{
		if (exists(name))
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
}