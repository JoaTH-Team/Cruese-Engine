package;

import flixel.FlxG;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.Lib;

class AboutClass extends FlxSubState
{
	override function create()
	{
		super.create();

		var text:FlxText = new FlxText(0, 0, 0, 'Engine v' + Lib.application.meta.get("version") + "\nMods and API v" + GameHandler.versionA_M, 24);
		text.screenCenter();
		text.scrollFactor.set();
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