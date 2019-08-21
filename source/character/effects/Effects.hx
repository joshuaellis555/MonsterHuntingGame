package character.effects;
import utilities.animation.Animation;
import card.Card;
import card.CardFamily;
import card.CardType;
import character.Character;
import character.damage.DamageTypes;
import character.effects.Defender;
import flixel.util.FlxColor;
import utilities.plusInterface.BasicPlus;
import library.Library;


/**
 * ...
 * @author ...
 */
class Effects extends BasicPlus
{
	public var owner:Character;
	
	public var venomCount:Int = 0; //how much health is lost each tick (second)
	public var venomTime:Float = 0.0; //how much longer venom lasts
	public var venomTick:Float = 0.0; //time until next tick
	public var venomPadding:Float = 0.0; //there is an extra second after venomTime runs out for more venom to be added
	private var venomCT:CardType; //CardType used for venom to damage character
	
	public var comboCount:Int = 0; //combo multiplier
	public var comboCountdown:Float = 0.0; //countdown to combo clearing
	
	public var guard:Array<Guard> = []; //array of instances of guard
	public var defender:Array<Defender> = []; //array of instances of defender
	
	public var blessing:Array<Float> = []; //timers for instances of blessing (blocks next negative magic effect)
	private var blessingAnimation:Animation;
	
	public var curse:Array<Float> = []; //timers for instances of curse (blocks next positive magic effect)
	private var curseAnimation:Animation;
	
	public var barrier:Float = 0.0; //amount of barrier (damage negation)
	public var barrierCountdown:Float = 0.0; //time until barier clears
	
	public function new(owner:Character) 
	{
		super(owner);
		this.owner = owner;
		
		venomCT = new CardType();
		venomCT.trueDamage(true); //create venom CardType
		
		owner.addItem(blessingAnimation = new Animation(owner,AssetPaths.DeProtect_20__png, 0xffaabbff, 192, 192, 25, 1));
		owner.addItem(curseAnimation = new Animation(owner, AssetPaths.DeProtect_20__png, 0xff550044, 192, 192, 25, 1));
		
		forceUpdate = true;
	}
	
	public function addVenom(time:Float, ?count:Int = 1) //add some number of stacks of venom and extend duration
	{
		venomCount += count; //add stacks
		venomTime = Math.max(time+1-venomTick, venomTime); //extend duration
		
		if (venomCount > 1) //display to players the venom added
			owner.damageNumbers.addNumber('Poisoned ' + Std.string(Std.int(time)) + 's x' + Std.string(venomCount), Library.damageColors.get(DamageTypes.poison));
		else
			owner.damageNumbers.addNumber('Poisoned ' + Std.string(Std.int(time)) + 's', Library.damageColors.get(DamageTypes.poison));
	}
	
	public function addCombo(?count:Int = 1) //add combo
	{
		if (comboCount < owner.dexterity() + 1) //combo has a max = dex + 1
			comboCount += 1;
		owner.damageNumbers.addNumber('COMBO x'+Std.string(Std.int(comboCount)), FlxColor.GREEN);
		comboCountdown = 3.0;
	}
	public function Combo():Int //get and clear combo
	{
		var tmp:Int = comboCount;
		comboCount = 0;
		return tmp;
	}
	
	public function addGuard(value:Int, time:Float) //add an istance of guard
	{
		//each istance of guard has a value (total amount of damage it will block) and time it lasts
		guard.push(new Guard(value, time));
		owner.damageNumbers.addNumber('Guard ' + Std.string(value), FlxColor.GREEN);
	}
	public function removeGuard(value:Int) //sets all instances of guard whose guard value > maxGuard - value to maxGuard - value
	{
		var _maxGuard:Int = maxGuard();
		if (_maxGuard == 0) return;
		_maxGuard -= value;
		if (_maxGuard <= 0){ //if this sets maxGuard to 0 then notify the player and empty the gyard array
			guard = [];
			owner.damageNumbers.addNumber('Guard Down', FlxColor.RED);
		}else{
			for (g in guard){
				if (g.value > _maxGuard)
					g.value = _maxGuard;
			}
		}
	}
	public function maxGuard():Int //the highest value out of all instances of guard
	{
		var _maxGuard:Int = 0;
		for (g in guard){
			if (g.value > _maxGuard)
				_maxGuard = g.value;
		}
		return _maxGuard;
	}
	
	public function addDefender(returnFunction:Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float, source:Character, time:Float)
	{
		//each instance of defender has a time it lasts and a function it will call when this character takes damage
		defender.push(new Defender(returnFunction, source, time));
	}
	
	public function addBlessing(time:Float, ?count:Int = 1) //add instances of blessing
	{
		for (i in 0...count)
			blessing.push(time);
		blessing.sort(function(a, b) return Std.int(b*1000 - a*1000)); //sort blessing high to low
	}
	
	public function addCurse(time:Float, ?count:Int = 1) // add instances of curse
	{
		for (i in 0...count)
			curse.push(time);
		curse.sort(function(a, b) return Std.int(b*1000 - a*1000)); //sort curse high to low
	}
	
	public function addBarrier(value:Int, time:Float) //add barrier
	{
		if (barrier < value) barrier = value; //add barier value
		if (barrierCountdown < time) barrierCountdown = time; //add barier time
	}
	
	override public function plusUpdate(elapsed:Float)
	{
		super.plusUpdate(elapsed);
		
		if (venomTime > 0) venomTick += elapsed;
		venomTime -= elapsed;
		if (venomTick >= 1.0){ //trigger damage ever second
			owner.takesDamage([DamageTypes.poison], venomCount, venomCT); //damage player based on number of venom stacks
			venomTick -= 1.0;
			venomPadding = 1.0;
		}
		if (venomTime <= 0.0){
			venomTime = 0.0;
			venomTick = 0.0;
			if (venomPadding <= 0.0) venomCount = 0; //reset count when padding has run out
		}

		
		comboCountdown -= elapsed; //reduce combo if no attack has been made after 3 seconds
		if (comboCountdown <= 0.0){
			comboCountdown += 3.0;
			if (comboCount > 0)
				comboCount -= 1;
		}
		
		var numRemoved:Int = 0; //update timers and remove any that have expired
		for (i in 0...(defender.length)){
			defender[i - numRemoved].time-= elapsed;
			if (defender[i - numRemoved].time <= 0.0){
				defender.remove(defender[i - numRemoved]);
				numRemoved += 1;
				owner.damageNumbers.addNumber('Defender Ends', FlxColor.RED);
			}
		}
		
		///*
		if (guard.length > 0){ //update timers and remove any that have expired
			numRemoved = 0;
			for (i in 0...(guard.length)){
				guard[i - numRemoved].time-= elapsed;
				if (guard[i - numRemoved].time <= 0.0){
					guard.remove(guard[i - numRemoved]);
					numRemoved += 1;
				}
			}
			if (guard.length == 0)
				owner.damageNumbers.addNumber('Guard Down', FlxColor.RED);
		}
		//*/
		
		numRemoved = 0; //update timers and remove any that have expired
		for (i in 0...(blessing.length)){
			blessing[i - numRemoved]-= elapsed;
			if (blessing[i - numRemoved] <= 0.0){
				blessing.remove(blessing[i - numRemoved]);
				numRemoved += 1;
			}
		}
		
		numRemoved = 0; //update timers and remove any that have expired
		for (i in 0...(curse.length)){
			curse[i - numRemoved]-= elapsed;
			if (curse[i - numRemoved] <= 0.0){
				curse.remove(curse[i - numRemoved]);
				numRemoved += 1;
			}
		}
		
		barrierCountdown -= elapsed; //update timers and set barrier to 0 if it is expired
		if (barrierCountdown <= 0.0){
			barrier = 0;
		}
	}
	
	public function takesDamage1(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float //pre resistance takeDamage call
	{
		//allow defender character to take damage first in order of intance creation
		for (i in 0...defender.length){
			var j:Int = defender.length - i - 1;
			//this character takes damage based on the leftover damage from defending character
			var newValue:Float = defender[j].returnFunction(types, value, cardType, source);
			if (newValue < value){ //skip this is defender somehow increases the damage
				value = newValue;
				owner.damageNumbers.addNumber('Defended', Library.cardColors.get(CardFamily.Yellow)); //display that defender triggered
				defender[j].source.damageNumbers.addNumber('Defend', Library.cardColors.get(CardFamily.Yellow));
			}
		}
		
		if (barrier > 0){ //barrer flat reduces damage (it acts like temp hp with no resistances or weaknesses)
			var damagePrevented:Float = Math.min(value, barrier);
			barrier -= damagePrevented;
			value -= damagePrevented;
			if (barrier <= 0){
				barrierCountdown = 0;
				owner.damageNumbers.addNumber('Barrier Down', FlxColor.RED);
			}
		}
		
		return value;
	}
	public function takesDamage2(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		//guard reduces damage the character takes based on the character's highest instance of guard
		var _maxGuard:Int = maxGuard();
		
		if (_maxGuard == 0 || cardType.piercing() >= 1.0 || cardType.trueDamage()) return value;
		
		var damagePrevented:Int = Math.round(Math.max(Math.min(value-value / (_maxGuard / 20 + 1), _maxGuard), 1)); //calcuate amount of damage prevented (min 1 max _maxGuard)
		damagePrevented = Std.int(damagePrevented * (1 - cardType.piercing())); //reduce damagePrevented by piercing ratio
		value -= damagePrevented; //reduce damage by damagePrevented
		
		removeGuard(damagePrevented); //remove guard equal to damagePrevented
		
		return value;
	}
	public function doesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		//No effect modifies this currently
		
		return value;
	}
	
	public function targetThis(source:Card, target:Character):Character
	{
		if (blessing.length > 0){ //blessing fizzles a negative magic effect
			if (source.cardType.positiveEffect() == false && source.cardType.magic() == true){
				source.fizzle();
				blessing.pop();
				blessingAnimation.play(owner, source.windupTime);
			}
		}
		
		if (curse.length > 0){ //curse fizzles a positive magic effect
			if (source.cardType.positiveEffect() == true && source.cardType.magic() == true){
				source.fizzle();
				curse.pop();
				curseAnimation.play(owner, source.windupTime);
			}
		}
		
		return target;
	}
}