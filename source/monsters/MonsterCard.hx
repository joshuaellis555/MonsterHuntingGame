package monsters;

import card.Card;
import character.Character;
import flixel.util.FlxColor;
import monsters.MonsterCharacter;
import player.Player;
import utilities.button.Button;
import utilities.selection.Selection;
import character.damage.DamageTypes;

/**
 * ...
 * @author Joshua Ellis
 */
class MonsterCard extends Card 
{
	public var monster:MonsterCharacter;
	
	public function new(owner:MonsterCharacter, possibleTargetsFunct:Character->Bool->Array<Character>) 
	{
		super(owner,[possibleTargetsFunct]);
		monster = owner;
	}
}