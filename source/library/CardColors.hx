package library;
import character.damage.DamageTypes;
import flixel.util.FlxColor;
import card.CardFamily;

/**
 * ...
 * @author Joshua Ellis
 */
class CardColors 
{
	private var cardColors:Map<CardFamily,FlxColor>;
	public function new() 
	{
		cardColors = new Map<CardFamily,FlxColor>();
		
		cardColors[CardFamily.Red] = FlxColor.RED;
		cardColors[CardFamily.Blue] = 0xff0011ff;
		cardColors[CardFamily.Green] = 0xff22ff22;
		cardColors[CardFamily.Yellow] = FlxColor.YELLOW;
		
		cardColors[CardFamily.RedBlue] = 0xffcc22ee;
		cardColors[CardFamily.RedGreen] = FlxColor.BROWN;
		cardColors[CardFamily.RedYellow] = FlxColor.ORANGE;
		cardColors[CardFamily.BlueGreen] = FlxColor.CYAN;
		cardColors[CardFamily.BlueYellow] = 0xffaaff7f;
		cardColors[CardFamily.GreenYellow] = 0xff7fff00;
		
		cardColors[CardFamily.White] = FlxColor.WHITE;
		cardColors[CardFamily.Black] = 0xff111111;
		
		cardColors[CardFamily.Equipment] = 0xffbac2cd;
		
		cardColors[CardFamily.Unplayable] = 0xff999999;
	}
	public function get(type:CardFamily):FlxColor
	{
		return cardColors[type];
	}
}