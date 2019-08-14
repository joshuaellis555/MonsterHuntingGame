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
	public var owner:Character;
	
	public var enabled:Bool = false;
	
	public var name:String = "";
	public var cost:Resources;
	public var family:CardFamily;
	public var cardType:CardType;
	public var elements:Array<DamageTypes>=[];
	public var resistances:Resistances;
	
	public var charge:Float = 0.0;
	public var chargeTime:Float = 0.0;
	public var isCharged:Bool = false;
	
	public var isResolving:Bool = false;
	
	public var windup:Float = -1.0;
	public var windupTime:Float = 0.0;
	public var windupAnimation:Null<Animation> = null;
	public var resolveAnimation:Null<Animation> = null;
	
	public var stacks:Int = 0;
	public var isStackable:Bool = false;
	
	public var target:Null<Character> = null;
	
	private var discardActions:Array<Card->Void> = [];
	
	private var resolveDelay:Float = -1.0;
	private var resolveDelayTime:Float = 0.0;
	private var resolveDelayDamageTrigger:Null<Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float> = null;
	private var resolveDelayDamageContainer:Null<Array<Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float>> = null;
	public var resolveDelayAnimation:Null<Animation> = null;
	public var delayAnimation:Null<Animation> = null;	
	
	public function new(owner:Character, ?elements:Null<Array<DamageTypes>>=null, ?normalCard = true)
	{
		//trace('new');
		super(owner);
		
		//owner.addItem(this);
		
		this.owner = owner;
		if (elements!=null)
			this.elements = elements;
		if (normalCard){
			Library.cardOverseer.add(this);
			resistances = new Resistances();
			for (i in 0...this.elements.length)
				resistances.add(i, Library.elementalResistances.get(this.elements[i]).retMultiply(1 / this.elements.length));
			owner.resistances.add(ID, resistances);
			
		}
		
		cardType = new CardType();
	}
	public function play(){}
	public function fizzle()
	{
		finish();
		if (windupAnimation != null) windupAnimation.stop();
	}
	public function finish()
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
		if (target == null) return false;
		if (!owner.resources.remove(cost, true)) return false;
		
		// move into "if (windupTime <= 0.0){}" ???
		if (windupAnimation != null) windupAnimation.play(owner);
		
		isResolving = true;
		
		if (windupTime <= 0.0){
			//trace('no windup');
			resolve();
		}
		else{
			//trace('windup');
			owner.windupCard = this;
			owner.statusEffects.addStatus(StatusTypes.delayed, windupTime);
			windup = 0.0;
		}
		return true;
	}
	public function resolve()
	{
		if (enabled == false){
			return; //check if spell has been countered
		}
		
		if (resolveDelayTime > 0.0){
			owner.resolvingCard = this;
			owner.windupCard = null;
			resolveDelay = 0.0;
			if (delayAnimation != null) delayAnimation.play(target);
			if (resolveDelayDamageTrigger != null && resolveDelayDamageContainer != null){
				setDamageTrigger(resolveDelayDamageContainer, resolveDelayDamageTrigger);
			}
			return;
		}else{
			if (resolveAnimation != null) resolveAnimation.play(target);
			finish();
		}
	}
	public function delayedResolve()
	{
		if (resolveDelayAnimation != null) resolveDelayAnimation.play(target);
		finish();
	}
	public function discard()
	{
		for (dis in discardActions) dis(this);
		owner.discardCard(this);
		resetCard();
	}
	public function charged() {}
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
		, trigger:Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float)
	{
		//trace('setDamageTrigger');
		resolveDelayDamageTrigger = trigger;
		resolveDelayDamageContainer = container;
		if (resolveDelayDamageContainer.indexOf(trigger) == -1)
			resolveDelayDamageContainer.push(trigger);
	}
	
	//TODO public function remove
	
	override public function plusUpdate(elapsed:Float):Void
	{
		super.plusUpdate(elapsed);
		if (enabled){
			charge = Math.min(elapsed + charge, chargeTime);
			if (!isCharged && chargeTime == charge){
				isCharged = true;
				charged();
			}
			if (isStackable && chargeTime == charge){
				stacks++;
				charge = 0;
			}
		}
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
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
		Library.cardOverseer.remove(this);
		super.destroy();
	}
}