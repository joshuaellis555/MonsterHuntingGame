package library;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxColor;
import utilities.camera.Camera;

/**
 * ...
 * @author JoshuaEllis
 */
class Cameras 
{	
	public var backgroundCam:Camera;
	public var subCam:Camera;
	public var cursorCam:Camera;
	public var mainCam:Camera;
	
	public function new()
	{
		backgroundCam = new Camera(0, 0, FlxG.width, FlxG.height);
		subCam = new Camera(0, 0, FlxG.width, FlxG.height);
		cursorCam = new Camera(0, 0, FlxG.width, FlxG.height);
		mainCam = new Camera(0, 0, FlxG.width, FlxG.height);
	}
}