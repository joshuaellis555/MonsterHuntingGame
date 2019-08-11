package utilities.button;

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
class Button extends SpritePlus 
{
	private var buttons:Array<MouseEventType>;
	private var buttonSubject:Subject;
	private var focusMap:Map<Int,Player>;
	
	public function new(source:PlusInterface, width:Int, height:Int, x:Int, y:Int, color:FlxColor,?id:Int=0,?camera:Null<FlxCamera>=null,?pixelPerfect:Bool=false,?mouseChildren:Bool=false,?image:Null<FlxGraphicAsset>=null,?animated:Bool=false,?imgW=0,?imgH=0)
	{
		if (image == null){
			super(source, x, y);
			this.makeGraphic(width, height, color);
		}else{
			super(source, x, y);
			this.loadGraphic(image, animated, imgW, imgH);
			this.color = color;
		}
		if (camera!=null)
			this.cameras = [camera];
		else
			this.cameras = [Library.cameras.mainCam.flxCam()];
		
		focusMap = new Map<Int,Player>();
		
		this.solid=false;
			
		//FlxMouseEventManager.add(this, this.mouseDown, this.mouseUp, this.mouseOver, this.mouseOff, mouseChildren, true, pixelPerfect, [FlxMouseButtonID.LEFT, FlxMouseButtonID.RIGHT]);
		buttons = [];
		//buttonSubject = new Subject([observer],id);
	}
	private function mouseDown(button:Button):Void
	{
		if (FlxG.mouse.justPressed){
			buttons.push(MouseEventType.LeftJustClicked);
		}
		else if (FlxG.mouse.justPressedRight){
			buttons.push(MouseEventType.RightJustClicked);
		}
	}
	private function mouseUp(button:Button):Void
	{
		if (FlxG.mouse.justReleased){
			buttons.push(MouseEventType.LeftJustReleased);
		}
		else if (FlxG.mouse.justReleasedRight){
			buttons.push(MouseEventType.RightJustReleased);
		}
	}
	private function mouseOver(button:Button):Void
	{
		buttons.push(MouseEventType.MouseOver);
	}
	private function mouseOff(button:Button):Void
	{
		buttons.push(MouseEventType.MouseOff);
	}
	public function focus(cursor:Player)
	{
		cursor._setFocus(this);
		focusMap[cursor.ID] = cursor;
		resetCursors();
		switch(cursor.cursorMode){
			case 0:{
				cursor.x = this.x + Std.int(this.width *.005);
				cursor.y = this.y + Std.int(this.height / 2);
			}
			case 2:{
				cursor.x = this.x + Std.int(this.width *.995);
				cursor.y = this.y + Std.int(this.height / 2);
			}
			case 1:{
				cursor.x = this.x + Std.int(this.width / 2);	
				cursor.y = this.y + Std.int(this.height * .005);
			}
			case 3:{
				cursor.x = this.x + Std.int(this.width / 2);	
				cursor.y = this.y + Std.int(this.height * .995);
			}
			default:null;
		}
	}
	public function unfocus(cursor:Player)
	{
		focusMap.remove(cursor.ID);
		resetCursors();
	}
	private function resetCursors()
	{
		var i = 0;
		for (cursor in focusMap){
			cursor.cursorMode = i;
			i++;
		}
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		/*
		if (buttons.length > 0){
			buttonSubject.notify(new MouseEvent(buttonSubject,buttons));
			buttons = [];
		}
		*/
	}
}