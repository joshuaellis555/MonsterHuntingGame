package player.playerCards.redYellow;

import utilities.button.Button;
import card.CardFamily;
import card.CardType;
import character.Character;
import player.playerCards.PlayerCard;
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
 * @author Joshua Ellis
 */
class ShieldBash extends PlayerCard
{
	
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.physical]);
		name = "Shield Bash";
		family = CardFamily.RedYellow;
		cardType.melee(true);
		cost = new Resources([0, 1, 0]);
		windupTime = 1.0;
		chargeTime = 1.3;
		add(resolveAnimation = new Animation(AssetPaths.slash_25__png, FlxColor.WHITE, 192, 192, 35, 1));
	}
	override public function play()
	{
		targets = [cast Library.characters.enemies(owner), cast Library.characters.allies(owner)];
		super.play();
	}
	override public function resolve()
	{
		damage(target, 7);
		owner.effects.addGuard(12, 7);
		
		super.resolve();
	}
}