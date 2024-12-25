package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.text.FlxText;
import llua.Convert;
import llua.Lua.Lua_helper;
import llua.Lua;
import llua.LuaL;
import llua.State;

class LuaScript extends FlxBasic
{
	public static var lua:State;

	public function new(file:String)
	{
		super();
		lua = LuaL.newstate();
		LuaL.openlibs(lua);
		Lua.init_callbacks(lua);
		var result:Dynamic = LuaL.dofile(lua, file);
		var resultStr:String = Lua.tostring(lua, result);
		if (resultStr != null && result != 0)
		{
			lime.app.Application.current.window.alert(resultStr, 'Lua Error');
			trace('Lua Error ' + resultStr);
			lua = null;
			return;
		}

		setVar("VERSION", openfl.Lib.application.meta.get("version"));
		setVar("VERSION_A_M", GameHandler.versionA_M);

		setFunction("exitGame", function(exitActually:Bool = false) GameHandler.exitGame(exitActually));
		setFunction("resizeApp", function(w:Int, h:Int) GameHandler.resizeApp(w, h));
		setFunction("createText", function(tag:String, x:Float = 0, y:Float = 0, width:Int = 0, text:String = "", size:Int = 8)
		{
			var text = new FlxText(x, y, width, text, size);
			text.active = true;
			GameHandler.gameText.set(tag, text);
			return text;
		});
		setFunction("addText", function(tag:String)
		{
			FlxG.state.add(GameHandler.gameText.get(tag));
		});
	}

	public function callFunction(name:String, args:Array<Dynamic>)
	{
		Lua.getglobal(lua, name);
		for (arg in args)
		{
			Convert.toLua(lua, arg);
		}
		Lua.pcall(lua, args.length, 0, 0);
	}

	public function setFunction(name:String, func:Dynamic)
		Lua_helper.add_callback(lua, name, func);

	public function setVar(name:String, value:Dynamic)
	{
		Convert.toLua(lua, value);
		Lua.setglobal(lua, name);
	}

	public function getVar(name:String)
	{
		return Lua.getglobal(lua, name);
	}

	public function deleteVar(name:String)
	{
		Lua.pushnil(lua);
		Lua.setglobal(lua, name);
	}
}