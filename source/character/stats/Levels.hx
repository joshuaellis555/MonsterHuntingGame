package character.stats;
import flixel.util.FlxColor;
import character.statusEffects.StatusTypes;
import character.damage.DamageTypes;
import character.stats.LevelsEnum;

/**
 * ...
 * @author ...
 */
class Levels 
{
	private var defaultMap:Map<LevelsEnum,Int>;
	private var levelsMap:Map<LevelsEnum,Int>;
	private var levelsSets:Map<Int,Map<LevelsEnum,Int>>;
	
	public function new(?levels:Null<Array<Int>>=null)
	{
		//trace("new");
		defaultMap = new Map<LevelsEnum, Int>();
		levelsMap = new Map<LevelsEnum, Int>();
		levelsSets = new Map<Int,Map<LevelsEnum,Int>>();
		if (levels==null){
			for (key in Type.allEnums(LevelsEnum)){
				levelsMap[key] = 3;
				defaultMap[key] = 3;
			}
		}else{
			//trace("else");
			var i:Int = 0;
			for (key in Type.allEnums(LevelsEnum)){
				if  (i < levels.length){
					levelsMap[key] = levels[i];
					defaultMap[key] = levels[i];
				}else{
					levelsMap[key] = 3;
					defaultMap[key] = 3;
				}
				i++;
			}
		}
		
	}
	public function setDefault(type:LevelsEnum, value:Int)
	{
		levelsMap[type] += value - defaultMap[type];
		defaultMap[type] = value;
	}
	public function add(sourceID:Int, levels:Levels)
	{
		//trace("add");
		if (levelsSets.exists(sourceID)) return;
		levelsSets[sourceID] = levels.getMap();
		for (key in Type.allEnums(LevelsEnum))
			levelsMap[key] += levelsSets[sourceID][key];
	}
	public function update(sourceID:Int, levels:Levels)
	{
		if (!levelsSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(LevelsEnum)){
			levelsMap[key] -= levelsSets[sourceID][key];
			levelsMap[key] += levels.get(key);
		}
		levelsSets[sourceID] = levels.getMap();
	}
	public function remove(sourceID:Int)
	{
		for (key in Type.allEnums(LevelsEnum))
			levelsMap[key] -= levelsSets[sourceID][key];
		levelsSets.remove(sourceID);
	}
	public function getMap():Map<LevelsEnum,Int>
	{
		return levelsMap;
	}
	public function get(type:LevelsEnum):Int
	{
		return levelsMap[type];
	}
}