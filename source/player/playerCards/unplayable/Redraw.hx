package player.playerCards.unplayable;

import utilities.button.Button;
import player.playerCards.PlayerCard;
import card.CardFamily;
import player.PlayerCharacter;
import utilities.event.Event;
import player.Player;
import character.resources.Health;
import character.resources.Resources;
import character.resources.ResourceTypes;

/**
 * ...
 * @author Joshua ellis
 */
class Redraw extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, null, false);
		name = "-";
		family = CardFamily.Unplayable;
		cost = new Resources([]);
		chargeTime = owner.drawSpeed();
		enabled = true;
	}
	override public function play() {}
	override public function discard() {}
	override public function charged()
	{
		if (!player.character.drawPlayerCard(this)){
			isCharged = false;
		}else{
			this.destroy();
		}
		
	}
}