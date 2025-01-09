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
	var updateText:FlxText;

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

		var text:FlxText = new FlxText(0, 0, 0, 'Engine v' + Lib.application.meta.get("version") + "\nAPI For Mods v" + GameHandler.versionAPI, 24);
		text.screenCenter();
		text.scrollFactor.set();
		text.cameras = [camGame];
		text.alpha = 0;
		add(text);

		updateText = new FlxText(0, 0, 0, 'Update is on development, wait for update...', 16);
		updateText.screenCenter();
		if (InitialState.mustUpdate)
		{
			updateText.text = "Yo, new update is dropped!\nYou may want to update now!\nCurrent v"
				+ Lib.application.meta.get("version")
				+ "\nNew v"
				+ InitialState.daJson.version;
		}
		updateText.y += 50;
		updateText.scrollFactor.set();
		updateText.cameras = [camGame];
		updateText.alpha = 0;
		add(updateText);

		FlxTween.cancelTweensOf(text);
		FlxTween.tween(text, {alpha: 1}, 0.5, {ease: FlxEase.backInOut});
		FlxTween.cancelTweensOf(updateText);
		FlxTween.tween(updateText, {alpha: 1}, 0.5, {ease: FlxEase.backInOut});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.ESCAPE)
			close();
		if (FlxG.keys.justPressed.F1)
			InitialState.updateCheck();
	}
}