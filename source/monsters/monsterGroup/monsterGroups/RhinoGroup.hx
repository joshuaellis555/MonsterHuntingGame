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
class RhinoGroup extends MonsterGroup 
{

	public function new(source:PlusInterface) 
	{
		super(source);
		
		addMonster(new Rhino(this), 2);
		//addMonster(new SuperRhino(this), 3);
		//addMonster(new Rhino(this), 4);
	}
	
}