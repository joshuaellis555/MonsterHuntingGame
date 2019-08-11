package utilities.controller;

import flixel.FlxBasic;
import flixel.input.gamepad.FlxGamepad;
import flixel.FlxG;
import utilities.plusInterface.BasicPlus;
import utilities.plusInterface.PlusInterface;
import library.Library;

/**
 * ...
 * @author ...
 */

class Controller extends BasicPlus
{
	private var controller:Null<FlxGamepad> = null;
	
	public var up:Int=-1;
	public var upLeft:Int=-1;
	public var upRight:Int=-1;
	public var down:Int=-1;
	public var downLeft:Int=-1;
	public var downRight:Int=-1;
	public var left:Int=-1;
	public var right:Int=-1;
	public var A:Int=-1;
	public var B:Int=-1;
	public var X:Int=-1;
	public var Y:Int=-1;
	public var Rb:Int=-1;
	public var Lb:Int=-1;
	public var Rt:Int=-1;
	public var Lt:Int=-1;
	public var R3:Int=-1;
	public var L3:Int=-1;
	public var back:Int=-1;
	public var start:Int =-1;
	
	
	public function new(owner:PlusInterface) 
	{
		super(owner);
		Library.controllers.add(this);
	}
	public function getID():Null<Int>
	{
		if (controller == null)
			return null;
		else
			return controller.id;
	}
	override public function update(elapsed:Float):Void 
	{
		super.update(elapsed);
		if (controller == null){
			for (c in FlxG.gamepads.getActiveGamepads()){
				if (!Lambda.has(Library.controllers.ids(), c.id)){
					controller = c;
					break;
				}
			}
		}
		else{
			if (!controller.connected){
				controller = null;
				return;
			}
			if (controller.pressed.DPAD_UP && controller.pressed.DPAD_LEFT){
				if (upLeft < 0) upLeft = 1;
				else upLeft++;
			}else{
				if (upLeft > 0) upLeft = 0;
				else upLeft--;
			}
			if (controller.pressed.DPAD_UP && controller.pressed.DPAD_RIGHT){
				if (upRight < 0) upRight = 1;
				else upRight++;
			}else{
				if (upRight > 0) upRight = 0;
				else upRight--;
			}
			if (controller.pressed.DPAD_DOWN && controller.pressed.DPAD_LEFT){
				if (downLeft < 0) downLeft = 1;
				else downLeft++;
			}else{
				if (downLeft > 0) downLeft = 0;
				else downLeft--;
			}
			if (controller.pressed.DPAD_DOWN && controller.pressed.DPAD_RIGHT){
				if (downRight < 0) downRight = 1;
				else downRight++;
			}else{
				if (downRight > 0) downRight = 0;
				else downRight--;
			}
			
			if (controller.pressed.DPAD_UP && !controller.pressed.DPAD_LEFT && !controller.pressed.DPAD_RIGHT){
				if (up < 0) up = 1;
				else up++;
			}else{
				if (up > 0) up = 0;
				else up--;
			}
			if (controller.pressed.DPAD_DOWN && !controller.pressed.DPAD_LEFT && !controller.pressed.DPAD_RIGHT){
				if (down < 0) down = 1;
				else down++;
			}else{
				if (down > 0) down = 0;
				else down--;
			}
			if (controller.pressed.DPAD_LEFT && !controller.pressed.DPAD_UP && !controller.pressed.DPAD_DOWN){
				if (left < 0) left = 1;
				else left++;
			}else{
				if (left > 0) left = 0;
				else left--;
			}
			if (controller.pressed.DPAD_RIGHT && !controller.pressed.DPAD_UP && !controller.pressed.DPAD_DOWN){
				if (right < 0) right = 1;
				else right++;
			}else{
				if (right > 0) right = 0;
				else right--;
			}
			
			if (controller.pressed.A){
				if (A < 0) A = 1;
				else A++;
			}else{
				if (A > 0) A = 0;
				else A--;
			}
			if (controller.pressed.B){
				if (B < 0) B = 1;
				else B++;
			}else{
				if (B > 0) B = 0;
				else B--;
			}
			if (controller.pressed.X){
				if (X < 0) X = 1;
				else X++;
			}else{
				if (X > 0) X = 0;
				else X--;
			}
			if (controller.pressed.Y){
				if (Y < 0) Y = 1;
				else Y++;
			}else{
				if (Y > 0) Y = 0;
				else Y--;
			}
		}
	}
	
}