package character.stats;
import card.CardType;
import card.CardType;
import flixel.util.FlxColor;
import character.statusEffects.StatusTypes;
import character.damage.DamageTypes;
import character.stats.StatsEnum;

/**
 * ...
 * @author ...
 */
class Stats 
{
	private var statsMap:Map<StatsEnum,Float>; //Sum of statsSets and defaultMap
	
	private var statsSets:Map<Int,Map<StatsEnum,Float>>; //Added values from other sources
	
	private var defaultMap:Map<StatsEnum,Float>; //values inherent to this istance. Only the character should change these
	
	private var timers:Null<Map<StatsEnum,Float>>=null;
	private var rates:Map<StatsEnum,Float>;
	
	public function new(?stats:Null<Array<Float>>=null)
	{
		defaultMap = new Map<StatsEnum, Float>();
		statsMap = new Map<StatsEnum, Float>();
		statsSets = new Map<Int,Map<StatsEnum,Float>>();
		
		if (stats==null){ //load default values of 3 if no array supplied
			for (key in Type.allEnums(StatsEnum)){
				statsMap[key] = 0.0;
				defaultMap[key] = 0.0;
			}
		}else{ //else load values from array
			var i:Int = 0;
			for (key in Type.allEnums(StatsEnum)){
				if  (i < stats.length){
					statsMap[key] = stats[i];
					defaultMap[key] = stats[i];
				}else{
					statsMap[key] = 0;
					defaultMap[key] = 0;
				}
				i++;
			}
		}
	}
	public function setDefault(type:StatsEnum, value:Float) //modify the default value
	{
		statsMap[type] += value - defaultMap[type]; //update statsMap with the difference
		defaultMap[type] = value;
	}
	public function add(sourceID:Int, stats:Stats) //add a set of stats to this
	{
		//trace("add");
		if (statsSets.exists(sourceID)) return;
		statsSets[sourceID] = stats.getMap();
		for (key in Type.allEnums(StatsEnum))
			statsMap[key] += statsSets[sourceID][key];
	}
	public function update(sourceID:Int, stats:Stats) //update a previously added set of stats 
	{
		if (!statsSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(StatsEnum)){
			statsMap[key] -= statsSets[sourceID][key];
			statsMap[key] += stats.get(key);
		}
		statsSets[sourceID] = stats.getMap();
	}
	public function remove(sourceID:Int) //remove a stats set added from outside source
	{
		if (!statsSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(StatsEnum))
			statsMap[key] -= statsSets[sourceID][key];
		statsSets.remove(sourceID);
	}
	public function getMap():Map<StatsEnum,Float> //return statsMap
	{
		return statsMap;
	}
	public function get(type:StatsEnum):Float //get specific stats value
	{
		return statsMap[type];
	}
	public function takesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		// dmgResistance reduces all damage taken
		if (statsMap[StatsEnum.dmgResistance] > 0){
			value /= (1 + statsMap[StatsEnum.dmgResistance]);
		}else if (statsMap[StatsEnum.dmgResistance] < 0){
			value *= (1 - statsMap[StatsEnum.dmgResistance]);
		}
		return value;
	}
	public function doesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		//meleeDmg increases damage for all melee attacks
		if (cardType.melee()){
			if (statsMap[StatsEnum.meleeDmg] > 0){
				value *= (1 + statsMap[StatsEnum.meleeDmg]);
			}else if (statsMap[StatsEnum.meleeDmg] < 0){
				value /= (1 - statsMap[StatsEnum.meleeDmg]);
			}
		}
		// magicDmg increases damage for all spell attacks
		if (cardType.spell()){
			if (statsMap[StatsEnum.magicDmg] > 0){
				value *= (1 + statsMap[StatsEnum.magicDmg]);
			}else if (statsMap[StatsEnum.magicDmg] < 0){
				value /= (1 - statsMap[StatsEnum.magicDmg]);
			}
		}
		return value;
	}
}