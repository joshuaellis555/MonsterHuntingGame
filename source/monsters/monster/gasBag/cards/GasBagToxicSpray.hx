package monsters.monster.gasBag.cards;

import utilities.button.Button;
import monsters.MonsterCard;
import card.CardFamily;
import character.Character;
import monsters.MonsterCharacter;
import utilities.event.Event;
import player.Player;
import character.resources.Health;
import character.resources.Resources;
import character.resources.ResourceTypes;
import character.damage.DamageTypes;
import utilities.animation.Animation;
import flixel.util.FlxColor;
import character.statusEffects.StatusTypes;
import library.Library;

/**
 * ...
 * @author Joshua ellis
 */
class GasBagToxicSpray extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, [DamageTypes.poison,DamageTypes.water]);
		name = "Toxic Spray";
		family = CardFamily.BlueGreen;
		cardType.spell(true);
		cost = new Resources([0, 0, 4]);
		windupTime = 0.0;
		chargeTime = 2.0;
		//add(resolveAnimation = new Animation(AssetPaths.Protect_20__png, DamageTypes.dark, 192, 192, 25, 1));
		possibleTargetsFunct = Library.characters.allies
	}
	override public function resolve()
	{
		damage(target, 1, 5);
		target.effects.addVenom(5, 1);
		target.statusEff.addStatus(StatusTypes.wet, 10);
		target.damageNumbers.addNumber('Wet', StatusTypes.wet);
		
		super.resolve();
	}
}