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

/**
 * ...
 * @author Joshua ellis
 */
class Charge extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.physical]);
		name = "Charge";
		family = CardFamily.Red;
		cardType.melee(true);
		cardType.charge(true);
		cost = new Resources([0, 2, 0]);
		windupTime = 1.0;
		addItem(windupAnimation = new Animation(this,AssetPaths.roundbreak_20__png, 0xffcccccc, 192, 192, 25, 1));
		chargeTime = 1.0;
		addItem(resolveAnimation = new Animation(this,AssetPaths.slash_25__png, 0xffdddddd, 192, 192, 35, 1));
	}
	override public function play()
	{
		targets = [Library.characters.enemies(owner), Library.characters.allies(owner)];
		super.play();
	}
	override public function resolve()
	{
		if (target.distanced()){
			target.distanced(false);
		}
		damage(target, 8);
		
		super.resolve();
	}
}