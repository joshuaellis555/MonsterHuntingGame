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
class SuperRhinoGuard extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, []);
		name = "Guard";
		family = CardFamily.Green;
		cardType.positiveEffect(true);
		cost = new Resources([0,1,0]);
		chargeTime = 4.0;
		//add(resolveAnimation = new Animation(AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1));
		possibleTargetsFunct = Library.characters.self;
	}
	override public function resolve()
	{
		target.effects.addGuard(Std.int(Math.min(35,target.effects.maxGuard()+5)), 15);
		
		super.resolve();
	}
}