package library;
import character.Character;
import flixel.FlxG;
import flixel.FlxState;
import library.Library;


/**
 * ...
 * @author JoshuaEllis
 */
class Characters
{
	private static var members:Array<Character> = [];
	private static var cID:Int = 1000;

	public function new(){}
	
	public function add(character:Character)
	{
		trace(cID);
		character.ID = cID;
		cID++;
		members.push(character);
		FlxG.state.add(character);
	}
	
	
	public function self(self:Character, ?placeholder:Bool=true):Array<Character>
	{
		//trace(self)
		return [self];
	}
	public function all(self:Character, ?alive:Bool=true):Array<Character>
	{
		if (alive)
			return [for (char in members) if (char.alive) char];
		else
			return members;
	}
	public function allies(self:Character, ?alive:Bool=true):Array<Character>
	{
		if (self.getTeam() == null) return [];
		else{
			if (alive)
				return [for (char in self.getTeam().members) if (char.alive) char];
			else
				return self.getTeam().members;
		}
	}
	public function alliesExcludingSelf(self:Character, ?alive:Bool=true):Array<Character>
	{
		if (self.getTeam() == null) return [];
		if (alive)
			return [for (char in self.getTeam().members) if (char!=self && char.alive) char];
		else
			return [for (char in self.getTeam().members) if (char!=self) char];
	}
	public function others(self:Character, ?alive:Bool=true):Array<Character>
	{
		if (alive)
			return [for (char in members) if (char!=self && char.alive) char];
		else
			return [for (char in members) if (char!=self) char];
	}
	public function enemies(self:Character, ?alive:Bool=true):Array<Character>
	{
		if (alive)
			return [for (team in Library.teams.all()) for (char in team.members) if ((team != self.getTeam() || self.getTeam() == null) && char.alive) char];
		else
			return [for (team in Library.teams.all()) for (char in team.members) if (team != self.getTeam() || self.getTeam() == null) char];
	}
	
	public function deadAllies(self:Character, ?placeholder:Bool=true):Array<Character>
	{
		if (self.getTeam() == null) return [];
		trace('deadAllies', [for (char in self.getTeam().members) char.alive]);
		return [for (char in self.getTeam().members) if (!char.alive) char];
	}
	public function deadOthers(self:Character, ?placeholder:Bool=true):Array<Character>
	{
		return [for (char in members) if (char!=self && !char.alive) char];
	}
	public function deadEnemies(self:Character, ?placeholder:Bool=true):Array<Character>
	{
		return [for (team in Library.teams.all()) for (char in team.members) if ((team != self.getTeam() || self.getTeam() == null) && !char.alive) char];
	}
	
	public function remove(character:Character)
	{
		members.remove(character);
		if (character.getTeam()!=null) character.getTeam().remove(character);
	}
}