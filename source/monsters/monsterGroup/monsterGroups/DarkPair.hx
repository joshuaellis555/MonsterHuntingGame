package monsters.monsterGroup.monsterGroups;

import monsters.monsterGroup.MonsterGroup;
import monsters.monster.rhino.Rhino;
import monsters.monster.gasBag.GasBag;
import monsters.monster.spectre.Spectre;
import monsters.monster.superRhino.SuperRhino;
import utilities.plusInterface.PlusInterface;

/**
 * ...
 * @author Joshua Ellis
 */
class DarkPair extends MonsterGroup 
{

	public function new(source:PlusInterface) 
	{
		super(source);
		
		addMonster(new Spectre(this), 2.2);
		addMonster(new GasBag(this), 3.8);
	}
	
}