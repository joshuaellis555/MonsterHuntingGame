package player.playerCards.yellow;

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

/**
 * ...
 * @author Joshua ellis
 */
class HeavyGuard extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner);
		name = "Heavy Guard";
		family = CardFamily.Yellow;
		cardType.positiveEffect(true);
		cost = new Resources([0, 2, 0]);
		windupTime = 1.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.roundbreak_20__png, 0xffcccccc, 192, 192, 25, 1));
		chargeTime = 1.5;
	}
	override public function play()
	{
		targets = [Library.characters.self(owner)];
		super.play();
	}
	override public function resolve()
	{
		target.effects.addGuard(45, 16);
		
		super.resolve();
	}
}