package utilities.event;

import utilities.event.MouseEventType;
import utilities.event.Event;
import utilities.event.EventType;
import utilities.observer.Subject;

/**
 * ...
 * @author JoshuaEllis
 */
class MouseEvent extends Event 
{
	public var mouseEvents:Array<MouseEventType>;
	
	public function new(subject:Subject, events:Array<MouseEventType>)
	{
		super(subject.getID(),EventType.Mouse);
		mouseEvents = events;
	}
	
}