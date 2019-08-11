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
	private var defaultMap:Map<StatsEnum,Float>;
	private var statsMap:Map<StatsEnum,Float>;
	private var statsSets:Map<Int,Map<StatsEnum,Float>>;
	private var timers:Null<Map<StatsEnum,Float>>=null;
	private var rates:Map<StatsEnum,Float>;
	
	public function new(?stats:Null<Array<Float>>=null)
	{
		//trace("new");
		defaultMap = new Map<StatsEnum, Float>();
		statsMap = new Map<StatsEnum, Float>();
		statsSets = new Map<Int,Map<StatsEnum,Float>>();
		if (stats==null){
			for (key in Type.allEnums(StatsEnum)){
				statsMap[key] = 0.0;
				defaultMap[key] = 0.0;
			}
		}else{
			//trace("else");
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
	public function setDefault(type:StatsEnum, value:Float)
	{
		//trace('setDefault');
		statsMap[type] += value - defaultMap[type];
		defaultMap[type] = value;
	}
	public function add(sourceID:Int, stats:Stats)
	{
		//trace("add");
		if (statsSets.exists(sourceID)) return;
		statsSets[sourceID] = stats.getMap();
		for (key in Type.allEnums(StatsEnum))
			statsMap[key] += statsSets[sourceID][key];
	}
	public function update(sourceID:Int, stats:Stats)
	{
		if (!statsSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(StatsEnum)){
			statsMap[key] -= statsSets[sourceID][key];
			statsMap[key] += stats.get(key);
		}
		statsSets[sourceID] = stats.getMap();
	}
	public function remove(sourceID:Int)
	{
		for (key in Type.allEnums(StatsEnum))
			statsMap[key] -= statsSets[sourceID][key];
		statsSets.remove(sourceID);
	}
	public function getMap():Map<StatsEnum,Float>
	{
		return statsMap;
	}
	public function get(type:StatsEnum):Float
	{
		return statsMap[type];
	}
	public function takesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		//trace(value);
		if (statsMap[StatsEnum.dmgResistance] > 0){
			value /= (1 + statsMap[StatsEnum.dmgResistance]);
		}else if (statsMap[StatsEnum.dmgResistance] < 0){
			value *= (1 - statsMap[StatsEnum.dmgResistance]);
		}
		return value;
	}
	public function doesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		//trace(value);
		if (cardType.melee()){
			if (statsMap[StatsEnum.bonusDmg] > 0){
				value *= (1 + statsMap[StatsEnum.bonusDmg]);
			}else if (statsMap[StatsEnum.bonusDmg] < 0){
				value /= (1 - statsMap[StatsEnum.bonusDmg]);
			}
		}
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