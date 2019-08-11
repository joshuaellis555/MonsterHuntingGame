package player;

import character.Character;

/**
 * ...
 * @author Joshua ellis
 */
class God extends Player 
{
	private var characters:Array<Character> = [];
	public static var god:Bool = true;
	
	public function new() 
	{
		super(null, null);
		makeInvisible();
	}
	override public function setCharacter(character:Character)
	{
		this.characters.push(character);
	}
	public function getCharacters():Array<Character>
	{
		return characters;
	}
	override public function makeVisible(){}
}