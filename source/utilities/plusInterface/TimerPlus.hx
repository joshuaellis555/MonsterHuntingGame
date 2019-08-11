package utilities.plusInterface;
import utilities.plusInterface.BasicPlus;
import utilities.plusInterface.PlusInterface;

/**
 * ...
 * @author Joshua Ellis
 */
class TimerPlus extends BasicPlus 
{
	private var owner:PlusInterface
	private var time:Float;
	private var call:TimerPlus->Void;
	public function new(owner:PlusInterface, time:Float, call:TimerPlus->Void) 
	{
		owner.addItem(this);
		super();
		this.owner = owner;
		this.time = time;
		this.call = call;
	}
	override public function plusUpdate(elapsed:Float)
	{
		super.plusUpdate(elapsed);
		time-= elapsed;
		if (time <= 0){
			call(this);
			this.destroy();
		}
	}
	override public function destroy():Void
	{
		call(this);
		super.destroy();
	}
}