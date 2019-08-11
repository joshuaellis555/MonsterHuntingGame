package player.playerCharacterClass;

import player.playerCards.blue.GenerateMana;
import player.playerCards.blueYellow.Barrier;
import player.playerCards.blueYellow.Heal;
import player.playerCards.red.Attack;
import player.playerCards.red.GuardBreaker;
import player.playerCards.red.Parry;
import player.playerCards.red.StrongAttack;
import player.playerCards.white.GreaterBlessing;
import player.playerCards.white.GreaterHeal;
import player.playerCards.white.Holy;
import player.playerCards.white.Revive;
import player.playerCards.yellow.Defend;
import player.playerCards.yellow.Guard;
import player.playerCards.yellow.HeavyGuard;
import player.playerCards.yellow.Rest;
import library.Characters;
import player.Player;
import player.PlayerCharacter;

/**
 * ...
 * @author Joshua Ellis
 */
class Paladin extends PlayerCharacter 
{

	public function new(?x:Int = 0, ?y:Int = 0, owner:Player)
	{
		super(x, y, owner, 24);
		
		strength(4);
		dexterity(3);
		endurace(3);
		constitution(5);
		resilience(5);
		intelligence(3);
		wisdom(3);
		willpower(3);
		insight(3);
		
		updateStats();
		
		addCard(new Attack(this));
		addCard(new Guard(this));
		addCard(new Defend(this));
		addCard(new Rest(this));
		
		addCard(new StrongAttack(this));
		addCard(new Heal(this));
		addCard(new Defend(this));
		addCard(new GuardBreaker(this));
		
		addCard(new GreaterBlessing(this));
		addCard(new HeavyGuard(this));
		addCard(new Rest(this));
		addCard(new Attack(this));
		
		addCard(new GreaterHeal(this));
		addCard(new GenerateMana(this));
		addCard(new Holy(this));
		addCard(new Revive(this));
		
		addCard(new Barrier(this));
		
		
		
	}
	
}