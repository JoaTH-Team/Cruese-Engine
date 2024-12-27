## Thing to say
Please note that `Lua` on Cruese Engine is still not fully done yet!, lot of function and various thing to adjust is still here, if you wanna code without have missing anything (or something), please go to the [Script Code](https://github.com/JoaTH-Team/Cruese-Engine/wiki/Coding-Game) instead!
## Function/Variable can be used
### Function
* onCreate: Init a newly fresh `PlayState`
* onCreatePost: Go after `onCreate`
* onUpdate: Will update the game every second
* onUpdatePost: Update after `onUpdate`
* onDestroy: Clear some memory?
### Code Function
#### Main Function
* setVar(name, value)
> This one will set a global variable, all lua script can access
* getVar(name)
> This one will get a global variable, all lua script can access
* deleteVar(name)
> This one will delete a global
* callFunction(name, args)
> This one will call a global function, like how `onCreate`, `onUpdate` work, all lua script can access
#### Text Function
* createText(tag, x, y, width, text, size)
> This one will create a text and push a variable onto lua script, all lua script can access thought using `getTextProperty`, `setTextProperty` or other...
* removeText(tag)
> This one will remove a text and also delete a variable from lua script
* reviveText(tag)
> This one will revive a text after using `removeText`, after that, this one will push a variable onto lua script, all lua script can access thought using `getTextProperty`, `setTextProperty` or other...
* destroyText(tag)
> This one will clear up some memory
* setTextColor(tag, color)
> This one will change/set a new color for text, you don't need to add `0xFF` since engine already add this
* setTextActive(tag, bool)
> This one will set active for the text
* setTextVisible(tag, bool)
> This one will set visible for the text
* setTextPosition(tag, x, y)
> This one will set a position by `x` and `y`
* setTextSize(tag, size)
> This one will set how big or small by size number
* setTextString(tag, text)
> This one will set a text content for the text
* setTextFont(tag, font)
> This one will set a new font for the text, if you didn't add the font extension, the default of font extension will be added by `.ttf`
* setTextAlignment(tag, alignment)
> This one will set a alignment for the text
* setTextProperty(tag, property, value)
> This one will set a property by a value from the text
* getTextProperty(tag, property)
> This one will get a property from a text

#### Sprite Function
* createSprite(tag, x, y, image)
> This one will create a sprite
* removeSprite(tag)
> This one will remove a sprite
* reviveSprite(tag)
> This one will revive a sprite
* destroySprite(tag)
> This one will destroy a sprite

## Example
```lua
function onCreate()
    createText('test1', 0, 0, 0, "Hello World", 32)
end
```