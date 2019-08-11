package player.playerCards.blueGreen;

import utilities.button.Button;
import player.playerCards.PlayerCard;
import card.CardFamily;
import character.Character;
import character.stats.Stats;
import player.PlayerCharacter;
import utilities.event.Event;
import player.Player;
import character.resources.Health;
import character.resources.Resources;
import character.resources.ResourceTypes;
import character.damage.DamageTypes;
import utilities.animation.Animation;
import flixel.util.FlxColor;
import utilities.plusInterface.TimerPlus;
import character.stats.StatsEnum;
import library.Library;

/**
 * ...
 * @author Joshua ellis
 */
class Haste extends PlayerCard
{
	private var statsTargets:Map<TimerPlus,Character>;
	private var statsTimers:Map<Character,TimerPlus>;
	
	
	public function new(owner:PlayerCharacter) 
	{
		super(owner);
		name = "Haste";
		family = CardFamily.BlueGreen;
		cardType.spell(true);
		cardType.positiveEffect(true);
		cost = new Resources([0, 0, 3]);
		windupTime = 1.0;
		add(windupAnimation = new Animation(AssetPaths.castSpell_35__png, DamageTypes.earth, 192, 192, 35, 1));
		chargeTime = 2.0;
		//add(resolveAnimation = new Animation(AssetPaths.LifeSphere_20__png, 0xff66ff66, 192, 192, 35, 1));
		statsEntries = new Map<TimerPlus,Character>();
		statsTimers = new Map<Character,TimerPlus>();
	}
	override public function play()
	{	
		targets = [Library.characters.allies(owner), Library.characters.enemies(owner)];
		super.play();
	}
	override public function resolve()
	{
		if (statsTimers.exists(target)){
			statsTimers[target].destroy();
		}
		var s:Stats = new Stats();
		s.setDefault(StatsEnum.speed, 1);
		
		target.stats.add(this.ID, s);
		
		//new TimerPlus(
		
		
		super.resolve();
	}
	public function removeStats(timer:TimerPlus)
	{
		statsTargets[timer].stats.remove(this.ID);
		statsTimers.remove(statsTargets[timer]);
		
	}
}