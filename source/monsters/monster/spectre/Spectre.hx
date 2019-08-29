package monsters.monster.spectre;

import library.Characters;
import monsters.MonsterCharacter;
import character.damage.DamageTypes;
import utilities.plusInterface.PlusInterface;


/**
 * ...
 * @author Joshua Ellis
 */
class Spectre extends MonsterCharacter 
{

	public function new(owner:PlusInterface, ?x:Int = 0, ?y:Int = 0)
	{
		delayBaseTime = 1.5;
		delayRandomExtraTime = 2.0;
		
		super(owner, x, y, 92);
		
		strength(3);
		dexterity(2);
		endurace(3);
		constitution(4);
		resilience(3);
		intelligence(4);
		wisdom(4);
		willpower(5);
		insight(3);
		
		resistances.setDefault(DamageTypes.physical, 200);
		resistances.setDefault(DamageTypes.holy, -200);
		resistances.setDefault(DamageTypes.fire, -70);
		resistances.setDefault(DamageTypes.lightning, -70);
		
		updateStats();
		
		/*
		defaultAction = new SpectreGenerateMana(this);
		
		addCard(new SpectreMagicBolt(this));
		addCard(new SpectreCurse(this));
		addCard(new SpectreDarkness(this));
		addCard(new SpectreBarrier(this));
		addCard(new SpectreDarkness(this));
		addCard(new SpectreMagicBolt(this));
		addCard(new SpectreCurse(this));
		//*/
	}
	
}