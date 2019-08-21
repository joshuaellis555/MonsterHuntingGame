package player.playerCards.blue;

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
class GenerateMana extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.magic]);
		name = "Generate Mana";
		family = CardFamily.Blue;
		cardType.positiveEffect(true);
		cardType.spell(true);
		cost = new Resources([]);
		windupTime = 1.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.fortify__20__png, Library.damageColors.get(DamageTypes.magic), 192, 192, 20, 1));
		chargeTime = 3.0;
	}
	override public function play()
	{
		targets = [Library.characters.self(owner)];
		super.play();
	}
	override public function resolve()
	{
		target.giveResources(new Resources([0, 0, 7]));
		
		super.resolve();
	}
}