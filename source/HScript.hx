package;

import crowplexus.iris.Iris;
import openfl.utils.Assets;

class HScript extends Iris
{
	public function new(file:String)
	{
		trace("Load File: " + file);
		super(Assets.getText(file));
		config.autoRun = config.autoPreset = true;
		config.name = file;

		set("importClass", function(nameClass:String, paths:String = "")
		{
			var str:String = '';
			if (paths.length > 0)
				str = paths + '.';
			set(nameClass, Type.resolveClass(str + paths));
		});
	}

	public function executeFunction(name:String, args:Array<Dynamic>)
	{
		if (name == null || !exists(name))
			return null;
		return call(name, args);
	}
}
