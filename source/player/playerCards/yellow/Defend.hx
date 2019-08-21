package player.playerCards.yellow;

import utilities.button.Button;
import player.playerCards.PlayerCard;
import card.CardFamily;
import character.Character;
import player.PlayerCharacter;
import utilities.event.Event;
import player.Player;
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
class Defend extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, []);
		name = "Defend";
		family = CardFamily.Yellow;
		cost = new Resources([0, 2, 0]);
		windupTime = 0.0;
		
		chargeTime = 2.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1.0));
	}
	override public function play()
	{	
		targets = [Library.characters.alliesExcludingSelf(owner), Library.characters.enemies(owner)];
		super.play();
	}
	override public function resolve()
	{
		target.effects.addDefender(damageTrigger, owner, 10);
		target.effects.addGuard(16, 10);
		owner.effects.addGuard(24, 10);
		super.resolve();
	}
	override public function damageTrigger(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null) :Float
	{
		//trace('damageTrigger');
		if (source == null || cardType == null) return value;
		if (cardType.melee() != true) return value;
		
		var leftover:Float = owner.takesDamage(types, value, cardType, null);
		
		return leftover;
	}
}