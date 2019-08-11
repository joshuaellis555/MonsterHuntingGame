package monsters.monster.spectre.cards;

import utilities.button.Button;
import monsters.MonsterCard;
import card.CardFamily;
import character.Character;
import monsters.MonsterCharacter;
import library.ElementalResistances;
import utilities.event.Event;
import player.Player;
import character.resources.Health;
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
class SpectreMagicBolt extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, [DamageTypes.magic]);
		name = "Magic Bolt";
		family = CardFamily.Blue;
		cardType.spell(true);
		cost = new Resources([0, 0, 4]);
		windupTime = 1.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.castSpell_35__png, Library.damageColors.get(DamageTypes.magic), 192, 192, 35, 1));
		chargeTime = 2.0;
		possibleTargetsFunct = Library.characters.enemies;
	}
	override public function resolve()
	{
		damage(target, 14,4);
		
		super.resolve();
	}
}