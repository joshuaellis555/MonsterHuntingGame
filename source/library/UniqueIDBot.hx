package library;

/**
 * ...
 * @author JoshuaEllis
 */
class UniqueIDBot
{
	private static var cID:Int = -1;

	public function new(){}
	public function get():Int
	{
		cID--;
		return cID;
	}
}