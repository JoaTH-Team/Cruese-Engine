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
		setFunction("setVar", function(name:String, value:Dynamic)
		{
			Convert.toLua(lua, value);
			Lua.setglobal(lua, name);
		});
		setFunction("getVar", function(name:String)
		{
			return Lua.getglobal(lua, name);
		});
		setFunction("deleteVar", function(name:String)
		{
			Lua.pushnil(lua);
			Lua.setglobal(lua, name);
		});
		setFunction("callFunction", function(name:String, args:Array<Dynamic>)
		{
			Lua.getglobal(lua, name);
			for (arg in args)
			{
				Convert.toLua(lua, arg);
			}
			Lua.pcall(lua, args.length, 0, 0);
		});
	}

	function loadedTextFunction():Void
	{
		setFunction("createText", function(tag:String, x:Float = 0, y:Float = 0, width:Int = 0, text:String = "", size:Int = 8)
		{
			var text = new FlxText(x, y, width, text, size);
			text.active = true;
			GameHandler.gameText.set(tag, text);
			return FlxG.state.add(text);
		});
		setFunction("removeText", function(tag:String, splice:Bool = false)
		{
			var text:FlxText = getTagObject("gameText", tag);
			text.kill();
			return FlxG.state.remove(text, splice);
		});
		setFunction("reviveText", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.revive();
		});
		setFunction("destroyText", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.destroy();
		});
		setFunction("setTextColor", function(tag:String, color:String = "")
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.color = FlxColor.fromString("0xFF" + color.toUpperCase());
		});
		setFunction("setTextActive", function(tag:String, active:Bool)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.active = active;
		});
		setFunction("setTextVisible", function(tag:String, visible:Bool)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.visible = visible;
		});
		setFunction("setTextPosition", function(tag:String, x:Float, y:Float)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.setPosition(x, y);
		});
		setFunction("setTextSize", function(tag:String, size:Int)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.size = size;
		});
		setFunction("setTextString", function(tag:String, content:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.text = content;
		});
		setFunction("setTextFont", function(tag:String, font:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.font = Paths.font(font);
		});
		setFunction("setTextAlignment", function(tag:String, alignment:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.alignment = alignment;
		});
		setFunction("getTextString", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.text;
		});
		setFunction("getTextWidth", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.width;
		});
		setFunction("getTextHeight", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.height;
		});
		setFunction("getTextActive", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.active;
		});
		setFunction("getTextVisible", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.visible;
		});
		setFunction("getTextPosition", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return [text.x, text.y];
		});
		setFunction("getTextSize", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.size;
		});
		setFunction("getTextColor", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.color;
		});
		setFunction("getTextAlignment", function(tag:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return text.alignment;
		});
		setFunction("setTextProperty", function(tag:String, property:String, value:Dynamic)
		{
			var text:FlxText = getTagObject("gameText", tag);
			Reflect.setProperty(text, property, value);
			return value;
		});
		setFunction("getTextProperty", function(tag:String, property:String)
		{
			var text:FlxText = getTagObject("gameText", tag);
			return Reflect.getProperty(text, property);
		});
	}

	function loadedImagesFunction():Void
	{
		setFunction("createSprite", function(tag:String, x:Float = 0, y:Float = 0, image:String = "")
		{
			var sprite = new FlxSprite(x, y, Paths.image(image));
			sprite.active = true;
			GameHandler.gameImages.set(tag, sprite);
			return FlxG.state.add(sprite);
		});
		setFunction("removeSprite", function(tag:String, splice:Bool = false)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			sprite.kill();
			return FlxG.state.remove(sprite, splice);
		});
		setFunction("reviveSprite", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.revive();
		});
		setFunction("destroySprite", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.destroy();
		});
		setFunction("setSpriteActive", function(tag:String, active:Bool)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.active = active;
		});
		setFunction("setSpriteVisible", function(tag:String, visible:Bool)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.visible = visible;
		});
		setFunction("setSpritePosition", function(tag:String, x:Float, y:Float)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.setPosition(x, y);
		});
		setFunction("setSpriteImage", function(tag:String, image:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.loadGraphic(Paths.image(image));
		});
		setFunction("setSpriteAlpha", function(tag:String, alpha:Float)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.alpha = alpha;
		});
		setFunction("setSpriteColor", function(tag:String, color:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.color = FlxColor.fromString("0xFF" + color.toUpperCase());
		});
		setFunction("getSpritePosition", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return [sprite.x, sprite.y];
		});
		setFunction("getSpriteScale", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.scale;
		});
		setFunction("getSpriteAlpha", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.alpha;
		});
		setFunction("getSpriteColor", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.color;
		});
		setFunction("getSpriteFrame", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.frame;
		});
		setFunction("getSpriteActive", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.active;
		});
		setFunction("getSpriteVisible", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.visible;
		});
		setFunction("makeAnim", function(tag:String, name:String, frames:Array<Int>, frameRate:Int, loop:Bool)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.animation.add(name, frames, frameRate, loop);
		});
		setFunction("makeAnimByPrefix", function(tag:String, name:String, prefix:String, frameRate:Int, loop:Bool)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.animation.addByPrefix(name, prefix, frameRate, loop);
		});
		setFunction("playAnim", function(tag:String, name:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.animation.play(name);
		});
		setFunction("stopAnim", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.animation.stop();
		});
		setFunction("getAnimName", function(tag:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return sprite.animation.name;
		});
		setFunction("setAnimProperty", function(tag:String, property:String, value:Dynamic)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			Reflect.setProperty(sprite.animation, property, value);
			return value;
		});
		setFunction("getAnimProperty", function(tag:String, property:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return Reflect.getProperty(sprite.animation, property);
		});
		setFunction("setSpriteProperty", function(tag:String, property:String, value:Dynamic)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			Reflect.setProperty(sprite, property, value);
			return value;
		});
		setFunction("getSpriteProperty", function(tag:String, property:String)
		{
			var sprite:FlxSprite = getTagObject("gameImages", tag);
			return Reflect.getProperty(sprite, property);
		});
	}

	function getTagObject(tagVer:String = "gameText", name:String)
	{
		var obj:Dynamic = null;
		switch (tagVer)
		{
			case "gameText":
				obj = GameHandler.gameText.get(name);
			case "gameImages":
				obj = GameHandler.gameImages.get(name);
		}
		return obj;
	}
}