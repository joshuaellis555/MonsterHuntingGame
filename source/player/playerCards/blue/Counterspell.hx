package player.playerCards.blue;

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
class Counterspell extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.magic]);
		name = "Counterspell";
		family = CardFamily.Blue;
		cardType.spell(true);
		cost = new Resources([0,0,2]);
		windupTime = 0.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.Instant_Esuna_40__png, Library.damageColors.get(DamageTypes.magic), 192, 192, 40, .6));
		chargeTime = 1.5;
	}
	override public function play()
	{
		targets = [Library.characters.enemies(owner), Library.characters.allies(owner)];
		super.play();
	}
	override public function beginResolution():Bool
	{
		target = cast player.selection.getTarget();
		if (target.windupCard != null){
			if (target.windupCard.cardType.spell() == false) return false;
		}
		else{
			return false;
		}
		return super.beginResolution();
	}
	override public function resolve()
	{
		target.windupCard.fizzle();
		
		super.resolve();
	}
}