package utilities.plusInterface;

import flixel.FlxBasic;
import utilities.plusInterface.PlusEnum;

/**
 * @author Joshua Ellis
 */
interface PlusInterface
{
	private var plusType:PlusEnum;
	public function type():PlusEnum;
	
	private var trackedItems:Array<PlusInterface>;
	private var tracker:PlusInterface;
	
	public function addItem(item:PlusInterface):Void;
	public function setTracker(tracker:Null<PlusInterface> = null):Void;
	public function removeItem(item:PlusInterface):Bool;
	
	private var updateEnabled:Bool;
	public var forceUpdate:Bool;
	public function setUpdate(enabled:Bool):Void;
	
	private function plusUpdateSubroutine(elapsed:Float):Void;
	public function plusUpdate(elapsed:Float):Void;
	
	public function destroy():Void;
}