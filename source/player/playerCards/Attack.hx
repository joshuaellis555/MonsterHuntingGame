package player.playerCards;

import card.ActionClass;
import card.cardActions.CheckPlayable;
import card.cardActions.ChooseTarget;
import card.cardActions.DamageTarget;
import card.cardActions.Finish;
import library.Library;
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
class Attack extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner,[]);
		name = "Attack";
		family = CardFamily.Red;
		cost = new Resources([0, 2, 0]);
		chargeTime = 3;
		targetFunctions = [Library.characters.enemies, Library.characters.allies];
		
		baseAction = new CheckPlayable(this);
		var nextAction:Null<ActionClass> = baseAction.next = cast new ChooseTarget(this);
		nextAction = nextAction.next = cast new DamageTarget(this, 10);
		nextAction = nextAction.next = cast new Finish(this);
	}
}