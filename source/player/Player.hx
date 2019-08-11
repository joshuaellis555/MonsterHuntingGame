package player;

import utilities.button.Button;
import library.Cameras;
import character.Character;
import player.playerCards.PlayerCard;
import player.PlayerCharacter;
import utilities.controller.Controller;
import utilities.event.Event;
import utilities.event.MouseEvent;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import utilities.observer.Observer;
import utilities.observer.Subject;
import character.resources.ResourceTypes;
import character.resources.Resources;
import flixel.input.gamepad.FlxGamepad;
import player.menu.BattleMenu;
import utilities.selection.Selection;
import utilities.plusInterface.SpritePlus;
import utilities.plusInterface.StatePlus;
import library.Library;


/**
 * ...
 * @author ...
 */
class Player extends SpritePlus implements Observer
{
	public var cursorMode:Int = 0;
	
	private var target:Null<Button> = null;
	
	public var menu:Null<BattleMenu>=null;
	
	public var selection:Null<Selection>=null;
	
	public var character:Null<PlayerCharacter>=null;
	
	public var controller:Null<Controller> = null;
	
	public static var god:Bool = false;
	
	public function new(source:StatePlus,?color:FlxColor=FlxColor.GREEN, ?controller:Null<Controller> = null)
	{
		super(source, 0, 0);
		
		this.loadGraphic(AssetPaths.CursorArr__png, true, 401, 401);
		this.scale = new FlxPoint(1 / 8, 1 / 8);
		this.offset = new FlxPoint(this.width/2, this.height/2);
		for (i in 1...4)
			animation.add(Std.string(i-1), [i], 1, false);
		animation.play("0");
		
		this.color = color;
		this.camera = Library.cameras.cursorCam.flxCam();
		
		x = 1920 / 2;
		y = 1080 / 2;
		
		Library.players.add(this);
		
		this.controller = controller;
		
		//trace("player done");
		
	}
	
	public function cardFinished(card:PlayerCard)
	{
		//trace("discard", card.getName());
		character.discardCard(card);
		selection.setIndex(0);
		resetFocus();
	}
	
	public function _setFocus(target:Button)
	{
		if (this.target != null){
			this.target.unfocus(this);
		}
		this.target = target;
	}
	public function setFocus(target:Button)
	{
		target.focus(this);
	}
	public function resetFocus()
	{
		setFocus(selection.getButtons()[selection.getIndex()]);
	}
	
	public function setCharacter(character:PlayerCharacter)
	{
		this.character = character;
	}
	public function getCharacter():Null<PlayerCharacter>
	{
		return character;
	}
	
	public function setMenu(menu:BattleMenu)
	{
		//trace("menu");
		this.menu = menu;
		menu.setOwner(this);
		selection = menu.selection;
		//trace('finish setMenu');
	}
	
	public function makeVisible()
	{
		this.visible = true;
	}
	public function makeInvisible()
	{
		this.visible = false;
	}
	
	override public function update(elapsed:Float):Void 
    {
		//trace(elapsed);
		animation.play(Std.string(cursorMode));
        super.update(elapsed);
    }
	public function onNotify(event:Event):Void 
	{
		switch(event.eventType){
			case Mouse:{
				var m:MouseEvent = cast event;
				for (mouseEvent in m.mouseEvents)
				{
					switch(mouseEvent)
					{
						case LeftJustReleased:{
						}
						case MouseOver:{
						}
						case MouseOff:{
						}
						default:null;
					}
				}
			}
			default:null;
		}
	}
}