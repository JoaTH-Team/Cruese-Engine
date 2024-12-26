package;

import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
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
		loadedTextFunction();
		loadedImagesFunction();
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
	function loadedMainFunction():Void
	{
		setFunction("setProperty", function(variable:String, value:Dynamic)
		{
			var parts = variable.split(".");
			if (parts.length < 2)
				return;

			var mapName = parts[0];
			var key = parts[1];
			var property = parts[2];

			switch (mapName)
			{
				case "gameText":
					var text = GameHandler.gameText.get(key);
					if (text != null)
						Reflect.setField(text, property, value);
				case "gameImages":
					var image = GameHandler.gameImages.get(key);
					if (image != null)
						Reflect.setField(image, property, value);
			}
		});
		setFunction("getProperty", function(variable:String)
		{
			var parts = variable.split(".");
			if (parts.length < 2)
				return null;

			var mapName = parts[0];
			var key = parts[1];
			var property = parts[2];

			switch (mapName)
			{
				case "gameText":
					var text = GameHandler.gameText.get(key);
					if (text != null)
						return Reflect.field(text, property);
				case "gameImages":
					var image = GameHandler.gameImages.get(key);
					if (image != null)
						return Reflect.field(image, property);
			}
			return null;
		});
	}

	function loadedTextFunction():Void
	{
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
		setFunction("setText", function(tag:String, text:String)
		{
			GameHandler.gameText.get(tag).text = text;
		});
		setFunction("setTextSize", function(tag:String, size:Int)
		{
			GameHandler.gameText.get(tag).size = size;
		});
		setFunction("setTextColor", function(tag:String, color:Int)
		{
			GameHandler.gameText.get(tag).color = FlxColor.fromString("0xFF" + color);
		});
		setFunction("setTextPosition", function(tag:String, x:Float, y:Float)
		{
			GameHandler.gameText.get(tag).setPosition(x, y);
		});
		setFunction("setTextWidth", function(tag:String, width:Int)
		{
			GameHandler.gameText.get(tag).width = width;
		});
		setFunction("setTextVisible", function(tag:String, visible:Bool)
		{
			GameHandler.gameText.get(tag).visible = visible;
		});
		setFunction("setTextActive", function(tag:String, active:Bool)
		{
			GameHandler.gameText.get(tag).active = active;
		});
		setFunction("removeText", function(tag:String)
		{
			GameHandler.gameText.get(tag).kill();
			GameHandler.gameText.remove(tag);
		});
		setFunction("destroyText", function(tag:String)
		{
			GameHandler.gameText.get(tag).destroy();
			GameHandler.gameText.remove(tag);
		});
		setFunction("destroyAllText", function()
		{
			for (text in GameHandler.gameText)
			{
				text.destroy();
			}
			GameHandler.gameText.clear();
		});
	}

	function loadedImagesFunction():Void
	{
		setFunction("createImage", function(tag:String, x:Float = 0, y:Float = 0, path:String = "")
		{
			var image = new FlxSprite(x, y, path);
			image.active = true;
			GameHandler.gameImages.set(tag, image);
			return image;
		});
		setFunction("addImage", function(tag:String)
		{
			FlxG.state.add(GameHandler.gameImages.get(tag));
		});
		setFunction("setImagePosition", function(tag:String, x:Float, y:Float)
		{
			GameHandler.gameImages.get(tag).setPosition(x, y);
		});
		setFunction("setImageVisible", function(tag:String, visible:Bool)
		{
			GameHandler.gameImages.get(tag).visible = visible;
		});
		setFunction("setImageActive", function(tag:String, active:Bool)
		{
			GameHandler.gameImages.get(tag).active = active;
		});
		setFunction("removeImage", function(tag:String)
		{
			GameHandler.gameImages.get(tag).kill();
			GameHandler.gameImages.remove(tag);
		});
		setFunction("destroyImage", function(tag:String)
		{
			GameHandler.gameImages.get(tag).destroy();
			GameHandler.gameImages.remove(tag);
		});
		setFunction("destroyAllImage", function()
		{
			for (image in GameHandler.gameImages)
			{
				image.destroy();
			}
			GameHandler.gameImages.clear();
		});
	}
}