package monsters.monster.gasBag.cards;

import utilities.button.Button;
import monsters.MonsterCard;
import card.CardFamily;
import character.Character;
import monsters.MonsterCharacter;
import library.ElementalResistances;
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
class GasBagPoisonCloud extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, [DamageTypes.poison]);
		name = "Poison Cloud";
		family = CardFamily.Green;
		cardType.ranged(true);
		cost = new Resources([0, 4, 0]);
		windupTime = 2.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.castSpell_35__png, Library.damageColors.get(DamageTypes.poison), 192, 192, 35, 1,2));
		chargeTime = 2.0;
		possibleTargetsFunct = Library.characters.enemies;
	}
	override public function resolve()
	{
		target.effects.addVenom(4+Std.random(5),2);
		
		super.resolve();
	}
}