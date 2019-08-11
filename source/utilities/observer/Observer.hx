package utilities.observer;
import utilities.event.Event;

/**
 * ...
 * @author JoshuaEllis
 */
interface Observer 
{
	public function onNotify(event:Event):Void;
}