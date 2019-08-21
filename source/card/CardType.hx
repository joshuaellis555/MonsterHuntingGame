package card;

/**
 * ...
 * @author Joshua Ellis
 */
class CardType 
{
	private var _melee:Bool = false;
	private var _ranged:Bool = false;
	private var _spell:Bool = false;
	private var _magic:Bool = false;
	private var _piercing:Float = 0.0;
	private var _trueDamage:Bool = false;
	private var _charge:Bool = false;
	private var _positiveEffect:Bool = false;
	private var _finesse:Bool = false;
	private var _effectsLiving:Bool = true;
	private var _effectsDead:Bool = false;
	
	
	public function new(){}
	
	public function melee(?value:Null<Bool> = null):Bool{ //can NOT hit distanced or flying targets
		if (value == null) return _melee;
		
		_melee = value;
		if (value == true) _ranged = false; //excludes ranged
		return _melee;
	}
	public function ranged(?value:Null<Bool> = null):Bool{ //CAN hit distanced or flying targets
		if (value == null) return _ranged;
		
		_ranged = value;
		if (value == true) _melee = false; // excludes ranged
		return _ranged;
	}
	public function spell(?value:Null<Bool> = null):Bool{ //is a spell
		if (value == null) return _spell;
		
		_spell = value;
		if (value == true){
			_magic = true; //spells are all magic
			ranged(true); //spells are normally ranged (but can still be set to melee)
		}
		return _spell;
	}
	public function magic(?value:Null<Bool> = null):Bool{ // is magic
		if (value == null) return _magic;
		
		_magic = value; //spells must be magic
		if (value == false) _spell = false;
		return _magic;
	}
	public function piercing(?value:Null<Float> = null):Float{ //amount of piercing (from 0 to 1) (bypasses guard)
		if (value == null) return _piercing;
		
		_piercing = Math.max(0.0, Math.min(1.0, value));
		return _piercing;
	}
	public function trueDamage(?value:Null<Bool> = null):Bool{ //true damage (functions like piercing = 1.0, should probably change)
		if (value == null) return _trueDamage;
		
		_trueDamage = value;
		return _trueDamage;
	}
	public function charge(?value:Null<Bool> = null):Bool{ //charge attacks are melee attacks that can hit distanced targets
		if (value == null) return _charge;
		
		_charge = value;
		return _charge;
	}
	public function positiveEffect(?value:Null<Bool> = null):Bool{ //is a positive effect
		if (value == null) return _positiveEffect;
		
		_positiveEffect = value;
		return _positiveEffect;
	}
	public function finesse(?value:Null<Bool> = null):Bool{ //not used, ToDo: remove
		if (value == null) return _finesse;
		
		_finesse = value;
		return _finesse;
	}
	public function effectsLiving(?value:Null<Bool> = null):Bool{ //effects living targets, not implemented
		if (value == null) return _effectsLiving;
		
		_effectsLiving = value;
		return _effectsLiving;
	}
	public function effectsDead(?value:Null<Bool> = null):Bool{ //effects dead targets, not implemented
		if (value == null) return _effectsDead;
		
		_effectsDead = value;
		return _effectsDead;
	}
}