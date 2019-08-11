package utilities.plusInterface;

import flixel.FlxBasic;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import flixel.FlxState;
import utilities.plusInterface.PlusEnum;
import utilities.plusInterface.PlusInterface;

/**
 * ...
 * @author Joshua Ellis
 */
class StatePlus extends FlxState implements PlusInterface
{
	private var plusType:PlusEnum;
	
	private var trackedItems:Array<PlusInterface> = [];
	private var tracker:PlusInterface;
	
	private var updateEnabled:Bool = true;
	public var forceUpdate:Bool = false;
	
	public function type():PlusEnum
	{
		plusType = PlusEnum.StatePlus;
		return plusType;
	}
	public function addItem(item:PlusInterface):Void
	{
		item.setTracker(this);
		trackedItems.push(item);
		FlxG.state.add(cast item);
	}
	public function setTracker(tracker:Null<PlusInterface> = null):Void
	{
		this.tracker = tracker;
	}
	public function removeItem(item:PlusInterface):Bool
	{
		return trackedItems.remove(item);
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		plusUpdateSubroutine(elapsed);
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