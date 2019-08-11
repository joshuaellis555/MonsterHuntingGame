package team;
import character.Character;
import utilities.plusInterface.PlusInterface;
import library.Library;

/**
 * ...
 * @author ...
 */
class Team 
{
	public var members:Array<Character> = [];
	public var ID:Int;
	
	public function new() 
	{
		Library.teams.add(this);
	}
	public function add(character:Character) 
	{
		members.push(character);
	}
	public function remove(character:Character) 
	{
		members.remove(character);
	}
}