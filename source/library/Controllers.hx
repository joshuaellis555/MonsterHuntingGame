package library;

import utilities.controller.Controller;
import flixel.FlxG;


/**
 * ...
 * @author JoshuaEllis
 */
class Controllers
{
	public static var members:Array<Controller> = [];

	public function new(){}

	public function add(controller:Controller)
	{
		members.push(controller);
		FlxG.state.add(controller);
	}
	public function all():Array<Controller>
	{
		return members;
	}
	public function ids():Array<Null<Int>>
	{
		var r:Array<Null<Int>> = [];
		for (c in members){
			r.push(c.getID());
		}
		return r;
	}
}