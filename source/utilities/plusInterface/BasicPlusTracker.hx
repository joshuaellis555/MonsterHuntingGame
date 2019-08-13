package utilities.plusInterface;
import flixel.FlxBasic;
import flixel.FlxG;
import utilities.plusInterface.BasicPlus;

/**
 * ...
 * @author Joshua Ellis
 */
class BasicPlusTracker extends FlxBasic implements PlusInterface
{
	private var plusType:PlusEnum;
	
	private var trackedItems:Array<PlusInterface> = [];
	private var tracker:Null<PlusInterface> = null;
	
	private var updateEnabled:Bool = true;
	public var forceUpdate:Bool = false;
	
	public function new(parent:PlusInterface)
	{
		plusType = PlusEnum.BasicPlusTracker;
		parent.addItem(this);
		super();
	}
	public function type():PlusEnum
	{
		return plusType;
	}
	public function addItem(item:PlusInterface):Void
	{
		if (item.type() == PlusEnum.BasicPlus){
			if (item.tracker != null)
				item.tracker.removeItem(item);
			item.setTracker(this);
			trackedItems.push(item);
			FlxG.state.add(cast item);
		}
	}
	public function setTracker(tracker:Null<PlusInterface> = null):Void
	{
		this.tracker = tracker;
	}
	public function removeItem(item:PlusInterface):Bool
	{
		item.setTracker(null);
		return trackedItems.remove(item);
	}
	public function removeAtIndex(index:Int):Void
	{
		trackedItems[index].setTracker(null);
		trackedItems.remove(trackedItems[index]);
	}
	public function array():Array<BasicPlus>
	{
		return cast trackedItems;
	}
	public function length():Int
	{
		return trackedItems.length;
	}
	
	public function plusUpdate(elapsed:Float){}
	private function plusUpdateSubroutine(elapsed:Float)
	{
		for (item in trackedItems)
			item.plusUpdateSubroutine(elapsed);
		if (updateEnabled || forceUpdate) plusUpdate(elapsed);
	}
	public function setUpdate(enabled:Bool)
	{
		updateEnabled = enabled;
		for (item in trackedItems)
			item.updateEnabled = enabled;
	}
	
	override public function destroy():Void
	{
		while (trackedItems.length > 0) trackedItems[0].destroy();
		if (tracker != null) tracker.removeItem(this);
		super.destroy();
	}
}