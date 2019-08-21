package monsters.monster.rhino.cards;

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
class RhinoBackUp extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		//trace('new Rest');
		super(owner, []);
		name = "Back Up";
		family = CardFamily.Yellow;
		cardType.positiveEffect(true);
		cost = new Resources([]);
		chargeTime = 3.0;
		//add(resolveAnimation = new Animation(AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1));
		possibleTargetsFunct = Library.characters.self;
	}
	override public function resolve()
	{
		target.distanced(true);
		target.giveResources(new Resources([0, 2, 0]));
		super.resolve();
		//trace('Rest resolve');
	}
}