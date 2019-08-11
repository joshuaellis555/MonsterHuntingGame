package player.playerCards.yellow;

import utilities.button.Button;
import card.CardFamily;
import card.CardType;
import character.Character;
import player.playerCards.PlayerCard;
import player.PlayerCharacter;
import utilities.event.Event;
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
 * @author Joshua Ellis
 */
class Run extends PlayerCard
{
	
	public function new(owner:PlayerCharacter) 
	{
		super(owner);
		name = "Run";
		family = CardFamily.Yellow;
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
		owner.distanced(true);
		
		super.resolve();
	}
}