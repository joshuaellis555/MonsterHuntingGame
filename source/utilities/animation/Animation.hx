package utilities.animation;
import utilities.button.Button;
import library.Cameras;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.input.mouse.FlxMouseButton.FlxMouseButtonID;
import flixel.input.mouse.FlxMouseEventManager;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.util.FlxColor;
import haxe.Constraints.Function;
import utilities.event.Event;
import utilities.event.EventType;
import utilities.event.MouseEvent;
import utilities.event.MouseEventType;
import utilities.observer.Observer;
import utilities.observer.Subject;
import player.Player;
import utilities.plusInterface.SpritePlus;
import utilities.plusInterface.PlusInterface;
import library.Library;

/**
 * ...
 * @author ...
 */
class Animation extends SpritePlus
{
	private var target:FlxSprite;
	private var ranTime:Float = 0.0;
	private var runTime:Float;
	private var delay:Float = 0.0;
	private var loops:Int;
	private var loopsToDo:Int = 0;
	override public function new(source:PlusInterface, graphic:FlxGraphicAsset, color:FlxColor, width:Int, height:Int, numFrames, runTime:Float, ?loops:Int=1) 
	{
		super(source);
		//trace('Animation');
		loadGraphic(graphic, true, width, height);
		this.animation.add("DEFAULT", [for (i in 0...numFrames) i], Std.int(numFrames / runTime), false);
		this.visible = false;
		this.camera = Library.cameras.mainCam.flxCam();
		this.active = false;
		this.color = color;
		this.runTime = runTime;
		this.loops = loops;
		//trace('Animation Done');
	}
	public function play(target:FlxSprite, ?delay:Float=0.0)
	{
		this.target = target;
		this.delay = delay;
		this.active = true;
		
		if (delay <= 0.0){
			animation.play("DEFAULT",true);
			this.visible = true;
			ranTime = 0.0;
		}
		loopsToDo = loops;
	}
	public function stop()
	{
		this.visible = false;
		this.active = false;
		animation.stop();
	}
	override public function update(elapsed:Float)
	{
		
		if (delay > 0.0){
			delay -= elapsed;
			if (delay <= 0.0)
				play(target);
		}
		if (delay <= 0.0){
			super.update(elapsed);
			this.x = target.x - this.width / 2 + target.width / 2;
			this.y = target.y - this.height / 2 + target.width / 2;
			ranTime += elapsed;
			if (ranTime > runTime){
				loopsToDo -= 1;
				if (loopsToDo > 0){
					ranTime-= runTime;
					animation.play("DEFAULT",true);
				}else{				
					this.visible = false;
					this.active = false;
				}
			}
		}
	}
}