package library;
import character.Character;
import flixel.FlxG;
import flixel.FlxState;
import team.Team;


/**
 * ...
 * @author JoshuaEllis
 */
class Teams
{
	public static var members:Array<Team> = [];
	private static var tID:Int = 100;

	public function new(){}
	public function add(team:Team)
	{
		trace(tID);
		team.ID = tID;
		tID++;
		members.push(team);
	}

	public function all():Array<Team>
	{
		return members;
	}
}