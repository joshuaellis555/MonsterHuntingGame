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
class SuperRhinoRest extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, []);
		name = "Rest";
		family = CardFamily.Green;
		cardType.positiveEffect(true);
		cost = new Resources([]);
		chargeTime = 3.0;
		//add(resolveAnimation = new Animation(AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1));
		possibleTargetsFunct = Library.characters.self;
	}
	override public function resolve()
	{
		target.giveResources(new Resources([2, 6, 0]));
		super.resolve();
	}
}