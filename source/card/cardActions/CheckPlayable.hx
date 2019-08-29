package card.cardActions;

import card.ActionClass;
import card.Card;

/**
 * ...
 * @author Joshua Ellis
 */
class CheckPlayable extends ActionClass 
{

	public function new(card:Card) 
	{
		super(card);
	}
	
	override private function action()
	{
		super.action();
		//trace("CheckPlayable");
		//trace("card.currentAction", card.currentAction);
		if (!card.owner.resources.check(card.cost)){
			//trace("card.owner.resources.check");
			card.currentAction = null;
		}
		if ([for (slice in card.getTargets()) for (t in slice) if (t.canBeTargetedBy(card)) t].length == 0){
			//trace("canBeTargetedBy",card.getTargets());
			card.currentAction = null;
		}
		//trace("triggerNext");
		triggerNext();
	}
}