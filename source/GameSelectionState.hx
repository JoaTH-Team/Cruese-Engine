package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;

// thought, i wanna make this like a game console
class GameSelectionState extends FlxState
{
	var gameDisplayList:Array<String> = [];
	var camHUD:FlxCamera;

	var daMods:FlxTypedGroup<FlxText>;
	var description:FlxText;
	var curSelected:Int = 0;
	private var gridLines:FlxTypedGroup<FlxSprite>;
	var camFollow:FlxObject;

	override function create()
	{
		super.create();

		camFollow = new FlxObject(80, 0, 0, 0);
		camFollow.screenCenter(X);
		add(camFollow);

		gridLines = new FlxTypedGroup<FlxSprite>();
		for (i in 0...20)
		{
			var hLine = new FlxSprite(0, i * 40);
			hLine.makeGraphic(FlxG.width, 1, 0x33FFFFFF);
			hLine.scrollFactor.set(0, 0);
			gridLines.add(hLine);

			var vLine = new FlxSprite(i * 40, 0);
			vLine.makeGraphic(1, FlxG.height, 0x33FFFFFF);
			vLine.scrollFactor.set(0, 0);
			gridLines.add(vLine);
		}
		add(gridLines);

		daMods = new FlxTypedGroup<FlxText>();
		add(daMods);

		for (i in 0...PolyHandler.trackedMods.length)
		{
			var text:FlxText = new FlxText(20, 60 + (i * 60), PolyHandler.trackedMods[i].title, 32);
			text.setFormat(FlxAssets.FONT_DEFAULT, 60, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.ID = i;
			daMods.add(text);
		}

		// HUD
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);

		var topBar:FlxSprite = new FlxSprite(0, 0, Paths.image("gameUI/bar"));
		topBar.cameras = [camHUD];
		add(topBar);

		var bottomBar:FlxSprite = new FlxSprite(0, 429.25, Paths.image("gameUI/bar"));
		bottomBar.cameras = [camHUD];
		add(bottomBar);

		FlxG.camera.follow(camFollow, null, 0.15);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.keys.justPressed.F5)
		{
			PolyHandler.reload();
			FlxG.resetState();
		}
		handleKey();
	}

	function handleKey()
	{
		var keys = FlxG.keys.justPressed;
		if (keys.UP)
		{
			changeSelection(-1);
		}
		if (keys.DOWN)
		{
			changeSelection(1);
		}
		if (keys.ENTER)
		{
			PlayState.trackerFolder = curSelected;
			FlxG.switchState(new PlayState());
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected = FlxMath.wrap(curSelected + change, 0, PolyHandler.trackedMods.length - 1);

		daMods.forEach(function(txt:FlxText)
		{
			txt.alpha = (curSelected == txt.ID) ? 1 : 0.6;
			if (txt.ID == curSelected)
				camFollow.y = txt.y;
		});
	}
}