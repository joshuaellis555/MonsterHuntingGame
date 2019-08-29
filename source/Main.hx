package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
#if js
		untyped {
			document.oncontextmenu = document.body.oncontextmenu = function() {return false;}
		}
#end
		//addChild (new openfl.display.FPS ());
		addChild(new FlxGame(0, 0, PlayState,1,30,30,true,true));
	}
}