package character.resistances;
import card.CardType;
import character.damage.DamageTypes;

/**
 * ...
 * @author ...
 */
class Resistances 
{
	private var resistanceMap:Map<DamageTypes,Int>; //Sum of resistanceSets and defaultMap
	
	private var resistanceSets:Map<Int,Map<DamageTypes,Int>>; //Added values from other sources
	
	private var defaultMap:Map<DamageTypes,Int>; //values inherent to this istance
	
	public function new(?resistances:Null<Array<Int>>=null)
	{
		resistanceMap = new Map<DamageTypes, Int>();
		resistanceSets = new Map<Int,Map<DamageTypes,Int>>();
		defaultMap = new Map<DamageTypes, Int>();
		
		if (resistances==null){ //if no values supplied, set all to 0
			for (key in Type.allEnums(DamageTypes)){
				resistanceMap[key] = 0;
				defaultMap[key] = 0;
			}
		}else{ //otherwise set defaultMap to resistances
			var i:Int = 0;
			for (key in Type.allEnums(DamageTypes)){
				if (i < resistances.length){
					resistanceMap[key] = resistances[i];
					defaultMap[key] = resistances[i];
				}else{
					resistanceMap[key] = 0;
					defaultMap[key] = 0;
				}
				i++;
			}
		}
	}
	public function setDefault(type:DamageTypes, value:Int) //change default value
	{
		resistanceMap[type] += value - defaultMap[type];
		defaultMap[type] = value;
	}
	public function add(sourceID:Int, resistances:Resistances) //add full set of resistances from external source
	{
		if (resistanceSets.exists(sourceID)) return;
		
		resistanceSets[sourceID] = resistances.getMap();
		for (key in Type.allEnums(DamageTypes))
			resistanceMap[key] += resistanceSets[sourceID][key];
	}
	public function remove(sourceID:Int) //remove set of resistances
	{
		if (!resistanceSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(DamageTypes))
			resistanceMap[key] -= resistanceSets[sourceID][key];
		resistanceSets.remove(sourceID);
	}
	public function update(sourceID:Int, resistances:Resistances) //update a previously added set of resistances 
	{
		if (!resistanceSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(DamageTypes)){
			resistanceMap[key] -= resistanceSets[sourceID][key];
			resistanceMap[key] += resistances.get(key);
		}
		resistanceSets[sourceID] = resistances.getMap();
	}
	public function getMap():Map<DamageTypes,Int> //get the map of damage resistances
	{
		return resistanceMap;
	}
	public function get(key:DamageTypes):Int //get a specific value by key
	{
		return resistanceMap[key];
	}
	public function retMultiply(multiplyer:Float):Resistances //return a copy of this where each value is multiplied by multiplyer
	{
		var c:Resistances = this.copy();
		for (key in Type.allEnums(DamageTypes))
		{
			c.setDefault(key, Std.int(c.get(key) * multiplyer));
		}
		return c;
	}
	public function copy():Resistances //return a copy of this
	{
		var c:Resistances = new Resistances();
		for (key in Type.allEnums(DamageTypes))
			c.setDefault(key, resistanceMap[key]);
		return c;
	}
	public function takesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float //called when a character is dealt damage
	{
		//trace(types);
		for (type in types){
			if (resistanceMap[type] > 0){
				value /= (1 + resistanceMap[type] / 100 / types.length);
			}else if (resistanceMap[type] < 0){
				value *= (1 - resistanceMap[type] / 100 / types.length);
			}
		}
		return value;
	}
}