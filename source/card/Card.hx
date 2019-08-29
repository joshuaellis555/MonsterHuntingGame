package card;
import utilities.animation.Animation;
import utilities.button.Button;
import character.Character;
import character.damage.DamageTypes;
import library.ElementalResistances;
import character.resistances.Resistances;
import character.statusEffects.StatusTypes;
import utilities.event.Event;
import flixel.FlxBasic;
import flixel.FlxG;
import utilities.observer.Observer;
import player.Player;
import character.resources.ResourceTypes;
import character.resources.Resources;
import utilities.selection.Selection;
import utilities.plusInterface.BasicPlus;
import library.Library;

/**
 * ...
 * @author ...
 */
class Card extends BasicPlus
{
	public var owner:Character; //character who owns the card
	
	public var name:String = ""; //name of the card
	public var cost:Resources; //resource cost of the card
	public var family:CardFamily; //cards family (color)
	public var cardType:CardType; //is the card melee, ranged, magic, etc...
	public var elements:Array<DamageTypes>=[]; //array of elements of the card (damageTypes)
	public var resistances:Resistances; //damage resistances based on elements
	
	public var cardState:Int;
	
	private var chargeTime:Float;
	private var currentCharge:Float = 0.0;
	
	public var target:Null<Character> = null; //card's target. Gets set in PlayerCard and MonsterCard
	public var targetFunctions:Array<Character->Bool->Array<Character>>;
	
	public var selectionStack:Array<Selection>;
	
	public var baseAction:ActionClass;
	public var currentAction:Null<ActionClass> = null;
	
	public function new(owner:Character, targetFunctions:Array<Character->Bool->Array<Character>>)
	{
		super(owner);
		this.targetFunctions = targetFunctions;
		this.owner = owner;
		
		cardType = new CardType(); //initialize card type
		cardState = CardState.Disabled; //initialize card state
	}
	
	public function play()
	{
		trace('play', cardState, CardState.Charged);
		owner.onDeckCard = this;
		if (cardState == CardState.Charged && baseAction != null)
			baseAction.trigger();
	}
	
	public function fail()
	{
		currentAction.updateEnabled = false;
		currentAction = null;
		owner.onDeckCard = null;
		if (cardState > CardState.Charged) cardState = CardState.Charged;
	}
	public function fizzle() //card has been countered during windup. Causes it to reset and discard without resolving
	{
		finish();
		cardState = CardState.Fizzled;
	}
	public function finish() //
	{
		if (cardState != CardState.Fizzled) cardState = CardState.Finished;
		currentCharge = 0.0;
		target = null;
		currentAction = null;
		owner.onDeckCard = null;
		owner.discardCard(this);
	}
	
	public function getTargets():Array<Array<Character>>
	{
		return [for (f in targetFunctions) [for (t in f(owner, true)) t]];
	}
	
	public function resetCharge()
	{
		if (cardState == CardState.Charged) cardState = CardState.Charging;
		currentCharge = 0.0;
	}
	
	override public function plusUpdate(elapsed:Float) 
	{
		super.plusUpdate(elapsed);
		if (cardState == CardState.Charging){
			currentCharge += elapsed;
			if (currentCharge >= chargeTime) cardState = CardState.Charged;
		}
	}
	
	override public function destroy():Void 
	{
		Library.cardOverseer.remove(this); //remove self from overseer
		super.destroy();
	}
}