package character.effects;
import character.Character;
import flixel.util.FlxColor;
import card.CardType;
import character.damage.DamageTypes;

/**
 * ...
 * @author ...
 */
class Defender 
{
	public var returnFunction:Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float;
	public var source:Character;
	public var time:Float;
	
	public function new(returnFunction:Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float, source:Character, time:Float) 
	{
		this.returnFunction = returnFunction;
		this.source = source;
		this.time = time;
	}
}