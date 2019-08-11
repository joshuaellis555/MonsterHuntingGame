package monsters;

import card.Card;
import character.Character;
import flixel.util.FlxColor;
import monsters.MonsterCharacter;
import player.Player;
import utilities.button.Button;
import utilities.selection.Selection;
import character.damage.DamageTypes;

/**
 * ...
 * @author Joshua Ellis
 */
class MonsterCard extends Card 
{
	public var monster:MonsterCharacter;
	
	public var possibleTargetsFunct:Character->Bool->Array<Character>;
	
	public function new(owner:MonsterCharacter, ?elements:Null<Array<DamageTypes>>=null, ?normalCard=true) 
	{
		super(owner, elements, normalCard);
		monster = owner;
	}
	public function getTarget():Null<Character>
	{
		var targets:Array<Character> = [for (t in possibleTargetsFunct(monster, true)) if (t.canBeTargetedBy(this)) t];
		if (targets.length > 0)
			return targets[Std.random(targets.length)];
		else
			return null;
	}
	override public function play()
	{
		super.play();
		if (isCharged){
			if (owner.resources.check(cost)){
				trace('play');
				target = monster.target;
				owner.onDeckCard = null;
				if (!beginResolution()){
					trace('!beginResolution()');
					owner.discardCard(this);
				}
			}
		}
	}
}