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
class SuperRhinoBash extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, [DamageTypes.physical]);
		name = "Bash";
		family = CardFamily.RedYellow;
		cardType.melee(true);
		cost = new Resources([0, 2, 0]);
		windupTime = 2.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.roundbreak_20__png, 0xffcccccc, 192, 192, 22, 1, 2));
		chargeTime = 2.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1));
		possibleTargetsFunct = Library.characters.enemies;
	}
	override public function resolve()
	{
		damage(target, if (this.owner.distanced()) 9 else 3, 7);
		owner.effects.addGuard(Std.int(Math.max(5, owner.effects.maxGuard() + 3)), 10);
		
		super.resolve();
	}
}