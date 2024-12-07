# Coding For Game (YO THIS PAGE STILL WORKING MAN!)
This page will show you about coding stuff in this engine
## How to add thing?
Create a `data` folder in the `mods/<your game>/data` and this is where the game could read stuff!, create a file with extension name `.hxs` and this is where you can code for now!

## Example
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
var text;

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
    var imgaes = new FlxSprite(0, 0, Paths.image("imagesName"));
    images.screenCenter();
    add(images); 
} 
``` 
## Some Function can be used
* `onCreate` and `onCreatePost` are using for load a newly game
* `onUpdate` and `onUpdatePost` are using for update the game every second
* `onDestroy` are using for when destroy