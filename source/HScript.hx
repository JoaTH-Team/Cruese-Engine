package;

import crowplexus.iris.Iris;
import flixel.FlxG;

class HScript extends Iris
{
	public var disposed:Bool;

	public function new(file:String)
	{
		disposed = false;

		trace("Load File: " + file);

		final getText:String->String = #if sys sys.io.File.getContent #elseif openfl openfl.utils.Assets.getText #end;
		super(getText(file), {name: "hscript-iris", autoRun: false, autoPreset: true});

		set("importClass", function(nameClass:String, paths:String = "")
		{
			var str:String = '';
			if (paths.length > 0)
				str = paths + '.';
			set(nameClass, Type.resolveClass(str + paths));
		});

		set("stopScript", function() 
		{
			this.destroy();
		});

		set("game", PlayState.instance);
		set("state", FlxG.state);

		set("add", FlxG.state.add);
		set("remove", FlxG.state.remove);
	}

	public function executeFunc(func:String, ?args:Array<Dynamic>):IrisCall
	{
		return call(func, args ?? []);
	}

	override function destroy():Void {
		super.destroy();
		disposed = true;
	}
}