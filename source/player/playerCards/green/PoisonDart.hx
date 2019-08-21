package player.playerCards.green;

import utilities.button.Button;
import card.CardType;
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
class PoisonDart extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.poison]);
		name = "Poison Dart";
		family = CardFamily.Green;
		cardType.ranged(true);
		cost = new Resources([0, 1, 0]);
		windupTime = 0.0;
		chargeTime = 1.0;
		//add(resolveAnimation = new Animation(AssetPaths.slash_25__png, DamageTypes.poison, 192, 192, 35, 1));
	}
	override public function play()
	{	
		targets = [Library.characters.enemies(owner), Library.characters.allies(owner)];
		super.play();
	}
	override public function resolve()
	{
		target.effects.addVenom(5);
		
		super.resolve();
	}
}