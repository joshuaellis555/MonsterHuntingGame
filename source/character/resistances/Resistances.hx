package character.resistances;
import card.CardType;
import character.damage.DamageTypes;

/**
 * ...
 * @author ...
 */
class Resistances 
{
	private var resistanceMap:Map<DamageTypes,Int>;
	private var resistanceSets:Map<Int,Map<DamageTypes,Int>>;
	
	private var defaultMap:Map<DamageTypes,Int>;
	
	public function new(?resistances:Null<Array<Int>>=null)
	{
		resistanceMap = new Map<DamageTypes, Int>();
		resistanceSets = new Map<Int,Map<DamageTypes,Int>>();
		defaultMap = new Map<DamageTypes, Int>();
		if (resistances==null){
			for (key in Type.allEnums(DamageTypes)){
				resistanceMap[key] = 0;
				defaultMap[key] = 0;
			}
		}else{
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
	public function setDefault(type:DamageTypes, value:Int)
	{
		//trace('setDefault');
		resistanceMap[type] += value - defaultMap[type];
		defaultMap[type] = value;
	}
	public function add(sourceID:Int, resistances:Resistances)
	{
		//trace('add',sourceID);
		if (resistanceSets.exists(sourceID)) return;
		resistanceSets[sourceID] = resistances.getMap();
		for (key in Type.allEnums(DamageTypes))
			resistanceMap[key] += resistanceSets[sourceID][key];
	}
	public function remove(sourceID:Int)
	{
		for (key in Type.allEnums(DamageTypes))
			resistanceMap[key] -= resistanceSets[sourceID][key];
		resistanceSets.remove(sourceID);
	}
	public function getMap():Map<DamageTypes,Int>
	{
		return resistanceMap;
	}
	public function get(key:DamageTypes):Int
	{
		return resistanceMap[key];
	}
	public function retMultiply(multiplyer:Float):Resistances
	{
		var c:Resistances = this.copy();
		for (key in Type.allEnums(DamageTypes))
		{
			c.setDefault(key, Std.int(c.get(key) * multiplyer));
		}
		return c;
	}
	public function copy():Resistances
	{
		var c:Resistances = new Resistances();
		for (key in Type.allEnums(DamageTypes))
			c.setDefault(key, resistanceMap[key]);
		return c;
	}
	public function takesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
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