# Coding For Game
This page will show you about coding stuff in this engine
## How to add thing?
Create a `data` folder in the `mods/<your game>/data` and this is where the game could read stuff!, create a file with extension name `.hxs` and this is where you can code for now!

## Examples
### Create Text
```haxe
function onCreate()
{
    var text = new FlxText(0, 0, 0, "Hello World", 32);
    text.screenCenter();
    add(text);
}
```
### Updated Text
```haxe
var text:FlxText;

function onCreate()
{
    text = new FlxText(0, 0, 0, "You not press SPACE", 32);
    text.screenCenter();
    add(text);
}

function onUpdate(elapsed:Float)
{
    if (FlxG.keys.pressed.SPACE)
        text.text = "You press SPACE";
    else
        text.text = "You not press SPACE";
}
```
### Load Images
```haxe
function onCreate()
{
    var images = new FlxSprite(0, 0, Paths.image("imagesName"));
    images.screenCenter();
    add(images); 
} 
``` 

### Making a Group
```haxe
var group:Dynamic;

function onCreate()
{
    group = createTypedGroup(group);
    add(group);

    for (i in 0...5)
    {
        var spr:FlxSprite = new FlxSprite(20 + (i * 10), FlxG.width / 2);
        spr.makeGraphic(10, 10, FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255)));
        group.add(spr);
    }
}
```
### Switch State (Only v1.3 and above work)
```haxe
// file on data/main.hxs and are loaded by PlayState
function onCreate() {
    var text:FlxText = new FlxText(0, 0, 0, "Press ENTER to Switch to State 01", 32);
    text.screenCenter(0x00);
    add(text);
}

function onUpdate(elapsed:Float) {
    if (FlxG.keys.justPressed.ENTER) {
        FlxG.switchState(new ScriptedState("main2"));
    }
}

// file on data/classes/main2.hxs
function onCreate() {
    var text:FlxText = new FlxText(0, 0, 0, "Press ENTER to Switch to State 00", 32);
    text.screenCenter(0x00);
    add(text);
}

function onUpdate(elapsed:Float) {
    if (FlxG.keys.justPressed.ENTER) {
        FlxG.switchState(new PlayState());
    }
}
```

## Some Function can be used
* `onCreate` and `onCreatePost` are using for load a newly game
* `onUpdate` and `onUpdatePost` are using for update the game every second
* `onDestroy` are using for when destroy
* `stopScript` destroys the current script
* `importClass` is like `import` in normal Haxe
    * Example: `importClass('package.Class');`
    * On v2.0: This `importClass` function will be removed, you can actual using `import`!:
        * Exmaple: `import flixel.FlxSprite;`
* `importScript` allows access to a script's variables and functions
    * Example: `var otherScript = importScript('path.to.script');`
    * Also, don't worry about `.`, it will be autocorrected to `/`
* `addScript` adds a new script and runs it
    * Example: `addScript('path/to/script');`
* `trace` is like `trace` in normal Haxe

### Config (GameHandler) Functions
* `exitGame(Bool)` - If `Bool` false, returns to game selection. Otherwise, actually exits the game.
* `reziseApp(w, h)` - Resizes the game window. `w` and `h` should both be **integers**!