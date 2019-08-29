package player.playerCards;

import card.CardState;
import utilities.button.Button;
import player.playerCards.PlayerCard;
import card.CardFamily;
import player.PlayerCharacter;
import utilities.event.Event;
import player.Player;
import character.resources.Resources;
import character.resources.ResourceTypes;

/**
 * ...
 * @author Joshua ellis
 */
class Redraw extends PlayerCard
{
	private var redrawAction:RedrawAction;
	public function new(owner:PlayerCharacter) 
	{
		//trace("new redraw");
		super(owner,[]);
		name = "-";
		family = CardFamily.Unplayable;
		cost = new Resources([]);
		redrawAction = new RedrawAction(this, owner.drawSpeed());
		redrawAction.trigger();
	}
}