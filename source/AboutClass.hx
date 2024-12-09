package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import openfl.Lib;

class AboutClass extends FlxSubState
{
	var camGame:FlxCamera;

	override function create()
	{
		super.create();
		camGame = new FlxCamera();
		camGame.bgColor.alpha = 0;
		FlxG.cameras.add(camGame, false);

		var bg:FlxSprite = new FlxSprite(0, 51).makeGraphic(FlxG.width, 378, FlxColor.BLACK);
		bg.alpha = 0.5;
		bg.screenCenter();
		bg.cameras = [camGame];
		add(bg);

		var text:FlxText = new FlxText(0, 0, 0, 'Engine v' + Lib.application.meta.get("version") + "\nMods and API v" + GameHandler.versionA_M, 24);
		text.screenCenter();
		text.scrollFactor.set();
		text.cameras = [camGame];
		text.alpha = 0;
		add(text);

		FlxTween.cancelTweensOf(text);
		FlxTween.tween(text, {alpha: 1}, 0.5, {ease: FlxEase.backInOut});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			close();
	}
}