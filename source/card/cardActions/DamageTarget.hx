package card.cardActions;

import card.ActionClass;
import card.Card;

/**
 * ...
 * @author Joshua Ellis
 */
class DamageTarget extends ActionClass 
{
	private var damage:Float;
	public function new(card:Card, damage) 
	{
		super(card);
		this.damage = damage;
	}
	
	override private function action()
	{
		super.action();
		if (card.target.canBeTargetedByType(card.cardType))
			card.target.takesDamage(card.elements, card.owner.doesDamage(card.elements, damage, card.cardType, card.owner), card.cardType, card.owner);
		
		triggerNext();
	}
}