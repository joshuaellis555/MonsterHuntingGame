package monsters.monster.spectre.cards;

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
class SpectreBarrier extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner);
		name = "Barrier";
		family = CardFamily.Black;
		cardType.spell(true);
		cardType.positiveEffect(true);
		cost = new Resources([0, 0, 2]);
		windupTime = 0.0;
		chargeTime = 2.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.Protect_20__png, Library.damageColors.get(DamageTypes.dark), 192, 192, 25, 1));
		possibleTargetsFunct = Library.characters.allies;
	}
	override public function resolve()
	{
		target.effects.addBarrier(15,20);
		
		super.resolve();
	}
}