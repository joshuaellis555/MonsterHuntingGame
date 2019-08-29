package monsters.monster.gasBag;

import library.Characters;
import monsters.MonsterCharacter;
import character.damage.DamageTypes;
import utilities.plusInterface.PlusInterface;


/**
 * ...
 * @author Joshua Ellis
 */
class GasBag extends MonsterCharacter 
{

	public function new(owner:PlusInterface, ?x:Int = 0, ?y:Int = 0)
	{
		delayBaseTime = 1.0;
		delayRandomExtraTime = 3.0;
		
		super(owner, x, y, 109);
		
		strength(3);
		dexterity(2);
		endurace(3);
		constitution(4);
		resilience(4);
		intelligence(4);
		wisdom(2);
		willpower(4);
		insight(3);
		
		resistances.setDefault(DamageTypes.physical, -50);
		resistances.setDefault(DamageTypes.poison, 200);
		resistances.setDefault(DamageTypes.fire, -50);
		
		updateStats();
		
		/*
		defaultAction = new GasBagFloatAway(this);
		
		addCard(new GasBagPoisonCloud(this));
		addCard(new GasBagScratch(this));
		addCard(new GasBagNoxiousFumes(this));
		addCard(new GasBagFireBolt(this));
		//*/
	}
	
}