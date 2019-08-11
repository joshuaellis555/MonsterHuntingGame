package library;
import flixel.FlxG;
import flixel.FlxState;
import player.Player;


/**
 * ...
 * @author JoshuaEllis
 */
class Players
{
	public static var members:Array<Player> = [];
	private static var pID:Int = 0;

	public function new(){}

	public function add(player:Player)
	{
		trace(pID);
		player.ID = pID;
		pID++;
		members.push(player);
		FlxG.state.add(player);
	}

	public function all():Array<Player>
	{
		return members;
	}
}