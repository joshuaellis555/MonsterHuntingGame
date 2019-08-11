package monsters.monster.superRhino;

import library.Characters;
import monsters.MonsterCharacter;
import character.damage.DamageTypes;
import monsters.monster.superRhino.cards.SuperRhinoAttack;
import monsters.monster.superRhino.cards.SuperRhinoBackUp.RhinoBackUp;
import monsters.monster.superRhino.cards.SuperRhinoBash;
import monsters.monster.superRhino.cards.SuperRhinoCharge;
import monsters.monster.superRhino.cards.SuperRhinoEarthquake;
import monsters.monster.superRhino.cards.SuperRhinoRest;
import monsters.monster.superRhino.cards.SuperRhinoGuard;
import utilities.plusInterface.PlusInterface;

/**
 * ...
 * @author Joshua Ellis
 */
class SuperRhino extends MonsterCharacter 
{

	public function new(owner:PlusInterface, ?x:Int = 0, ?y:Int = 0)
	{
		delayBaseTime = 1.0;
		delayRandomExtraTime = 1.0;
		
		super(owner, x, y, 111);
		
		strength(4);
		dexterity(3);
		endurace(3);
		constitution(6);
		resilience(5);
		intelligence(3);
		wisdom(3);
		willpower(3);
		insight(3);
		
		resistances.setDefault(DamageTypes.earth, 100);
		resistances.setDefault(DamageTypes.water, -100);
		resistances.setDefault(DamageTypes.poison, -100);
		
		updateStats();
		
		defaultAction = new SuperRhinoRest(this);
		
		addCard(new SuperRhinoGuard(this));
		addCard(new SuperRhinoAttack(this));
		addCard(new SuperRhinoBash(this));
		addCard(new SuperRhinoEarthquake(this));
		addCard(new RhinoBackUp(this));
		addCard(new SuperRhinoBash(this));
		addCard(new SuperRhinoAttack(this));
		addCard(new SuperRhinoEarthquake(this));
		addCard(new SuperRhinoCharge(this));
		addCard(new SuperRhinoGuard(this));
	}
	
}