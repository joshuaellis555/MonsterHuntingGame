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
class ThrowingKnife extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.physical,DamageTypes.poison]);
		name = "Throwing Knife";
		family = CardFamily.Green;
		cost = new Resources([0, 1, 0]);
		windupTime = 1.0;
		chargeTime = 1.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.slash_25__png, Library.damageColors.get(DamageTypes.poison), 192, 192, 35, 1));
	}
	override public function play()
	{	
		targets = [Library.characters.enemies(owner), Library.characters.allies(owner)];
		super.play();
	}
	override public function resolve()
	{
		var ct:CardType =  new CardType();
		if (target.distanced())
			ct.ranged(true)
		else
			ct.melee(true);
		
		damage(target, 8, 0, null, ct);
		
		super.resolve();
	}
}