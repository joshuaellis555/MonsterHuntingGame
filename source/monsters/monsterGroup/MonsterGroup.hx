package monsters.monsterGroup;

import monsters.MonsterCharacter;
import team.Team;
import utilities.plusInterface.PlusInterface;
import utilities.plusInterface.SpritePlusTracker;

/**
 * ...
 * @author Joshua Ellis
 */
class MonsterGroup extends SpritePlusTracker 
{
	private var monsters:Array<MonsterCharacter> = [];
	public function new(source:PlusInterface) 
	{
		super(source);
	}
	public function addMonster(monster:MonsterCharacter, position:Float)
	{
		addItem(monster);
		monsters.push(monster);
		monster.positionX = 1920 / 6 * (6 - position) - monster.width / 2;
		monster.positionY = 200;
	}
	public function setTeam(team:Team)
	{
		for (s in this.array()){
			var monster:MonsterCharacter = cast s;
			monster.setTeam(team);
		}	
	}
	public function dead():Bool
	{
		for (monster in monsters){
			if (monster.alive)
				return false;
		}	
		return true;
	}
}