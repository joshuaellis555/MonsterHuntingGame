package player.playerCards.black;

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
class Curse extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner);
		name = "Curse";
		family = CardFamily.Black;
		cardType.spell(true);
		cost = new Resources([0, 0, 3]);
		windupTime = 1.0;
		add(windupAnimation = new Animation(AssetPaths.castSpell_35__png, 0xff550044, 192, 192, 35, 1));
		chargeTime = 1.0;
		add(resolveAnimation = new Animation(AssetPaths.Protect_20__png, 0xff550044, 192, 192, 25, 1));
	}
	override public function play()
	{	
		targets = [Library.characters.enemies(owner), Library.characters.allies(owner)];
		super.play();
	}
	override public function resolve()
	{
		target.effects.addCurse(20);
		
		super.resolve();
	}
}