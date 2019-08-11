package character.damageNumbers;
import character.Character;
import flixel.FlxSprite;
import character.damageNumbers.DamageNumber;
import flixel.util.FlxColor;
import utilities.plusInterface.BasicPlusTracker;
import utilities.plusInterface.SpritePlusTracker;
/**
 * ...
 * @author Joshua Ellis
 */
class DamageNumbers extends BasicPlusTracker
{
	private var timeFromLast:Float = 0.0;
	
	private var owner:Character;
	
	public function new(owner:Character) 
	{
		super(owner);
		this.owner = owner;
		forceUpdate = true;
	}
	public function addNumber(number:String, color:FlxColor)
	{
		//trace(number);
		addItem(new DamageNumber(this, owner.x + 60, owner.y - 30, color, number, timeFromLast));
		timeFromLast += 0.3;
	}
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		timeFromLast = Math.max(timeFromLast - elapsed, 0);
	}
}