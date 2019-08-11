package player.playerCards.blueYellow;

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
class NaturesBlessing extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.nature]);
		name = "Nature's Blessing";
		family = CardFamily.BlueGreen;
		cardType.spell(true);
		cardType.positiveEffect(true);
		cost = new Resources([0, 0, 2]);
		windupTime = 0.0;
		chargeTime = 1.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.Protect_20__png, 0xffaabbff, 192, 192, 25, 1));
	}
	override public function play()
	{	
		targets = [Library.characters.allies(owner), Library.characters.enemies(owner)];
		super.play();
	}
	override public function resolve()
	{
		target.effects.addBlessing(10);
		
		super.resolve();
	}
}