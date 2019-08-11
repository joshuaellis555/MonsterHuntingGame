package monsters.monster.superRhino.cards;

import utilities.button.Button;
import monsters.MonsterCard;
import player.playerCards.PlayerCard;
import card.CardFamily;
import character.Character;
import player.PlayerCharacter;
import utilities.event.Event;
import monsters.MonsterCharacter;
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
class SuperRhinoEarthquake extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, [DamageTypes.earth]);
		name = "Earthquake";
		family = CardFamily.Blue;
		cardType.spell(true);
		cost = new Resources([0, 0, 4]);
		windupTime = 2.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.castSpell_35__png, Library.damageColors.get(DamageTypes.earth), 192, 192, 45, 1));
		chargeTime = 4.0;
		possibleTargetsFunct = Library.characters.enemies;
	}
	override public function resolve()
	{
		damage(target, 10, 5);
		
		super.resolve();
	}
}