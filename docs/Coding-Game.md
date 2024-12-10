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
var group:FlxTypedGroup<FlxSprite> = [];

function onCreate()
{
    group = createTypedGroup();
    add(group);

    for (i in 0...5)
    {
        var spr:FlxSprite = new FlxSprite(20 + (i * 10), FlxG.width / 2);
        spr.makeGraphic(10, 10, FlxColor.fromRGB(FlxG.random.int(0, 255), FlxG.random.int(0, 255), FlxG.random.int(0, 255)));
        group.add(spr);
    }
}
```

## Some Function can be used
* `onCreate` and `onCreatePost` are using for load a newly game
* `onUpdate` and `onUpdatePost` are using for update the game every second
* `onDestroy` are using for when destroy
* `stopScript` destroys the current script
* `importClass` is like `import` in normal Haxe
* `importScript` allows access to a script's variables and functions
* `addScript` adds a new script and runs it
* `trace` is like `trace` in normal Haxe