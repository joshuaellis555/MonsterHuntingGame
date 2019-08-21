package player.playerCards.white;

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
class GreaterBlessing extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.holy]);
		name = "Greater Blessing";
		family = CardFamily.White;
		cardType.spell(true);
		cardType.positiveEffect(true);
		cost = new Resources([0, 0, 3]);
		windupTime = 0.0;
		chargeTime = 1.5;
		addItem(resolveAnimation = new Animation(this, AssetPaths.Protect_20__png, 0xffaabbff, 192, 192, 25, 1));
	}
	override public function play()
	{	
		targets = [Library.characters.allies(owner), Library.characters.enemies(owner)];
		super.play();
	}
	override public function resolve()
	{
		target.effects.addBlessing(18,2);
		
		super.resolve();
	}
}