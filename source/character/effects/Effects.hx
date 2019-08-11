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
	
	public var venomCount:Int = 0;
	public var venomTime:Float = 0.0;
	public var venomTick:Float = 0.0;
	public var venomPadding:Float = 0.0;
	private var venomCT:CardType;
	
	public var comboCount:Int = 0;
	public var comboCountdown:Float = 0.0;
	
	public var guard:Array<Guard> = [];
	public var defender:Array<Defender> = [];
	
	public var blessing:Array<Float> = [];
	private var blessingAnimation:Animation;
	
	public var curse:Array<Float> = [];
	private var curseAnimation:Animation;
	
	public var barrier:Float = 0.0;
	public var barrierCountdown:Float = 0.0;
	
	public function new(owner:Character) 
	{
		super(owner);
		this.owner = owner;
		
		venomCT = new CardType();
		venomCT.trueDamage(true);
		
		owner.addItem(blessingAnimation = new Animation(owner,AssetPaths.DeProtect_20__png, 0xffaabbff, 192, 192, 25, 1));
		owner.addItem(curseAnimation = new Animation(owner, AssetPaths.DeProtect_20__png, 0xff550044, 192, 192, 25, 1));
		
		forceUpdate = true;
	}
	
	public function addVenom(time:Float, ?count:Int = 1)
	{
		venomCount += count;
		venomTime = Math.max(time+1-venomTick, venomTime);
		
		if (venomCount > 1)
			owner.damageNumbers.addNumber('Poisoned ' + Std.string(Std.int(time)) + 's x' + Std.string(venomCount), Library.damageColors.get(DamageTypes.poison));
		else
			owner.damageNumbers.addNumber('Poisoned ' + Std.string(Std.int(time)) + 's', Library.damageColors.get(DamageTypes.poison));
	}
	
	public function addCombo(?count:Int = 1)
	{
		if (comboCount < owner.dexterity() + 1)
			comboCount += 1;
		owner.damageNumbers.addNumber('COMBO x'+Std.string(Std.int(comboCount)), FlxColor.GREEN);
		comboCountdown = 3.0;
	}
	public function Combo():Int
	{
		var tmp:Int = comboCount;
		comboCount = 0;
		return tmp;
	}
	
	public function addGuard(value:Int, time:Float)
	{
		guard.push(new Guard(value, time));
		owner.damageNumbers.addNumber('Guard ' + Std.string(value), FlxColor.GREEN);
	}
	public function removeGuard(value:Int)
	{
		var _maxGuard:Int = maxGuard();
		if (_maxGuard == 0) return;
		_maxGuard -= value;
		if (_maxGuard <= 0){
			guard = [];
			owner.damageNumbers.addNumber('Guard Down', FlxColor.RED);
		}else{
			for (g in guard){
				if (g.value > _maxGuard)
					g.value = _maxGuard;
			}
		}
	}
	public function maxGuard():Int
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
		defender.push(new Defender(returnFunction, source, time));
	}
	
	public function addBlessing(time:Float, ?count:Int = 1)
	{
		for (i in 0...count)
			blessing.push(time);
	}
	
	public function addCurse(time:Float, ?count:Int = 1)
	{
		for (i in 0...count)
			curse.push(time);
	}
	
	public function addBarrier(value:Int, time:Float)
	{
		if (barrier < value) barrier = value;
		if (barrierCountdown < time) barrierCountdown = time;
	}
	
	override public function plusUpdate(elapsed:Float)
	{
		super.plusUpdate(elapsed);
		
		if (venomTime > 0) venomTick += elapsed;
		venomTime -= elapsed;
		if (venomTick >= 1.0){
			owner.takesDamage([DamageTypes.poison], venomCount, venomCT);
			venomTick -= 1.0;
			venomPadding = 1.0;
		}
		if (venomTime <= 0.0){
			venomTime = 0.0;
			venomTick = 0.0;
			if (venomPadding <= 0.0) venomCount = 0;
		}

		
		comboCountdown -= elapsed;
		if (comboCountdown <= 0.0){
			comboCountdown += 3.0;
			if (comboCount > 0)
				comboCount -= 1;
		}
		
		var numRemoved:Int = 0;
		for (i in 0...(defender.length)){
			defender[i - numRemoved].time-= elapsed;
			if (defender[i - numRemoved].time <= 0.0){
				defender.remove(defender[i - numRemoved]);
				numRemoved += 1;
				owner.damageNumbers.addNumber('Defender Ends', FlxColor.RED);
			}
		}
		
		if (guard.length > 0){
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
		
		numRemoved = 0;
		for (i in 0...(blessing.length)){
			blessing[i - numRemoved]-= elapsed;
			if (blessing[i - numRemoved] <= 0.0){
				blessing.remove(blessing[i - numRemoved]);
				numRemoved += 1;
			}
		}
		
		numRemoved = 0;
		for (i in 0...(curse.length)){
			curse[i - numRemoved]-= elapsed;
			if (curse[i - numRemoved] <= 0.0){
				curse.remove(curse[i - numRemoved]);
				numRemoved += 1;
			}
		}
		
		barrierCountdown -= elapsed;
		if (barrierCountdown <= 0.0){
			barrier = 0;
		}
	}
	
	public function takesDamage1(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		for (i in 0...defender.length){
			var j:Int = defender.length - i - 1;
			var newValue:Float = defender[j].returnFunction(types, value, cardType, source);
			if (newValue < value){
				value = newValue;
				owner.damageNumbers.addNumber('Defended', Library.cardColors.get(CardFamily.Yellow));
				defender[j].source.damageNumbers.addNumber('Defend', Library.cardColors.get(CardFamily.Yellow));
			}
		}
		
		if (barrier > 0){
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
		var _maxGuard:Int = maxGuard();
		
		if (_maxGuard == 0 || cardType.piercing() >= 1.0 || cardType.trueDamage()) return value;
		
		var damagePrevented:Int = Math.round(Math.max(Math.min(value-value / (_maxGuard / 20 + 1), _maxGuard), 1));
		damagePrevented = Std.int(damagePrevented * (1 - cardType.piercing()));
		value -= damagePrevented;
		
		removeGuard(damagePrevented);
		
		return value;
	}
	public function doesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{		
		return value;
	}
	
	public function targetThis(source:Card, target:Character):Character
	{
		if (blessing.length > 0){
			if (source.cardType.positiveEffect() == false && source.cardType.magic() == true){
				source.fizzle();
				blessing.pop();
				blessingAnimation.play(owner, source.windupTime);
			}
		}
		
		if (curse.length > 0){
			if (source.cardType.positiveEffect() == true && source.cardType.magic() == true){
				source.fizzle();
				curse.pop();
				curseAnimation.play(owner, source.windupTime);
			}
		}
		
		return target;
	}
}