package;

import cpp.RawPointer;
import flixel.FlxBasic;
import flixel.FlxG;
import flixel.text.FlxText;
import hxluajit.*;
import hxluajit.Types.Lua_State;

class LuaScript extends FlxBasic
{
	var vm:RawPointer<Lua_State>;

	public function new(file:String)
	{
		super();
		Sys.println(Lua.VERSION);
		Sys.println(LuaJIT.VERSION);

		vm = LuaL.newstate();
		LuaL.openlibs(vm);
		LuaL.dofile(vm, file);

		// register the function
		setFuction("setFuction", setFuction);
		setFuction("createText", function(tag:String, x:Float = 0, y:Float = 0, width:Int = 0, text:String)
		{
			var text:FlxText = new FlxText(x, y, width, text);
			text.active = true;
			GameHandler.gameText.set(tag, text);
		});
		setFuction("addText", function(tag:String, ?part:Int = 0)
		{
			FlxG.state.insert(part, GameHandler.gameText.get(tag));
		});

		Lua.close(vm);
		vm = null;
	}

	// it different than hscript
	public function setFuction(name:String, func:Dynamic)
	{
		Lua.register(vm, name, func);
	}

	public function setVariable(name:String, value:Dynamic)
	{
		Lua.setglobal(vm, name);
	}
}