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
	private var timeFromLast:Float = 0.0; //tracks delay for queuing up damage numbers so they dont get shown all at once
	
	private var owner:Character; //character the numbers apear over
	
	public function new(owner:Character) 
	{
		super(owner);
		this.owner = owner;
		forceUpdate = true; //make sure damage numbers continue to update when ower is delayed
	}
	public function addNumber(number:String, color:FlxColor)
	{
		//trace(number);
		addItem(new DamageNumber(this, owner.x + 60, owner.y - 30, color, number, timeFromLast)); //create new damage number
		timeFromLast += 0.3;
	}
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		timeFromLast = Math.max(timeFromLast - elapsed, 0);
	}
}