package card;

/**
 * @author Joshua Ellis
 */
@:enum
class CardState 
{
	public static var Fizzled(default, never):Int = -2;
	public static var Finished(default, never):Int = -1;
	public static var Disabled(default, never):Int = 0;
	public static var Charging(default, never):Int = 1;
	public static var Charged(default, never):Int = 2;
	public static var Windup(default, never):Int = 3;
	public static var Resolving(default, never):Int = 4;
}