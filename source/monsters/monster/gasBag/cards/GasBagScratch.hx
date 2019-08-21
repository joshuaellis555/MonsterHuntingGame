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
class GasBagScratch extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, [DamageTypes.physical]);
		name = "Scratch";
		family = CardFamily.Red;
		cardType.melee(true);
		cost = new Resources([0, 2, 0]);
		windupTime = 2.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.roundbreak_20__png, 0xffcccccc, 192, 192, 25, 1,2));
		chargeTime = 2.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1));
		possibleTargetsFunct = Library.characters.enemies;
	}
	override public function resolve()
	{
		damage(target, 4, 4);
		
		super.resolve();
	}
}