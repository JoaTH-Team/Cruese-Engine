package;

import flixel.FlxGame;
import openfl.display.*;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Main extends Sprite
{
	public static var fpsCounter:FPS;
	public function new()
	{
		super();

		if (!FileSystem.exists('./mods/'))
			FileSystem.createDirectory('./mods/');
		if (!FileSystem.exists('mods/mods-goes-here.txt'))
			File.saveContent('mods/mods-goes-here.txt', '');
		
		addChild(new FlxGame(0, 0, GameSelectionState, 60, 60, true, false));
		fpsCounter = new FPS(1, 1, 0xffffff);
		addChild(fpsCounter);
		PolyHandler.reload();
	}
}
