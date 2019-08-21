package player.playerCards.green;

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
class ActionSurge extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner);
		name = "Action Surge";
		family = CardFamily.Green;
		cardType.positiveEffect(true);
		cost = new Resources([0, 2, 0]);
		windupTime = 0.0;
		chargeTime = 0.0;
	}
	override public function play()
	{	
		targets = [Library.characters.self(owner)];
		super.play();
	}
	override public function resolve()
	{
		super.resolve();
		
		for (card in owner.cardsInHand()){
			card.charge = chargeTime;
			card.isCharged = true;
		}
	}
}