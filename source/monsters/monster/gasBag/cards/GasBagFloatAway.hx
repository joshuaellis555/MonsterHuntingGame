package monsters.monster.gasBag.cards;

import utilities.button.Button;
import monsters.MonsterCard;
import card.CardFamily;
import character.Character;
import monsters.MonsterCharacter;
import utilities.event.Event;
import player.Player;
import character.resources.Resources;
import character.resources.ResourceTypes;
import character.damage.DamageTypes;
import utilities.animation.Animation;
import flixel.util.FlxColor;
import library.Library;

/**
 * ...
 * @author Joshua ellis
 */
class GasBagFloatAway extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner);
		name = "Float Away";
		family = CardFamily.Yellow;
		cardType.positiveEffect(true);
		cost = new Resources([]);
		chargeTime = 4.0;
		possibleTargetsFunct = Library.characters.self;
	}
	override public function resolve()
	{
		target.giveResources(new Resources([4, 4, 4]));
		target.distanced(true);
		
		super.resolve();
	}
}