package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class SplashesState extends FlxState
{
	var textTween:FlxTween;
	var logoTween:FlxTween;
	var text:FlxSprite;
	var logo:FlxSprite;
	var allowToPress:Bool = false;

	override function create()
	{
		super.create();

		text = new FlxSprite(31, 400.56, "assets/images/engineCredits.png");
		text.alpha = 0;
		add(text);

		logo = new FlxSprite(0, 0, "assets/images/logo.png");
		logo.screenCenter();
		logo.alpha = 0;
		add(logo);
		new FlxTimer().start(1, function(timer:FlxTimer)
		{
			allowToPress = true;
			FlxTween.tween(text, {alpha: 1});
			FlxTween.tween(logo, {alpha: 1});
			add(new FlxText(10, 10, 0, "Press Enter to continue!", 16));
		});
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		if (allowToPress)
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				FlxG.camera.flash(FlxColor.WHITE, 0.5, function()
				{
					FlxG.camera.fade(FlxColor.BLACK, 0.5, function()
					{
						FlxG.switchState(new GameSelectionState());
					});
				});
			}
		}
	}
}