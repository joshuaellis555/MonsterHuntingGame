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
	
	private var levelsMap:Map<LevelsEnum,Int>; //Sum of levelsSets and defaultMap
	
	private var levelsSets:Map<Int,Map<LevelsEnum,Int>>; //Added values from other sources
	
	private var defaultMap:Map<LevelsEnum,Int>; //values inherent to this istance. Only the character should change these
	
	public function new(?levels:Null<Array<Int>>=null)
	{
		defaultMap = new Map<LevelsEnum, Int>();
		levelsMap = new Map<LevelsEnum, Int>();
		levelsSets = new Map<Int,Map<LevelsEnum,Int>>();
		
		if (levels==null){ //load default values of 3 if no array supplied
			for (key in Type.allEnums(LevelsEnum)){
				levelsMap[key] = 3;
				defaultMap[key] = 3;
			}
		}else{ //else load values from array
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
	public function setDefault(type:LevelsEnum, value:Int) //modify the default value
	{
		levelsMap[type] += value - defaultMap[type]; //modify the default value
		defaultMap[type] = value;
	}
	public function add(sourceID:Int, levels:Levels) //add a set of levels to this
	{
		if (levelsSets.exists(sourceID)) return;
		
		levelsSets[sourceID] = levels.getMap();
		for (key in Type.allEnums(LevelsEnum))
			levelsMap[key] += levelsSets[sourceID][key];
	}
	public function update(sourceID:Int, levels:Levels) //update a previously added set of levels 
	{
		if (!levelsSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(LevelsEnum)){
			levelsMap[key] -= levelsSets[sourceID][key];
			levelsMap[key] += levels.get(key);
		}
		levelsSets[sourceID] = levels.getMap();
	}
	public function remove(sourceID:Int) //remove a level set added from outside source
	{
		if (!levelsSets.exists(sourceID)) return;
		
		for (key in Type.allEnums(LevelsEnum))
			levelsMap[key] -= levelsSets[sourceID][key];
		levelsSets.remove(sourceID);
	}
	public function getMap():Map<LevelsEnum,Int> //return levelsMap
	{
		return levelsMap;
	}
	public function get(type:LevelsEnum):Int //get specific levels value
	{
		return levelsMap[type];
	}
}