package card.cardActions;

import card.ActionClass;
import card.Card;

/**
 * ...
 * @author Joshua Ellis
 */
class Finish extends ActionClass 
{

	public function new(card:Card) 
	{
		super(card);
	}
	
	override private function action()
	{
		super.action();
		card.finish();
	}
}