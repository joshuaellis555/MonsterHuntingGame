package player.playerCards.yellow;

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
class Guard extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner);
		name = "Guard";
		family = CardFamily.Yellow;
		cardType.positiveEffect(true);
		cost = new Resources([0, 1, 0]);
		windupTime = 0.0;
		chargeTime = 1.0;
	}
	override public function play()
	{
		targets = [Library.characters.self(owner)];
		
		super.play();
	}
	override public function resolve()
	{
		target.effects.addGuard(30, 12);
		
		super.resolve();
	}
}