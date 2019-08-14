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
	
	public function melee(?value:Null<Bool> = null):Bool{
		if (value == null) return _melee;
		
		_melee = value;
		if (value == true) _ranged = false;
		return _melee;
	}
	public function ranged(?value:Null<Bool> = null):Bool{
		if (value == null) return _ranged;
		
		_ranged = value;
		if (value == true) _melee = false;
		return _ranged;
	}
	public function spell(?value:Null<Bool> = null):Bool{
		if (value == null) return _spell;
		
		_spell = value;
		if (value == true){
			_magic = true;
			ranged(true);
		}
		return _spell;
	}
	public function magic(?value:Null<Bool> = null):Bool{
		if (value == null) return _magic;
		
		_magic = value;
		if (value == false) _spell = false;
		return _magic;
	}
	public function piercing(?value:Null<Float> = null):Float{
		if (value == null) return _piercing;
		
		_piercing = Math.max(0.0, Math.min(1.0, value));
		return _piercing;
	}
	public function trueDamage(?value:Null<Bool> = null):Bool{
		if (value == null) return _trueDamage;
		
		_trueDamage = value;
		return _trueDamage;
	}
	public function charge(?value:Null<Bool> = null):Bool{
		if (value == null) return _charge;
		
		_charge = value;
		return _charge;
	}
	public function positiveEffect(?value:Null<Bool> = null):Bool{
		if (value == null) return _positiveEffect;
		
		_positiveEffect = value;
		return _positiveEffect;
	}
	public function finesse(?value:Null<Bool> = null):Bool{
		if (value == null) return _finesse;
		
		_finesse = value;
		return _finesse;
	}
	public function effectsLiving(?value:Null<Bool> = null):Bool{
		if (value == null) return _effectsLiving;
		
		_effectsLiving = value;
		return _effectsLiving;
	}
	public function effectsDead(?value:Null<Bool> = null):Bool{
		if (value == null) return _effectsDead;
		
		_effectsDead = value;
		return _effectsDead;
	}
}