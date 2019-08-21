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
class RhinoCharge extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner, [DamageTypes.physical]);
		name = "Charge";
		family = CardFamily.Red;
		cardType.melee(true);
		cardType.charge(true);
		cost = new Resources([0, 3, 0]);
		windupTime = 3.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.roundbreak_20__png, 0xffcccccc, 192, 192, 22, 1, 3));
		chargeTime = 3.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1));
		possibleTargetsFunct = Library.characters.enemies;
	}
	override public function beginResolution():Bool
	{
		if (!super.beginResolution()) return false;
		
		owner.distanced(true);
		
		return true;
	}
	override public function resolve()
	{
		damage(target, if (this.owner.distanced()) 7 else 5, if (this.owner.distanced()) 7 else 2);
		
		target.distanced(false);
		
		super.resolve();
	}
}