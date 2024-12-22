# List TODO for Cruese Engine
## v1.3.1 (Little Fixed) - DONE
- [X] Make Splashes can be skipping by press Enter
- [X] Fix `engineCredits` From `Mad by JoaTH Team` to `Made by JoaTH Team`

## v1.3 (HScript update) - DONE
- [X] Add HScript can code as classes (just find a workaround for this one)
- [X] Add a splashes whenever enter a game
- [X] Fix can't load the file when switched to `ScriptedClass` and `ScriptedSubClass` (just don't put them on when load game right on the `PlayState`)
- [X] Make can be directly load into a selection mods by using the json (scrapped)
- [X] Fix Paths (i just notice that we would need manual patht the file so i fix this by using `PolyHandler`)

## v1.2 (Another small update but affect to gameplay) - DONE
- [X] Make a switch state when there have no mods folder inside them (like will move to `ActionState` when have no folder contains `meta.json` in the `mods` folder)
- [X] Display more thing on `About` state
- [X] Add credits state on this engine (thought idk is should be?, but we will made mods can also add credits on them too)
- [X] Edit more thing on `GameSelectionState` (still same)
- [X] Fix card display overlap the About State
- [X] Edit more thing on `ActionState`
- [X] Try to make using like `new FlxTypedGroup<Class Name>();` can be run

## v1.1 (Small Updated) - DONE
- [X] Add a card display game onto `GameSelectionState` (it likely display cartridge)
- [X] Add a crash handler
- [X] Add a `About` class

## v1.0 (First/Inital Release) - DONE
- [X] Create a simple hscript system
- [X] Create and init the polymod
- [X] Create a selected mods (like selected game)
- [X] Create a simple save data (will never work this one, using `FlxG.save.data` instead man)
- [X] Rewrite `Project.xml` for better look (still same)
- [X] Fix the Polymod cannot loaded the mods
- [X] Fix the engine cannot load any file from `data` folder for every mods
- [X] Fix the `HScript` not working after loading file
- [X] Config more thing like imported, added more function and variable on `HScript`
- [X] Finished the menu of `GameSelectionState`
- [X] Fix icon cannot loaded for each selected game on `GameSelectionState`
- [X] Fix the game cant even load (just found that can't using `version:String` directly onto `Lib` class)

## Would do?
