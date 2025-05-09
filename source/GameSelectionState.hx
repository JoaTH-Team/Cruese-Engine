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
import flixel.util.FlxTimer;
import haxe.Json;
import haxe.io.Bytes;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;

// thought, i wanna make this like a game console
class GameSelectionState extends FlxState
{
	var gameDisplayList:Array<String> = [];
	var camHUD:FlxCamera;

	var daMods:FlxTypedGroup<FlxText>;
	var description:FlxText;
	var curSelected:Int = 0;
	var camFollow:FlxObject;
	var desc:FlxText;
	var iconGame:Array<ModIcon> = [];
	var cardGame:FlxSprite;

	override function create()
	{
		super.create();

		GameHandler.resizeApp(640, 480);

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		add(grid);

		camFollow = new FlxObject(80, 0, 0, 0);
		camFollow.screenCenter(X);
		add(camFollow);

		daMods = new FlxTypedGroup<FlxText>();
		add(daMods);

		for (i in 0...PolyHandler.trackedMods.length)
		{
			var text:FlxText = new FlxText(20, 60 + (i * 60), PolyHandler.trackedMods[i].title, 20);
			text.setFormat(FlxAssets.FONT_DEFAULT, 24, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.ID = i;
			daMods.add(text);
			var icon:ModIcon = new ModIcon(PolyHandler.trackedMods[i].icon);
			icon.sprTracker = text;
			iconGame.push(icon);
			add(icon);
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

		desc = new FlxText(10, 429.25, 0, "", 18, false);
		desc.setFormat(FlxAssets.FONT_DEFAULT, 18, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		desc.cameras = [camHUD];
		add(desc);

		cardGame = new FlxSprite(0, 0, Paths.image("gameUI/cardGameMissing"));
		cardGame.screenCenter(XY);
		cardGame.cameras = [camHUD];
		cardGame.x += 125;
		add(cardGame);

		var versionDisplay:FlxText = new FlxText(1, 1, 0, "Press F1 to display ABOUT\nPress F2 to move to Credits", 16);
		versionDisplay.setFormat(FlxAssets.FONT_DEFAULT, 16, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		versionDisplay.cameras = [camHUD];
		add(versionDisplay);

		// trace(PolyHandler.getModIDs());

		changeSelection();
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
		if (keys.F5)
		{
			PolyHandler.reload();
			FlxG.resetState();
		}
		if (keys.UP || keys.DOWN)
		{
			changeSelection((keys.UP) ? -1 : 1);
		}
		if (keys.ENTER)
		{
			switchToGame();
		}
		if (keys.F1)
		{
			openSubState(new AboutClass(FlxColor.BLACK));
		}
		if (keys.F2)
		{
			FlxG.switchState(new CreditsState());
		}
	}

	function switchToGame()
	{
		PlayState.trackerFolder = curSelected;
		FlxG.switchState(new PlayState());
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
		for (i in 0...iconGame.length)
		{
			iconGame[i].alpha = 0.6;
		}
		iconGame[curSelected].alpha = 1;

		if (PolyHandler.trackedMods[curSelected].description != null) 
		{
			desc.text = PolyHandler.trackedMods[curSelected].description;
		}
		try
		{
			var data = BitmapData.fromFile(PolyHandler.trackedMods[curSelected].modPath + "/cardGame.png");
			// trace(data);
			if (data == null)
				cardGame.loadGraphic(Paths.image('gameUI/cardGameMissing'));
			else
				cardGame.loadGraphic(data);
		}
		catch (e:Dynamic)
		{
			FlxG.log.warn(e);
			cardGame.loadGraphic(Paths.image('gameUI/cardGameMissing'));
		}
	}
}

class ModIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public function new(bytes:Bytes)
	{
		super();

		if (bytes != null && bytes.length > 0)
		{
			try
			{
				loadGraphic(BitmapData.fromBytes(bytes));
			}
			catch (e:Dynamic)
			{
				FlxG.log.warn(e);
				loadGraphic(Paths.image('gameUI/iconMissing'));
			}
		}
		else
			loadGraphic(Paths.image('gameUI/iconMissing'));

		setGraphicSize(75, 75);
		scrollFactor.set();
		updateHitbox();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
		{
			setPosition(sprTracker.x + sprTracker.width + 5, sprTracker.y + -15);
			scrollFactor.set(sprTracker.scrollFactor.x, sprTracker.scrollFactor.y);
		}
	}
}