package player.playerCards.greenYellow;

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

/**
 * ...
 * @author Joshua ellis
 */
class TakeCover extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner);
		name = "Take Cover";
		family = CardFamily.GreenYellow;
		cost = new Resources([0, 1, 0]);
		windupTime = 0.0;
		//add(windupAnimation = new Animation(AssetPaths.roundbreak_20__png, 0xffcccccc, 192, 192, 25, 1));
		chargeTime = 1.0;
		//add(resolveAnimation = new Animation(AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1));
	}
	override public function play()
	{
		targets = [Library.characters.self(owner)];
		super.play();
	}
	override public function resolve()
	{
		owner.effects.addGuard(10, 10);
		
		owner.distanced(true);
		
		super.resolve();
	}
}