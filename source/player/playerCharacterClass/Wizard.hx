package player.playerCharacterClass;

import library.Characters;
import player.Player;
import player.PlayerCharacter;
import library.Library;

/**
 * ...
 * @author Joshua Ellis
 */
class Wizard extends PlayerCharacter 
{

	public function new(?x:Int = 0, ?y:Int = 0, owner:Player)
	{
		super(x, y, owner, 6);
		
		strength(2);
		dexterity(3);
		endurace(2);
		constitution(3);
		resilience(3);
		intelligence(5);
		wisdom(5);
		willpower(5);
		insight(3);
		
		updateStats();
		
		/*
		addCard(new MagicBolt(this));
		addCard(new LightGuard(this));
		addCard(new FireBolt(this));
		addCard(new VineLash(this));
		
		addCard(new HydroBlast(this));
		addCard(new Barrier(this));
		addCard(new GenerateMana(this));
		addCard(new Lightning(this));
		
		addCard(new NaturesBlessing(this));
		addCard(new PoisonCloud(this));
		addCard(new Guard(this));
		addCard(new Counterspell(this));
		
		addCard(new Earthquake(this));
		addCard(new Run(this));
		addCard(new GenerateMana(this));
		addCard(new SpellBlade(this));
		
		addCard(new IceBlast(this));
		//*/
	}
}