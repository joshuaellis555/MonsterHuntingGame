package player.playerCards.redYellow;

import utilities.button.Button;
import card.CardFamily;
import card.CardType;
import character.Character;
import player.playerCards.PlayerCard;
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
 * @author Joshua Ellis
 */
class FallBack extends PlayerCard
{
	
	public function new(owner:PlayerCharacter) 
	{
		super(owner);
		name = "Fall Back";
		family = CardFamily.RedYellow;
		cost = new Resources([]);
		windupTime = 1.0;
		chargeTime = 1.0;
	}
	override public function play()
	{
		targets = [Library.characters.self(owner)];
		super.play();
	}
	override public function resolve()
	{
		owner.distanced(true);
		owner.giveResources(new Resources([0, 5, 0]));
		
		super.resolve();
	}
}