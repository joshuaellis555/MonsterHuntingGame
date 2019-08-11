package utilities.event;
import utilities.event.EventType;
import utilities.observer.Subject;

/**
 * ...
 * @author JoshuaEllis
 */
class Event 
{
	public var eventType:EventType;
	public var eventSource:Int;
	public function new(id:Int,type:EventType)
	{
		eventType = type;
		eventSource = id;
	}
}