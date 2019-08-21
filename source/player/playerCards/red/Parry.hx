package player.playerCards.red;

import utilities.button.Button;
import player.playerCards.PlayerCard;
import card.CardFamily;
import character.Character;
import player.PlayerCharacter;
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
class Parry extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.physical]);
		name = "Parry";
		family = CardFamily.Red;
		cardType.melee(true);
		cost = new Resources([0, 2, 0]);
		windupTime = 0.0;
		chargeTime = 1.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1));
	}
	override public function play()
	{	
		targets = [Library.characters.enemies(owner), Library.characters.allies(owner)];
		super.play();
	}
	override public function beginResolution():Bool
	{
		target = cast player.selection.getTarget();
		if (target.windupCard != null){
			if (target.windupCard.cardType.melee() == false) return false;
		}
		else{
			return false;
		}
		return super.beginResolution();
	}
	override public function resolve()
	{
		if (Std.random(Std.int(Math.max(owner.strength(), owner.dexterity())) + target.strength()) < Math.max(owner.strength(), owner.dexterity())){
			target.windupCard.fizzle();
			target.damageNumbers.addNumber('Parried', FlxColor.RED);
		}else{
			target.windupCard.target = owner;
			owner.damageNumbers.addNumber('Fail', FlxColor.RED);
		}
		
		super.resolve();
	}
}