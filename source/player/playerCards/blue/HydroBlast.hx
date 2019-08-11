package player.playerCards.blue;

import utilities.button.Button;
import player.playerCards.PlayerCard;
import card.CardFamily;
import character.Character;
import player.PlayerCharacter;
import library.ElementalResistances;
import utilities.event.Event;
import player.Player;
import character.resources.Health;
import character.resources.Resources;
import character.resources.ResourceTypes;
import character.statusEffects.StatusEffects;
import character.statusEffects.StatusTypes;
import character.damage.DamageTypes;
import utilities.animation.Animation;
import flixel.util.FlxColor;
import library.Library;

/**
 * ...
 * @author Joshua ellis
 */
class HydroBlast extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.water]);
		name = "Hydro Blast";
		family = CardFamily.Blue;
		cardType.spell(true);
		cost = new Resources([0, 0, 3]);
		windupTime = 1.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.castSpell_35__png, Library.damageColors.get(DamageTypes.water), 192, 192, 35, 1));
		chargeTime = 2.0;
	}
	override public function play()
	{
		targets = [Library.characters.enemies(owner), Library.characters.allies(owner)];
		super.play();
	}
	override public function resolve()
	{
		damage(target, 10);
		target.giveStatusEffect(StatusTypes.wet, 10);
		target.damageNumbers.addNumber('Wet', Library.statusColors.get(StatusTypes.wet));
		
		super.resolve();
	}
}