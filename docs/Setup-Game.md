# Setup Game
For beginner work your game, go to the `mods` folder and follow the steps down here:
## Create a folder
- For making game, go to the `mods` folder and create your folder first, or copy and paste the mod template! 
- after that, go to your folder was create and create a file named `meta.json`, in there you should open your `meta.json` file and paste this code:
```json
{
	"title": "Template",
	"description": "Game Description.",
	"author": "You!",
	"api_version": "2.0.0",
	"mod_version": "1.0.0",
	"license": "Apache 2.0"
}
```
After that, save your `meta.json` file and the engine should found your game for now!

Note that this file is required!

### Put icon (optional)
If you wanna add a icon, make one and save this image as name `icon.png` and put in your mods game like `mods/<your game>/icon.png`

Also the image icon should recommended at `150x150` though the game will auto resize them to only `75x75`

### Put card to display (optional)
You can add in a custom box-art card if you want.

It should be in `mods/<your game>/cardGame.png`.

## Result (TADA)
That all you wanna make your folder work now, you should able to added stuff into game and make them run for sure!