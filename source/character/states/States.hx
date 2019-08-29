package character.states;

/**
 * ...
 * @author Joshua Ellis
 */
class States 
{
	public var distanced:Bool = false; //can only be hit with ranged attacks, melee attacks by flying characters, and charge attacks
	public var flying:Bool = false; //can only be hit by ranged attacks or melee attacks by flying characters. Can attack distanced and flying characters with melee attacks
	public var combos:Bool = false; //builds up combo which is used by some cards
	
	public function new() {}
	
}