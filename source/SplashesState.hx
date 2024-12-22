package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class SplashesState extends FlxState
{
	var textTween:FlxTween;
	var logoTween:FlxTween;
	var text:FlxSprite;
	var logo:FlxSprite;

	override function create()
	{
		super.create();

		text = new FlxSprite(31, 400.56, "assets/images/engineCredits.png");
		text.alpha = 0;
		add(text);
		FlxTween.cancelTweensOf(text);
		textTween = FlxTween.tween(text, {alpha: 1}, 1, {
			onComplete: function(tween:FlxTween)
			{
				FlxTween.cancelTweensOf(text);
				new FlxTimer().start(2, function(timer:FlxTimer)
				{
					FlxTween.tween(text, {alpha: 0}, 1);
				});
			}
		});

		logo = new FlxSprite(0, 0, "assets/images/logo.png");
		logo.screenCenter();
		logo.alpha = 0;
		add(logo);
		FlxTween.cancelTweensOf(logo);
		logoTween = FlxTween.tween(logo, {alpha: 1}, 1, {
			onComplete: function(tween:FlxTween)
			{
				FlxTween.cancelTweensOf(logo);
				new FlxTimer().start(2, function(timer:FlxTimer)
				{
					FlxTween.tween(logo, {alpha: 0}, 1, {
						onComplete: function(tween:FlxTween)
						{
							FlxG.switchState(new GameSelectionState());
						}
					});
				});
			}
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (FlxG.keys.pressed.ENTER)
		{
			if (textTween.active)
			{
				textTween.cancel();
				text.alpha = 1;
			}
			else if (logoTween.active)
			{
				logoTween.cancel();
				logo.alpha = 1;
				FlxG.switchState(new GameSelectionState());
			}
		};
	}
}