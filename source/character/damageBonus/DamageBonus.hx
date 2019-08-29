package character.damageBonus;
import card.CardType;
import flixel.util.FlxColor;
import character.damage.DamageTypes;

/**
 * ...
 * @author ...
 */
class DamageBonus
{
	private var bonusMap:Map<DamageTypes,Int>; //Sum of bonusSets and defaultMap
	
	private var bonusSets:Map<Int,Map<DamageTypes,Int>>; //Added values from other sources
	
	private var defaultMap:Map<DamageTypes,Int>; //values inherent to this istance
	
	public function new(?bonuses:Null<Array<Int>>=null)
	{
		bonusMap = new Map<DamageTypes, Int>();
		bonusSets = new Map<Int,Map<DamageTypes,Int>>();
		defaultMap = new Map<DamageTypes, Int>();
		
		if (bonuses==null){ //if no values supplied, set all to 0
			for (key in Type.allEnums(DamageTypes)){
				bonusMap[key] = 0;
				defaultMap[key] = 0;
			}
		}else{ //otherwise set defaultMap to bonuses
			var i:Int = 0;
			for (key in Type.allEnums(DamageTypes)){
				if (i < bonuses.length){
					bonusMap[key] = bonuses[i];
					defaultMap[key] = bonuses[i];
				}else{
					bonusMap[key] = 0;
					defaultMap[key] = 0;
				}
				i++;
			}
		}
	}
	public function setDefault(type:DamageTypes, value:Int) //change default value
	{
		//trace('setDefault');
		bonusMap[type] += value - defaultMap[type];
		defaultMap[type] = value;
	}
	public function add(sourceID:Int, bonuses:DamageBonus) //add full set of bonuses from external source
	{
		if (bonusSets.exists(sourceID)) return;
		bonusSets[sourceID] = bonuses.getMap();
		for (key in Type.allEnums(DamageTypes))
			bonusMap[key] += bonusSets[sourceID][key];
	}
	public function remove(sourceID:Int) //remove set of bonuses
	{
		if (!bonusSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(DamageTypes))
			bonusMap[key] -= bonusSets[sourceID][key];
		bonusSets.remove(sourceID);
	}
	public function update(sourceID:Int, bonuses:DamageBonus) //update a previously added set of bonuses 
	{
		if (!bonusSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(DamageTypes)){
			bonusMap[key] -= bonusSets[sourceID][key];
			bonusMap[key] += bonuses.get(key);
		}
		bonusSets[sourceID] = bonuses.getMap();
	}
	public function getMap():Map<DamageTypes,Int> //get the map of damage bonuses
	{
		return bonusMap;
	}
	public function get(key:DamageTypes):Int //get a specific value by key
	{
		return bonusMap[key];
	}
	public function retMultiply(multiplyer:Float):DamageBonus //return a copy of this where each value is multiplied by multiplyer
	{
		var c:DamageBonus = this.copy();
		for (key in Type.allEnums(DamageTypes))
		{
			c.setDefault(key, Std.int(c.get(key) * multiplyer));
		}
		return c;
	}
	public function copy():DamageBonus //return a copy of this
	{
		var c:DamageBonus = new DamageBonus();
		for (key in Type.allEnums(DamageTypes))
			c.setDefault(key, bonusMap[key]);
		return c;
	}
	public function doesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float //called when a character does damage
	{
		//trace(value);
		for (type in Type.allEnums(DamageTypes)){
			if (bonusMap[type] > 0){
				value *= (1 + bonusMap[type] / 100 / types.length);
			}else if (bonusMap[type] < 0){
				value /= (1 - bonusMap[type] / 100 / types.length);
			}
		}
		return value;
	}
}