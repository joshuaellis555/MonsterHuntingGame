package player.playerCharacterClass;

import player.playerCards.green.ActionSurge;
import player.playerCards.blueYellow.Heal;
import player.playerCards.green.ChaseDown;
import player.playerCards.green.Finisher;
import player.playerCards.green.PoisonDart;
import player.playerCards.green.QuickAttack;
import player.playerCards.green.ThrowingKnife;
import player.playerCards.greenYellow.TakeCover;
import player.playerCards.red.QuickAttack;
import player.playerCards.green.TwinSlash;
import player.playerCards.red.Attack;
import player.playerCards.redGreen.PoisonKnife;
import player.playerCards.yellow.Guard;
import player.playerCards.yellow.LightGuard;
import player.playerCards.yellow.Rest;
import library.Characters;
import player.Player;
import player.PlayerCharacter;

/**
 * ...
 * @author Joshua Ellis
 */
class Ranger extends PlayerCharacter 
{

	public function new(?x:Int = 0, ?y:Int = 0, owner:Player)
	{
		super(x, y, owner, 0);
		
		strength(4);
		dexterity(5);
		endurace(4);
		constitution(4);
		resilience(3);
		intelligence(4);
		wisdom(3);
		willpower(3);
		insight(3);
		
		updateStats();
		
		addCard(new PoisonKnife(this));
		addCard(new LightGuard(this));
		addCard(new Attack(this));
		addCard(new player.playerCards.green.QuickAttack(this));
		addCard(new Rest(this));
		
		addCard(new TwinSlash(this));
		addCard(new PoisonKnife(this));
		addCard(new player.playerCards.red.QuickAttack(this));
		addCard(new Guard(this));
		
		addCard(new Rest(this)); //addCard(new ActionSurge(this));
		addCard(new TakeCover(this));
		addCard(new Finisher(this));
		addCard(new PoisonDart(this));
		
		addCard(new Heal(this));
		addCard(new LightGuard(this));
		addCard(new ChaseDown(this));
		addCard(new ThrowingKnife(this));
	}
}