package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import sys.FileSystem;
import sys.io.File;

using StringTools;

class CreditsState extends FlxState
{
	var creditsList:Array<Array<String>> = [
		["Cruese Engine Team"],
		[
			"Huy1234TH",
			"Main of this project, coder and stuff",
			"https://www.youtube.com/@Huy1234TH"
		],
		[
			"Joalor64GH",
			"Additional Coder, also help fixing bug and init polymod",
			"https://github.com/Joalor64GH"
		]
	];
	var grpCredits:FlxTypedGroup<FlxText>;
	var camHUD:FlxCamera;
	var curSelected:Int = 0;
	var camFollow:FlxObject;
	var desc:FlxText;

	override function create()
	{
		super.create();
		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		add(grid);

		camFollow = new FlxObject(80, 0, 0, 0);
		camFollow.screenCenter(X);
		add(camFollow);

		for (mod in PolyHandler.getMods())
			pushCredits(mod);

		grpCredits = new FlxTypedGroup<FlxText>();
		add(grpCredits);

		for (i in 0...creditsList.length)
		{
			var text:FlxText = new FlxText(20, 60 + (i * 60), creditsList[i][0], 20);
			text.setFormat(FlxAssets.FONT_DEFAULT, 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.ID = i;
			grpCredits.add(text);
		}

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		FlxG.cameras.add(camHUD, false);

		var topBar:FlxSprite = new FlxSprite(0, 0, Paths.image("gameUI/bar"));
		topBar.cameras = [camHUD];
		add(topBar);

		var bottomBar:FlxSprite = new FlxSprite(0, 429.25, Paths.image("gameUI/bar"));
		bottomBar.cameras = [camHUD];
		add(bottomBar);

		desc = new FlxText(10, 429.25, 0, "", 18, false);
		desc.setFormat(FlxAssets.FONT_DEFAULT, 18, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		desc.cameras = [camHUD];
		add(desc);

		changeSelection(1);
		FlxG.camera.follow(camFollow, null, 0.15);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		handleKey();
	}

	function handleKey()
	{
		var keys = FlxG.keys.justPressed;
		if (keys.UP || keys.DOWN)
		{
			changeSelection((keys.UP) ? -1 : 1);
		}
		if (keys.ENTER)
		{
			if (creditsList[curSelected][2] != null)
				FlxG.openURL(creditsList[curSelected][2]);
			else if (creditsList[curSelected][2] == "nolink")
				trace("has no link");
			else
				trace("not found the url link");
		}
		if (keys.ESCAPE)
		{
			FlxG.switchState(new GameSelectionState());
		}
	}

	function changeSelection(change:Int = 0)
	{
		do
		{
			curSelected = FlxMath.wrap(curSelected + change, 0, creditsList.length - 1);
		}
		while (unselectedable(curSelected));

		grpCredits.forEach(function(txt:FlxText)
		{
			txt.alpha = (curSelected == txt.ID) ? 1 : 0.6;
			if (txt.ID == curSelected)
				camFollow.y = txt.y;
		});

		desc.text = creditsList[curSelected][1];
	}

	function unselectedable(num:Int):Bool
	{
		return creditsList[num].length <= 1;
	}
	function pushCredits(folder:String)
	{
		var file:String = Paths.file(folder + "/data/credits.txt", "mods");
		trace(file);
		if (FileSystem.exists(file))
		{
			var firstarray:Array<String> = File.getContent(file).split('\n');
			for (i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if (arr.length >= 5)
					arr.push(folder);
				creditsList.push(arr);
			}
			creditsList.push(['']);
		}
	}
}