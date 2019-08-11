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
	public static var controllers:Controllers = new Controllers();
	public static var characters:Characters = new Characters();
	public static var teams:Teams = new Teams();
	public static var cardOverseer:CardOverseer = new CardOverseer();
	public static var uniqueIDBot:UniqueIDBot = new UniqueIDBot();
	public static var cameras:Cameras = new Cameras();
	
	public static var elementalResistances:ElementalResistances = new ElementalResistances();
	public static var statTables:StatTables = new StatTables();
	public static var damageColors:DamageColors = new DamageColors();
	public static var cardColors:CardColors = new CardColors();
	public static var statusColors:StatusColors = new StatusColors();
}