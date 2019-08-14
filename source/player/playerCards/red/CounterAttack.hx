package player.playerCards.red;

import utilities.button.Button;
import player.playerCards.PlayerCard;
import card.CardFamily;
import character.Character;
import player.PlayerCharacter;
import utilities.event.Event;
import player.Player;
import character.resources.Health;
import character.resources.Resources;
import character.resources.ResourceTypes;
import character.damage.DamageTypes;
import utilities.animation.Animation;
import flixel.util.FlxColor;
import library.Library;
import card.CardType;

/**
 * ...
 * @author Joshua ellis
 */
class CounterAttack extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.physical]);
		name = "Counter Attack";
		family = CardFamily.Red;
		cardType.melee(true);
		cost = new Resources([0, 2, 0]);
		windupTime = 0.0;
		
		chargeTime = 1.0;
		addItem(resolveAnimation = new Animation(this,AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1.0));
		
		resolveDelayTime = 3.0;
		resolveDelayDamageContainer = owner.takesDamageCalls[0];
		resolveDelayDamageTrigger = damageTrigger;
		addItem(delayAnimation = new Animation(this,AssetPaths.roundbreak_20__png, 0xffcccccc, 192, 192, 22, 1.0, 3));
	}
	override public function play()
	{	
		targets = [Library.characters.self(owner)];
		super.play();
	}
	override public function resolve()
	{	
		super.resolve();
	}
	override public function damageTrigger(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null) :Float
	{
		//trace('damageTrigger');
		if (source == null || cardType == null) return value;
		if (cardType.melee() != true) return value;
		
		if (source == owner) trace('source==owner');
		
		//trace('damageTrigger source takesDamage');
		source.takesDamage(types, value+5, cardType, null);
		
		//trace('damageTrigger animation');
		resolveAnimation.play(source);
		delayAnimation.stop();
		
		value = value / 2 - 2;
		
		//trace('damageTrigger return');
		return super.damageTrigger(types, value, cardType, source);
	}
}