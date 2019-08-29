package player.playerCards;

import card.Card;
import character.Character;
import player.PlayerCharacter;
import flixel.util.FlxColor;
import player.Player;
import utilities.button.Button;
import utilities.selection.Selection;
import character.damage.DamageTypes;

/**
 * ...
 * @author Joshua Ellis
 */
class PlayerCard extends Card 
{
	private var player:Player;
	
	public function new(owner:PlayerCharacter,  targets:Array<Character->Bool->Array<Character>>)
	{
		super(owner, targets);
		player = owner.owner;
	}

	override public function fail()
	{
		player.selection.popSubSelection();
		player.resetFocus();
	}
	override public function finish()
	{
		super.finish();
		player.selection.popSubSelection();
		player.cardFinished();
	}
}