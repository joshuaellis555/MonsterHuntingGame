package library;
import flixel.util.FlxColor;
import character.damage.DamageTypes;
import character.resistances.Resistances;

/**
 * @author ...
 */

class ElementalResistances
{														                    
	public var physical:Resistances;
	public var magic:Resistances;
	public var fire:Resistances;
	public var cold:Resistances;
	public var water:Resistances;
	public var earth:Resistances;
	public var poison:Resistances;
	public var lightning:Resistances;
	public var holy:Resistances;
	public var dark:Resistances;
	public var psychic:Resistances;
	
	public function new()
	{							  //[phy, mag, fir, cld, wat, ear, nat, poi, lit, hol, drk, psy]
		physical = new Resistances ([  0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0]);
		magic = new Resistances    ([-10,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0, -10]);
		fire = new Resistances     ([  0,   0,  10, -10, -10,   0,   0,  10,  10,   0,   0,   0]);
		cold = new Resistances     ([  0,   0, -10,  10,   0,   0,   0,   0,   0,   0,   0,   0]);
		water = new Resistances    ([  0,   0,  10,   0,   0, -10,   0, -20,   0,   0,   0,   0]);
		earth = new Resistances    ([  0,   0,  10,  10, -10,   0,   0,  -5,  10,   0,   0,   0]);
		poison = new Resistances   ([  0,   0,   0,   0,   0,   0,   0,  20,   0,   0,   0,   0]);
		lightning = new Resistances([  0,   0,   0,   0,   0,   0,   0,  10,  10,   0,   0,   0]);
		holy = new Resistances     ([  0,  10,  10,  10,  10,  10,  10,  10,  10,  20, -20,  10]);
		dark = new Resistances     ([  0,   0, -10,   0,   0,   0,   0,   0,  -5, -35,   0,   0]);
		psychic = new Resistances  ([  0, -10,   0,   0,   0,   0,   0,   0,   0,   0,   0,  10]);
	}
	
	public function get(type:DamageTypes):Resistances{
		switch (type){
			case DamageTypes.physical:{
				return physical;
			}case DamageTypes.magic:{
				return magic;
			}case DamageTypes.fire:{
				return fire;
			}case DamageTypes.cold:{
				return cold;
			}case DamageTypes.water:{
				return water;
			}case DamageTypes.earth:{
				return earth;
			}case DamageTypes.poison:{
				return poison;
			}case DamageTypes.lightning:{
				return lightning;
			}case DamageTypes.holy:{
				return holy;
			}case DamageTypes.dark:{
				return dark;
			}case DamageTypes.psychic:{
				return psychic;
			}default:return new Resistances();
		}
	}
	
}//[physical, magic, fire, cold, water, earth, poison, lightning, holy, dark]