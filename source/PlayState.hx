package;

import flixel.FlxState;

class PlayState extends FlxState
{
	var scriptArray:Array<HScript> = [];

	public static var trackerFolder:Int = 0;

	override public function create()
	{
		super.create();
		var gameFolder:String = PolyHandler.trackedMods[trackerFolder].modPath;
		trace(gameFolder);
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
}
