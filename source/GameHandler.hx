package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.keyboard.FlxKey;
import flixel.text.FlxText;
import flixel.util.FlxAxes;
import flixel.util.FlxColor;
import haxe.Http;
import haxe.Json;

// just a bunch of function can be used
class GameHandler
{
	// public static var version:String = Lib.application.meta.get("version");
	public static var versionAPI:String = "2.0.0";

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

	public static function getFlxCameraFollowStyle()
	{
		return {
			"LOCKON": FlxCameraFollowStyle.LOCKON,
			"PLATFORMER": FlxCameraFollowStyle.PLATFORMER,
			"TOPDOWN": FlxCameraFollowStyle.TOPDOWN,
			"TOPDOWN_TIGHT": FlxCameraFollowStyle.TOPDOWN_TIGHT,
			"SCREEN_BY_SCREEN": FlxCameraFollowStyle.SCREEN_BY_SCREEN,
			"NO_DEAD_ZONE": FlxCameraFollowStyle.NO_DEAD_ZONE
		};
	}

	public static function getFlxTextAlign()
	{
		return {
			"LEFT": FlxTextAlign.LEFT,
			"CENTER": FlxTextAlign.CENTER,
			"RIGHT": FlxTextAlign.RIGHT,
			"JUSTIFY": FlxTextAlign.JUSTIFY
		};
	}

	public static function getFlxTextBorderStyle()
	{
		return {
			"NONE": FlxTextBorderStyle.NONE,
			"SHADOW": FlxTextBorderStyle.SHADOW,
			"OUTLINE": FlxTextBorderStyle.OUTLINE,
			"OUTLINE_FAST": FlxTextBorderStyle.OUTLINE_FAST
		};
	}

	public static function getFlxAxes()
	{
		return {
			"X": FlxAxes.X,
			"Y": FlxAxes.Y,
			"XY": FlxAxes.XY
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