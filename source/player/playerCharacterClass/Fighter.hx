package player.playerCharacterClass;

import player.playerCards.blue.FireBolt;
import player.playerCards.green.ThrowingKnife;
import player.playerCards.red.Attack;
import player.playerCards.red.Charge;
import player.playerCards.red.CounterAttack;
import player.playerCards.red.GuardBreaker;
import player.playerCards.red.HeadFirst;
import player.playerCards.red.Parry;
import player.playerCards.red.QuickAttack;
import player.playerCards.red.StrongAttack;
import player.playerCards.redGreen.PoisonKnife;
import player.playerCards.redYellow.FallBack;
import player.playerCards.yellow.Guard;
import player.playerCards.yellow.Rest;
import library.Characters;
import player.Player;
import player.PlayerCharacter;

/**
 * ...
 * @author Joshua Ellis
 */
class Fighter extends PlayerCharacter 
{

	public function new(?x:Int = 0, ?y:Int = 0, owner:Player)
	{
		super(x, y, owner, 3);
		
		strength(5);
		dexterity(3);
		endurace(4);
		constitution(4);
		resilience(4);
		intelligence(3);
		wisdom(3);
		willpower(3);
		insight(3);
		
		updateStats();
		
		//*
		addCard(new Attack(this));
		addCard(new Guard(this));
		addCard(new Rest(this));
		addCard(new Charge(this));
		
		addCard(new ThrowingKnife(this));
		addCard(new StrongAttack(this));
		addCard(new Guard(this));
		addCard(new HeadFirst(this));
		
		addCard(new CounterAttack(this));
		addCard(new Rest(this));
		addCard(new FallBack(this));
		addCard(new GuardBreaker(this));
		
		addCard(new QuickAttack(this));
		addCard(new FireBolt(this));
		addCard(new Parry(this));
		addCard(new PoisonKnife(this));
		
		addCard(new Attack(this));
		//*/
	}
}