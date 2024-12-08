package;

import flixel.FlxG;
import flixel.FlxGame;
import haxe.CallStack;
import openfl.Lib;
import openfl.display.*;
import openfl.events.UncaughtErrorEvent;

using StringTools;
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
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, (e:UncaughtErrorEvent) ->
		{
			e.preventDefault();
			e.stopPropagation();
			e.stopImmediatePropagation();

			var stack:Array<String> = [];
			stack.push(e.error);

			for (stackItem in CallStack.exceptionStack(true))
			{
				switch (stackItem)
				{
					case CFunction:
						stack.push('C Function');
					case Module(m):
						stack.push('Module ($m)');
					case FilePos(s, file, line, column):
						stack.push('$file (line $line)');
					case Method(classname, method):
						stack.push('$classname (method $method)');
					case LocalFunction(name):
						stack.push('Local Function ($name)');
				}
			}

			FlxG.bitmap.dumpCache();
			FlxG.bitmap.clearCache();

			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();

			final msg:String = stack.join('\n');

			#if sys
			try
			{
				if (!FileSystem.exists('./crash/'))
					FileSystem.createDirectory('./crash/');

				File.saveContent('./crash/'
					+ Lib.application.meta.get('log')
					+ '-'
					+ Date.now().toString().replace(' ', '-').replace(':', "'")
					+ '.txt',
					msg
					+ '\n');
			}
			catch (e:Dynamic)
			{
				Sys.println("Error!\nCouldn't save the crash dump because:\n" + e);
			}
			#end

			ActionState.gonnaDisplayThis = e.error;
			ActionState.gonnaDoWhat = "display error";
			FlxG.switchState(new ActionState());
		});
	}
}
