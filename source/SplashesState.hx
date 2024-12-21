package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class SplashesState extends FlxState
{
	override function create()
	{
		super.create();

		var text:FlxSprite = new FlxSprite(42.1, 387.6, "assets/images/engineCredits.png");
		text.alpha = 0;
		add(text);
		FlxTween.cancelTweensOf(text);
		FlxTween.tween(text, {alpha: 1}, 1, {
			onComplete: function(tween:FlxTween)
			{
				FlxTween.cancelTweensOf(text);
				new FlxTimer().start(2, function(timer:FlxTimer)
				{
					FlxTween.tween(text, {alpha: 0}, 1);
				});
			}
		});

		var logo:FlxSprite = new FlxSprite(0, 0, "assets/images/logo.png");
		logo.screenCenter();
		logo.alpha = 0;
		add(logo);
		FlxTween.cancelTweensOf(logo);
		FlxTween.tween(logo, {alpha: 1}, 1, {
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
	}
}