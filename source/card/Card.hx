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
	
	public var enabled:Bool = false; //cards ara disabled when in the discard
	
	public var name:String = ""; //name of the card
	public var cost:Resources; //resource cost of the card
	public var family:CardFamily; //cards family (color)
	public var cardType:CardType; //is the card melee, ranged, magic, etc...
	public var elements:Array<DamageTypes>=[]; //array of elements of the card (damageTypes)
	public var resistances:Resistances; //damage resistances based on elements
	
	public var charge:Float = 0.0; //how long the card has been charging
	public var chargeTime:Float = 0.0; //how long it takes the card to charge
	public var isCharged:Bool = false; //if it is charged
	
	public var isResolving:Bool = false; //if the card is resolving (used by monsters)
	
	public var windup:Float = -1.0; //how long the windup phase has been going. <0 = disabled
	public var windupTime:Float = 0.0; //how long the windup takes
	public var windupAnimation:Null<Animation> = null; //animation played during windup
	public var resolveAnimation:Null<Animation> = null; //resolve animation
	
	public var stacks:Int = 0; //some cards can charge up multiple stacks if it is allowed to charge longer
	public var isStackable:Bool = false; //if card is stackable
	
	public var target:Null<Character> = null; //card's target. Gets set in PlayerCard and MonsterCard
	
	private var discardActions:Array<Card->Void> = []; //array of functions to resolve during discard. Not used, may be removed
	
	private var resolveDelay:Float = -1.0; //how long the delayed resolve phase has been going. <0 = disabled
	private var resolveDelayTime:Float = 0.0; //how long the delayed resolve phase lasts
	private var resolveDelayDamageTrigger:Null<Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float> = null; //damage trigger for resolved delay
	private var resolveDelayDamageContainer:Null<Array<Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float>> = null; //the container for the resolved delay damage trigger
	public var resolveDelayAnimation:Null<Animation> = null; //animation played on resolve after delayed resolve
	public var delayAnimation:Null<Animation> = null; //animation played during delayed resolve
	
	public function new(owner:Character, ?elements:Null<Array<DamageTypes>>=null, ?normalCard = true)
	{
		//trace('new');
		super(owner);
		
		//owner.addItem(this); //cards are added by plusInterface
		
		this.owner = owner;
		if (elements!=null)
			this.elements = elements; //set elements
		if (normalCard){ //unplayable cards such as redraw have normalCard=False
			Library.cardOverseer.add(this); //add card to card overseer (also gives card unique id)
			resistances = new Resistances(); //build resistances
			for (i in 0...this.elements.length)
				resistances.add(i, Library.elementalResistances.get(this.elements[i]).retMultiply(1 / this.elements.length));
			owner.resistances.add(ID, resistances); //set resistances
		}
		
		cardType = new CardType(); //initialize card type
	}
	public function play(){} //logic handled by PlayerCard and MonsterCard
	public function fizzle() //card has been countered during windup. Causes it to reset and discard without resolving
	{
		finish();
		if (windupAnimation != null) windupAnimation.stop();
	}
	public function finish() //
	{
		trace('finish');
		if (resolveDelayDamageTrigger != null && resolveDelayDamageContainer != null){
			resolveDelayDamageContainer.remove(resolveDelayDamageTrigger);
		}
		
		owner.windupCard = null;
		owner.resolvingCard = null;
		discard();
	}
	public function beginResolution():Bool
	{
		trace('Card beginResolution', target);
		if (target == null) return false; //resolve failed because no target
		if (!owner.resources.remove(cost, true)) return false; //resolve failed because owner doesn't have resources
		
		//todo: move into "if (windupTime <= 0.0){}" ???
		if (windupAnimation != null) windupAnimation.play(owner);
		
		isResolving = true;
		
		if (windupTime <= 0.0){ //resolve if no windup phase
			//trace('no windup');
			resolve();
		}
		else{ //begin windup phase
			//trace('windup');
			owner.windupCard = this;
			owner.statusEffects.addStatus(StatusTypes.delayed, windupTime); //delay owner for duration of windup
			windup = 0.0;
		}
		return true; //successfully begain resolution
	}
	public function resolve() //resolve card
	{
		if (enabled == false){
			return; //check if spell has been countered
		}
		
		if (resolveDelayTime > 0.0){ // if card uses delayed resolve phase
			owner.resolvingCard = this;
			owner.windupCard = null;
			resolveDelay = 0.0;
			if (delayAnimation != null) delayAnimation.play(target); //play delayAnimation on target
			if (resolveDelayDamageTrigger != null && resolveDelayDamageContainer != null){ //if damage trigger is not set (for safety)
				setDamageTrigger(resolveDelayDamageContainer, resolveDelayDamageTrigger); //set damage triggers
			}
		}else{
			if (resolveAnimation != null) resolveAnimation.play(target); //play resolveAnimation
			finish(); //finish card
		}
	}
	public function delayedResolve() //resolve after delayed resolve phase
	{
		if (resolveDelayAnimation != null) resolveDelayAnimation.play(target);
		finish();
	}
	public function discard() //discard the card
	{
		for (dis in discardActions) dis(this);
		owner.discardCard(this);
		resetCard();
	}
	public function charged() {} //placeholder for if the card has any special actions that occure when its charged
	public function resetCard()
	{
		enabled = false;
		charge = 0.0;
		isCharged = false;
		windup = -1.0;
		resolveDelay = -1.0;
		target = null;
		isResolving = false;
		target = null;
	}
	public function resetCharge()
	{
		charge = 0.0;
		isCharged = false;
	}
	
	public function damageTrigger(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		delayedResolve();
		return value;
	}
	
	public function damage(target:Character, value:Float, ?randomExtra:Float = 0.0, ?damageType:Null<Array<DamageTypes>> = null, ?cardType:Null<CardType> = null):Float
	{	
		if (damageType == null)
			damageType = elements;
		if (cardType == null)
			cardType = this.cardType;
			
		if (!target.canBeTargetedByType(cardType)) return 0;
		
		var f:Float = target.takesDamage(damageType, owner.doesDamage(damageType, value + Std.random(Std.int(randomExtra * 10 + 1)) / 10, cardType, owner), cardType, owner);
		
		if (owner.combos() && damageType.indexOf(DamageTypes.physical) >= 0)
			if (f >= 1)
				owner.effects.addCombo();
		
		if (cardType.melee() && owner.distanced())
			owner.distanced(false);
		
		return f;
	}
	
	private function setDamageTrigger(container:Array<Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float>
		, trigger:Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float) //set the damage triggers
	{
		//trace('setDamageTrigger');
		resolveDelayDamageTrigger = trigger; //set trigger
		resolveDelayDamageContainer = container; //set trigger's container
		if (resolveDelayDamageContainer.indexOf(trigger) == -1)
			resolveDelayDamageContainer.push(trigger); //push trigger to container if it isn't there already (it shouldn't be, this is for safety)
	}
	
	//TODO public function remove
	
	override public function plusUpdate(elapsed:Float):Void
	{
		super.plusUpdate(elapsed);
		if (enabled){
			charge = Math.min(elapsed + charge, chargeTime);
			if (!isCharged && chargeTime == charge){ //card is charged
				isCharged = true;
				charged();
			}
			if (isStackable && chargeTime == charge){ //add a stack to the card
				stacks++;
				charge = 0;
			}
		}
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed); //windup and resolvedDelay will happen even if owner is delayed
		if (windup >= 0.0){
			windup += elapsed;
			if (windup >= windupTime) resolve();
		}
		if (resolveDelay >= 0.0){
			resolveDelay += elapsed;
			if (resolveDelay >= resolveDelayTime) delayedResolve();
		}
	}
	override public function destroy():Void 
	{
		Library.cardOverseer.remove(this); //remove self from overseer
		super.destroy();
	}
}