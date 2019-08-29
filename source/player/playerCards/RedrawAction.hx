package player.playerCards;

import card.ActionClass;
import card.CardState;
import card.Card;
import player.Player;

/**
 * ...
 * @author Joshua Ellis
 */
class RedrawAction extends ActionClass 
{
	private var chargeTime:Float;
	private var currentCharge:Float;
	
	public function new(card:Redraw, chargeTime:Float) 
	{
		//trace('redraw action');
		super(card);
		this.chargeTime = chargeTime;
		this.currentCharge = 0.0;
	}
	
	override private function action()
	{
		super.action();
		updateEnabled = true;
		currentCharge = 0.0;
		card.cardState = CardState.Charging;
	}
	
	override public function plusUpdate(elapsed:Float)
	{
		currentCharge+= elapsed;
		//trace('currentCharge',currentCharge);
		if (currentCharge >= chargeTime){
			//trace('charged','drawPlayerCard');
			if (cast(card.owner, PlayerCharacter).drawPlayerCard(cast card)){
				updateEnabled = false;
				card.destroy();
			}
		}
	}
}