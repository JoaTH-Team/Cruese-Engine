package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Http;
import haxe.Json;
import openfl.Lib;

// just a bunch of function can be used
class GameHandler
{
	// public static var version:String = Lib.application.meta.get("version");
	public static var versionA_M:String = "2.0.0";

	// Bunch Variable for Lua
	public static var gameText:Map<String, FlxText> = new Map<String, FlxText>();
	public static var gameImages:Map<String, FlxSprite> = new Map<String, FlxSprite>();

	public static function exitGame(?exitActually:Bool = false)
	{
		if (exitActually)
			Sys.exit(0);
		else
			FlxG.switchState(new GameSelectionState());
	}
	// both like resizeGame and resizeWindow but this one can do both of them
	public static function resizeApp(w:Int, h:Int)
	{
		FlxG.resizeGame(w, h);
		FlxG.resizeWindow(w, h);
	}
	// based from FlxColor
	public static function colorWorkaround()
	{
		return {
			// colors
			"BLACK": FlxColor.BLACK,
			"BLUE": FlxColor.BLUE,
			"BROWN": FlxColor.BROWN,
			"CYAN": FlxColor.CYAN,
			"GRAY": FlxColor.GRAY,
			"GREEN": FlxColor.GREEN,
			"LIME": FlxColor.LIME,
			"MAGENTA": FlxColor.MAGENTA,
			"ORANGE": FlxColor.ORANGE,
			"PINK": FlxColor.PINK,
			"PURPLE": FlxColor.PURPLE,
			"RED": FlxColor.RED,
			"TRANSPARENT": FlxColor.TRANSPARENT,
			"WHITE": FlxColor.WHITE,
			"YELLOW": FlxColor.YELLOW,

			// functions
			"add": FlxColor.add,
			"fromCMYK": FlxColor.fromCMYK,
			"fromHSB": FlxColor.fromHSB,
			"fromHSL": FlxColor.fromHSL,
			"fromInt": FlxColor.fromInt,
			"fromRGB": FlxColor.fromRGB,
			"fromRGBFloat": FlxColor.fromRGBFloat,
			"fromString": FlxColor.fromString,
			"interpolate": FlxColor.interpolate,
			"to24Bit": function(color:Int)
			{
				return color & 0xffffff;
			}
		};
	}
	public static function getLinkOfFile(fileLink:String)
	{
		var data = new Http(fileLink);
		return data;
	}
	public static function getJsonOfFile(fileJson:String)
	{
		return Json.parse(fileJson);
	}
}