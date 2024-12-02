package;

/**
 * # Contains Handler
 * A system that handler about running a mods folder, called a contains
 * 
 * ## How it work?
 * Simply like Polymod, it will need your game have a `meta.json` file with contains:
 * ```
 * {
 * 	"title": "My Game",
 * 	"version": "1.0",
 *  "api_version": "1.0"
 * }
 * ```
 * While `version` is just for your game, `api_version` is important to be in the right version since if the `api_version` too new or too old, the game will surely cannot handler it!
 * 
 * ## What folder inside my mods?
 * For now, we just need the `data`, `images`, `music` and `sounds`
 * 
 * If recommended that `data` only contains script file, `images` contains sprite sheet or any images you want (you can also contains images for icon game)
 */
class ContainsHandler
{
	public var title:String = "my game";
	public var version:String = "1.0";
	public var api_version:String = Version.API_VERSION;
	
	public function new() {

	}
}
