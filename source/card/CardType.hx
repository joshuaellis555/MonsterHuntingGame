package card;

/**
 * ...
 * @author Joshua Ellis
 */
class CardType 
{
	private var Bmelee:Bool = false;
	private var Branged:Bool = false;
	private var Bspell:Bool = false;
	private var Bmagic:Bool = false;
	private var Bpiercing:Float = 0.0;
	private var BtrueDamage:Bool = false;
	private var Bcharge:Bool = false;
	private var BpositiveEffect:Bool = false;
	private var Bfinesse:Bool = false;
	private var BeffectsLiving:Bool = true;
	private var BeffectsDead:Bool = false;
	
	
	public function new(){}
	
	public function melee(?value:Null<Bool> = null):Bool{
		if (value != null) Bmelee = value;
		if (value == true) Branged = false;
		return Bmelee;
	}
	public function ranged(?value:Null<Bool> = null):Bool{
		if (value != null) Branged = value;
		if (value == true) Bmelee = false;
		return Branged;
	}
	public function spell(?value:Null<Bool> = null):Bool{
		if (value != null) Bspell = value;
		if (value == true){
			Bmagic = true;
			ranged(true);
		}
		return Bspell;
	}
	public function magic(?value:Null<Bool> = null):Bool{
		if (value != null) Bmagic = value;
		if (value == false) Bspell = false;
		return Bmagic;
	}
	public function piercing(?value:Null<Float> = null):Float{
		if (value != null) Bpiercing = Math.max(0.0, Math.min(1.0, value));
		return Bpiercing;
	}
	public function trueDamage(?value:Null<Bool> = null):Bool{
		if (value != null) BtrueDamage = value;
		return BtrueDamage;
	}
	public function charge(?value:Null<Bool> = null):Bool{
		if (value != null) Bcharge = value;
		return Bcharge;
	}
	public function positiveEffect(?value:Null<Bool> = null):Bool{
		if (value != null) BpositiveEffect = value;
		return BpositiveEffect;
	}
	public function finesse(?value:Null<Bool> = null):Bool{
		if (value != null) Bfinesse = value;
		return Bfinesse;
	}
	public function effectsLiving(?value:Null<Bool> = null):Bool{
		if (value != null) BeffectsLiving = value;
		return BeffectsLiving;
	}
	public function effectsDead(?value:Null<Bool> = null):Bool{
		if (value != null) BeffectsDead = value;
		return BeffectsDead;
	}
}