package monsters.monster.spectre.cards;

import utilities.button.Button;
import monsters.MonsterCard;
import card.CardFamily;
import character.Character;
import monsters.MonsterCharacter;
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
class SpectreCurse extends MonsterCard
{
	public function new(owner:MonsterCharacter) 
	{
		super(owner);
		name = "Curse";
		family = CardFamily.Black;
		cardType.spell(true);
		cost = new Resources([0, 0, 3]);
		windupTime = 1.0;
		addItem(windupAnimation = new Animation(this, AssetPaths.castSpell_35__png, 0xff550044, 192, 192, 35, 1));
		chargeTime = 3.0;
		addItem(resolveAnimation = new Animation(this, AssetPaths.Protect_20__png, 0xff550044, 192, 192, 25, 1));
		possibleTargetsFunct = Library.characters.enemies;
	}
	override public function resolve()
	{
		target.effects.addCurse(20);
		
		super.resolve();
	}
}