package player.playerCards.blueYellow;

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
class Heal extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner);
		name = "Heal";
		family = CardFamily.BlueYellow;
		cardType.spell(true);
		cardType.positiveEffect(true);
		cost = new Resources([0, 0, 3]);
		windupTime = 0.0;
		chargeTime = 2.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.LifeSphere_20__png, 0xff66ff66, 192, 192, 35, 1));
	}
	override public function play()
	{	
		targets = [Library.characters.allies(owner), Library.characters.enemies(owner)];
		super.play();
	}
	override public function resolve()
	{
		target.giveResources(new Resources([15,0,0]));
		//trace(target.resources.get(ResourceTypes.health));
		
		super.resolve();
	}
}