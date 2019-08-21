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
class Revive extends PlayerCard
{
	public function new(owner:PlayerCharacter) 
	{
		super(owner, [DamageTypes.holy]);
		name = "Revive";
		family = CardFamily.White;
		cardType.spell(true);
		cardType.positiveEffect(true);
		cost = new Resources([0, 0, 5]);
		windupTime = 1.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.castSpell_35__png, Library.damageColors.get(DamageTypes.holy), 192, 192, 35, 1));
		chargeTime = 3.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.LifeSphere_20__png, Library.damageColors.get(DamageTypes.holy), 192, 192, 35, 1));
	}
	override public function play()
	{	
		targets = [Library.characters.deadAllies(owner)];// , Groups.characters.deadEnemies(owner)];
		trace('play Revive', targets[0].length);
		
		super.play();
	}
	override public function resolve()
	{
		target.reviveCharacter(20);
		
		super.resolve();
	}
}