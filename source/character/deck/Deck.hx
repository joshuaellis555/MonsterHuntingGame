package character.deck;
import card.Card;

/**
 * ...
 * @author Joshua ellis
 */
class Deck 
{
	public var knownCards:Array<Card> = [];
	private var unknownCards:Array<Card> = [];
	private var numKnown:Int;
	public var length:Int=0;
	public function new(?numKnown:Int=99999) 
	{
		this.numKnown = numKnown;
	}
	public function push(card:Card)
	{
		unknownCards.push(card);
		slideCards();
		length = knownCards.length + unknownCards.length;
	}
	public function pop():Null<Card>
	{
		var c:Null<Card>=null;
		if (knownCards.length > 0){
			c = knownCards[0];
			knownCards.remove(knownCards[0]);
		}else if (unknownCards.length > 0){
			c = popUnknown();
		}
		slideCards();
		length = knownCards.length + unknownCards.length;
		return c;
	}
	
	private function popUnknown():Card
	{
		var i:Int = 0;
		while (i < unknownCards.length-1){
			if (Std.random(2)==1) break;
			i++;
		}
		var c:Card = unknownCards[i];
		unknownCards.remove(c);
		return c;
	}
	private function slideCards()
	{
		while (knownCards.length < numKnown && unknownCards.length > 0){
			knownCards.push(popUnknown());
		}
	}
}