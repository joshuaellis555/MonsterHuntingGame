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
	public function new(owner:PlayerCharacter, ?elements:Null<Array<DamageTypes>>=null, ?normalCard=true) 
	{
		super(owner, elements, normalCard);
		player = owner.owner;
	}
	
	override public function play()
	{
		if (targets.length == 0)
			return;
		else{
			var total:Int = 0;
			for (t in targets)
				total += t.length;
			if (total == 0) return;
		}
		
		targets = [for (set in targets) [for (t in set) if (t.canBeTargetedBy(this)) t]];
		super.play();
		if (isCharged){
			if (owner.resources.check(cost))
				player.selection.addSubSelection(new Selection(cast targets, nextSlice, previousSlice, next, previous, ok, esc));
		}
	}
	public function next()
	{
		player.selection.next();
		if (player.selection.getTarget().alive == false){
			if (!player.selection.removeCurrent()){
				fail();
				return;
			}
			player.selection.previous();
			next();
		}else{
			player.setFocus(player.selection.getTarget());
		}
	}
	public function previous()
	{
		player.selection.previous();
		if (player.selection.getTarget().alive == false){
			if (!player.selection.removeCurrent()){
				fail();
				return;
			}
			previous();
		}else{
			player.setFocus(player.selection.getTarget());
		}
	}
	public function nextSlice()
	{
		//trace('nextSlice');
		player.selection.nextSlice();
		while (player.selection.getTarget().alive == false){
			if (!player.selection.removeCurrent()){
				fail();
				return;
			}
		}
		player.setFocus(player.selection.getTarget());
	}
	public function previousSlice()
	{
		//trace('previousSlice');
		player.selection.previousSlice();
		while (player.selection.getTarget().alive == false){
			if (!player.selection.removeCurrent()){
				fail();
				return;
			}
		}
		player.setFocus(player.selection.getTarget());
	}
	public function ok()
	{
		if (!beginResolution()) return;
	}
	public function esc()
	{
		player.selection.popSubSelection();
		player.resetFocus();
	}
	public function info(button:Button){}
	public function fail()
	{
		player.selection.popSubSelection();
		player.resetFocus();
	}
	override public function finish()
	{
		super.finish();
		player.character.resetCardTimers(family);
		player.selection.popSubSelection();
		player.cardFinished(this);
	}
	override public function beginResolution():Bool
	{
		target = cast player.selection.getTarget();
		target = target.targetThis(this); //check for blessing, reffect, etc...
		//try to target a character
		
		return super.beginResolution();
	}
}