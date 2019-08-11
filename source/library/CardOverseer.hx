package library;
import card.Card;
import character.Character;
import flixel.FlxG;
import flixel.FlxState;

/**
 * ...
 * @author JoshuaEllis
 */
class CardOverseer
{
	public static var members:Map<Int,Array<Card>>;
	private static var cID:Int = 10000;

	public function new()
	{
		members = new Map<Int,Array<Card>>();
	}
	public function add(card:Card)
	{
		//trace('add');
		//trace(cID);
		card.ID = cID;
		cID++;
		if (!members.exists(card.owner.ID))
			members[card.owner.ID] = [];	
		members[card.owner.ID].push(card);
	}
	public function remove(card:Card)
	{
		if (members.exists(card.owner.ID)){
			members[card.owner.ID].remove(card);
			if (members[card.owner.ID].length <= 0)
				members.remove(card.owner.ID);
		}
	}
}