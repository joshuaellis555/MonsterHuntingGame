package card.cardActions;

import card.ActionClass;
import card.Card;

/**
 * ...
 * @author Joshua Ellis
 */
class ChooseTarget extends ActionClass 
{

	public function new(card:Card) 
	{
		super(card);
	}
	
	override private function action()
	{
		super.action();
		trace("ChooseTarget");
		card.owner.chooseTarget(card);
	}
	
	override public function plusUpdate(elapsed:Float) 
	{
		//trace("choose target",card.target);
		super.plusUpdate(elapsed);
		if (card.target != null) triggerNext();
	}
}