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
class Player extends SpritePlus
{
	public var cursorMode:Int = 0; //direction and position of cursor
	
	private var target:Null<Button> = null; //the thing the cursor is targeting
	
	public var menu:Null<BattleMenu>=null; //the player's BattleMenu
	
	public var selection:Null<Selection>=null; //the selection of Buttons that the player can select from
	
	public var character:Null<PlayerCharacter>=null; //the player's character
	
	public var controller:Controller; //the player's controller
	
	public function new(source:StatePlus,color:FlxColor, controller:Controller)
	{
		super(source, 0, 0);
		
		// load the graphic for the player's cursor
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
		
		// add player to the players group
		Library.players.add(this);
		
		this.controller = controller;
	}
	
	public function cardFinished()
	{
		selection.boundIndex(); //for safety
		//move cursor to a non redraw card
		var redraws:Int = 0;
		for (i in 0...character.activeCards.length){
			if (character.activeCards.knownCards[i].name == "-")
				redraws += 1;
		}
		if (selection.getIndex() > character.activeCards.length - redraws - 1)
			selection.setIndex(character.activeCards.length - redraws - 1);
		//move cursor and set focus
		resetFocus();
	}
	
	public function _setFocus(target:Button)
	{
		//if this was already focussed, let old target know it no longer has focus from this
		if (this.target != null){
			this.target.unfocus(this);
		}
		//focus on target
		this.target = target;
	}
	public function setFocus(target:Button)
	{
		//let the target know it has the focus of this
		target.focus(this);
	}
	public function resetFocus()
	{
		//moves cursor after selection changes
		setFocus(selection.getButtons()[selection.getIndex()]);
	}
	
	//get and set character
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
		//trace set the player's menu and get base selection from menu
		this.menu = menu;
		menu.setOwner(this);
		selection = menu.selection;
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
		//update cursor 
		animation.play(Std.string(cursorMode));
        super.update(elapsed);
    }
}