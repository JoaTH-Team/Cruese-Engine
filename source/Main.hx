package;

import flixel.FlxGame;
import openfl.display.*;

class Main extends Sprite
{
	public static var fpsCounter:FPS;
	public function new()
	{
		super();
		addChild(new FlxGame(0, 0, PlayState, 60, 60, true, false));
		fpsCounter = new FPS(1, 1, 0xffffff);
		addChild(fpsCounter);
	}
}
