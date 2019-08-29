package monsters.monster.rhino;

import library.Characters;
import monsters.MonsterCharacter;
import character.damage.DamageTypes;
import player.playerCards.Attack;
import utilities.plusInterface.PlusInterface;

/**
 * ...
 * @author Joshua Ellis
 */
class Rhino extends MonsterCharacter 
{

	public function new(owner:PlusInterface, ?x:Int = 0, ?y:Int = 0)
	{
		delayBaseTime = 1.0;
		delayRandomExtraTime = 2.0;
		
		super(owner, x, y, 110);
		
		strength(3);
		dexterity(2);
		endurace(3);
		constitution(4);// 4);
		resilience(5);
		intelligence(3);
		wisdom(3);
		willpower(3);
		insight(3);
		
		resistances.setDefault(DamageTypes.earth, 100);
		resistances.setDefault(DamageTypes.water, -100);
		resistances.setDefault(DamageTypes.poison, -100);
		
		updateStats();
		
		//defaultAction = new RhinoRest(this);
		
		/*
		addCard(new RhinoGuard(this));
		addCard(new RhinoCharge(this));
		addCard(new RhinoAttack(this));
		addCard(new RhinoBackUp(this));
		addCard(new RhinoBash(this));
		addCard(new RhinoAttack(this));
		addCard(new RhinoBash(this));
		addCard(new RhinoCharge(this));
		//*/
		
	}
	
}