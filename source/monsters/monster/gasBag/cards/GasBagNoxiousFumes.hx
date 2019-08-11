package monsters.monster.gasBag.cards;

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
class GasBagNoxiousFumes extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, [DamageTypes.poison]);
		name = "Noxious Fumes";
		family = CardFamily.Green;
		cardType.ranged(true);
		cost = new Resources([0, 3, 0]);
		windupTime = 1.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.castSpell_35__png, 0xff003322, 192, 192, 35, 1));
		chargeTime = 2.5;
		possibleTargetsFunct = Library.characters.enemies;
	}
	override public function resolve()
	{
		target.effects.removeGuard(Std.int(target.effects.maxGuard() * Std.random(7)/10));
		damage(target, 1, 6);
		
		super.resolve();
	}
}