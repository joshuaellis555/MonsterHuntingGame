package monsters.monster.spectre.cards;

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
import library.Library;

/**
 * ...
 * @author Joshua ellis
 */
class SpectreGenerateMana extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, [DamageTypes.magic]);
		name = "Generate Mana";
		family = CardFamily.Blue;
		cardType.positiveEffect(true);
		cardType.spell(true);
		cost = new Resources([]);
		windupTime = 2.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.fortify__20__png, Library.damageColors.get(DamageTypes.magic), 192, 192, 20, 1,2));
		chargeTime = 4.0;
		possibleTargetsFunct = Library.characters.self;
	}
	override public function resolve()
	{
		target.giveResources(new Resources([0, 0, 15]));
		
		super.resolve();
	}
}