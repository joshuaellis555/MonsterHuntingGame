package character.deck;
import card.Card;

/**
 * ...
 * @author Joshua ellis
 */
class Deck 
{
	public var knownCards:Array<Card> = []; //array of known cards
	private var unknownCards:Array<Card> = []; //array of unknown cards
	private var numKnown:Int; //revealed cards at the top of the deck
	public var length:Int = 0; //tracks the size of the deck
	
	public function new(?numKnown:Int=99999) 
	{
		this.numKnown = numKnown;
	}
	public function push(card:Card) //add a card to the deck
	{
		unknownCards.push(card);
		slideCards();
		length = knownCards.length + unknownCards.length;
	}
	public function pop():Null<Card> //remove the top card of the deck
	{
		var c:Null<Card>=null;
		if (knownCards.length > 0){ //if there are know cards, pop one
			c = knownCards[0];
			knownCards.remove(knownCards[0]);
		}else if (unknownCards.length > 0){ //otherwise pop an unknown card
			c = popUnknown();
		}
		slideCards(); //slide cards from unknown to known
		length = knownCards.length + unknownCards.length;
		return c; //return the card
	}
	
	private function popUnknown():Card //grabs a random unknown card
	{
		var i:Int = 0;
		while (i < unknownCards.length-1){ //there is a 50% chance of getting the top unknown card, 25% the second, 17.5% the third, etc...
			if (Std.random(2)==1) break;
			i++;
		}
		var c:Card = unknownCards[i];
		unknownCards.remove(c);
		return c;
	}
	private function slideCards() //slide cards from unknown to known
	{
		while (knownCards.length < numKnown && unknownCards.length > 0){
			knownCards.push(popUnknown());
		}
	}
}