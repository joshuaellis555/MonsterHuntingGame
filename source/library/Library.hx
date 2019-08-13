package library;
import library.Cameras;
import player.Player;
import library.Controllers;
import library.Teams;

/**
 * @author JoshuaEllis
 */

@:enum
class Library
{
	public static var players(default, never):Players = new Players();
	public static var controllers(default, never):Controllers = new Controllers();
	public static var characters(default, never):Characters = new Characters();
	public static var teams(default, never):Teams = new Teams();
	public static var cardOverseer(default, never):CardOverseer = new CardOverseer();
	public static var uniqueIDBot(default, never):UniqueIDBot = new UniqueIDBot();
	public static var cameras(default, never):Cameras = new Cameras();
	
	public static var elementalResistances(default, never):ElementalResistances = new ElementalResistances();
	public static var statTables(default, never):StatTables = new StatTables();
	public static var damageColors(default, never):DamageColors = new DamageColors();
	public static var cardColors(default, never):CardColors = new CardColors();
	public static var statusColors(default, never):StatusColors = new StatusColors();
}