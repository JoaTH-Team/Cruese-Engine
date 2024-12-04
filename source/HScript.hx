package;

import crowplexus.iris.Iris;
import openfl.utils.Assets;
import flixel.FlxG;

class HScript extends Iris
{
	public function new(file:String)
	{
		trace("Load File: " + file);

		final getText:String->String = #if sys sys.io.File.getContent #elseif openfl openfl.utils.Assets.getText #end;

		super(getText(file));
		config.autoRun = config.autoPreset = true;
		config.name = file;

		set("importClass", function(nameClass:String, paths:String = "")
		{
			var str:String = '';
			if (paths.length > 0)
				str = paths + '.';
			set(nameClass, Type.resolveClass(str + paths));
		});

		set("game", PlayState.instance);
		set("state", FlxG.state);

		set("add", FlxG.state.add);
		set("remove", FlxG.state.remove);
	}

	public function executeFunction(name:String, args:Array<Dynamic>)
	{
		if (name == null || !exists(name))
			return null;
		return call(name, args);
	}
}
