package player.menu;
import utilities.button.Button;
import utilities.camera.Camera;
import flixel.math.FlxRect;
import library.Cameras;
import card.CardFamily;
import player.playerCards.unplayable.Redraw;
import character.statusEffects.StatusTypes;
import utilities.controller.Controller;
import player.playerCards.PlayerCard;
import utilities.event.Event;
import utilities.event.MouseEvent;
import utilities.event.MouseEventType;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import utilities.observer.Observer;
import utilities.observer.Subject;
import openfl.geom.Rectangle;
import player.Player;
import character.resources.ResourceTypes;
import character.resources.Resources;
import utilities.selection.Selection;
import utilities.selection.SelectionActions;
import utilities.plusInterface.SpritePlus;
import library.Library;

/**
 * ...
 * @author 
 */
class BattleMenu extends SpritePlus
{
	private var id:Int;
	
	private var position:Float = 0;
	
	public var menuImage:FlxSprite;
	
	private var owner:Null<Player>;
	
	public var buttons:Array<MenuButton> = [];
	
	public var selection:Selection;
	
	private var healthBar:FlxSprite;
	private var healthBarPreX:Int = 0;
	private var staminaBar:FlxSprite;
	private var staminaBarPreX:Int = 0;
	private var manaBar:FlxSprite;
	private var manaBarPreX:Int = 0;
	
	private var guardText:FlxText;
	
	
	
	public function new(owner:Player, position:Float)
	{
		super(owner);
		this.owner = owner;
		
		/*
		var tmpSprite:FlxSprite = new FlxSprite();
		tmpSprite.loadGraphic(AssetPaths.BattleMenuUpscaled__png,false,456, 393);
		this.makeGraphic(Std.int(tmpSprite.width), Std.int(tmpSprite.height));
		this.pixels.setPixels(new Rectangle(tmpSprite.width, tmpSprite.height), tmpSprite.pixels.getPixels(new Rectangle(tmpSprite.width, tmpSprite.height)));
		//*/
		
		menuImage = new FlxSprite(Std.int(475.0 * (position - 1)) + 19, 687);
		menuImage.loadGraphic(AssetPaths.BattleMenuUpscaled__png, false, 456, 393);
		menuImage.cameras = [Library.cameras.mainCam.flxCam()];
		
		//this.graphic.bitmap.getPixels();
		FlxG.state.add(menuImage);
		
		for (i in 0...8){
			buttons.push(new MenuButton(i, this, i));
		}
		
		//trace("selection");
		selection = new Selection([cast buttons], previous, next,null,null,ok,esc,discard);
		
		//trace("setFocus");
		owner.setFocus(selection.getTarget());
		
		//*
		healthBar = new FlxSprite(menuImage.x + 30, menuImage.y + 39);
		healthBar.loadGraphic(AssetPaths.BattleMenuHealthBarUpscaled__png, false, 361, 15);
		healthBar.cameras = menuImage.cameras;
		FlxG.state.add(healthBar);
		
		staminaBar = new FlxSprite(menuImage.x + 30, menuImage.y + 60);
		staminaBar.loadGraphic(AssetPaths.BattleMenuStaminaBarUpscaled__png, false, 361, 15);
		staminaBar.cameras = menuImage.cameras;
		FlxG.state.add(staminaBar);
		
		manaBar = new FlxSprite(menuImage.x + 30, menuImage.y + 81);
		manaBar.loadGraphic(AssetPaths.BattleMenuManaBarUpscaled__png, false, 361, 15);
		manaBar.cameras = menuImage.cameras;
		FlxG.state.add(manaBar);
		
		//barSteps = 2 / healthBar.width;
		//*/
		
		guardText = new FlxText(menuImage.x + 135*3, menuImage.y + 12*3, 40, "", 24, true);
		guardText.cameras = menuImage.cameras;
		guardText.color = FlxColor.WHITE;
		guardText.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 3);
		FlxG.state.add(guardText);
		
		//trace("menu done");
	}
	public function next()
	{
		selection.next();
		owner.setFocus(selection.getTarget());
	}
	public function previous()
	{
		selection.previous();
		owner.setFocus(selection.getTarget());
	}
	public function ok()
	{
		//trace("battle ok");
		var btn:MenuButton = cast selection.getTarget();
		if (btn.card!=null)
			cast(owner.character.activeCards.knownCards[selection.getIndex()],PlayerCard).play();
		owner.resetFocus();
	}
	public function esc()
	{
		owner.selection.popSubSelection();
		owner.resetFocus();
	}
	public function discard()
	{
		trace('menu discard');
		buttons[owner.selection.getIndex()].card.discard();
	}
	
	public function updateSelection()
	{
		//trace("updateSelection");
		var index:Int = selection.getIndex();
		var b:Array<Button> = [for (i in 0...owner.character.handSize()) buttons[i]];
		//trace(b.length);
		selection = new Selection([cast b], previous, next, null, null, ok, esc,discard);
		selection.setIndex(Std.int(Math.min(index,owner.character.handSize())));
		owner.selection = selection;
		owner.resetFocus();
		//trace("updated Selection");
	}
	
	public function setOwner(owner:Player)
	{
		this.owner = owner;
		owner.setFocus(selection.getTarget());
		trace('owner', owner.ID);
	}
	override public function plusUpdate(elapsed:Float):Void
	{
		super.plusUpdate(elapsed);
		if (owner == null) return;
		if (owner.controller.up == 1) selection.interact(SelectionActions.Up);
		if (owner.controller.down == 1)	selection.interact(SelectionActions.Down);
		if (owner.controller.left == 1) selection.interact(SelectionActions.Left);
		if (owner.controller.right == 1) selection.interact(SelectionActions.Right);
		if (owner.controller.A == 1) selection.interact(SelectionActions.Ok);
		if (owner.controller.B == 1) selection.interact(SelectionActions.Esc);
		if (owner.controller.upLeft == 1) selection.interact(SelectionActions.UpLeft);
		if (owner.controller.downLeft == 1)	selection.interact(SelectionActions.DownLeft);
		if (owner.controller.upRight == 1) selection.interact(SelectionActions.UpRight);
		if (owner.controller.downRight == 1) selection.interact(SelectionActions.UpRight);
		if (owner.controller.Y == 1) selection.interact(SelectionActions.Y);
	}
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
		
		healthBar.set_clipRect(new FlxRect(0, 0, Std.int(Math.max(1, owner.character.resources.get(ResourceTypes.health) / Math.max(1, owner.character.resources.getCap(ResourceTypes.health)) * healthBar.width)), 15));
		staminaBar.set_clipRect(new FlxRect(0, 0, Std.int(Math.max(1, owner.character.resources.get(ResourceTypes.stamina) / Math.max(1, owner.character.resources.getCap(ResourceTypes.stamina)) * staminaBar.width)), 15));
		manaBar.set_clipRect(new FlxRect(0, 0, Std.int(Math.max(1, owner.character.resources.get(ResourceTypes.mana) / Math.max(1, owner.character.resources.getCap(ResourceTypes.mana)) * manaBar.width)), 15));
		
		guardText.text = Std.string(owner.character.effects.maxGuard());
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
						case MouseEventType.LeftJustReleased:{
						}
						case MouseEventType.RightJustReleased:{
						}
						case MouseEventType.MouseOver:{
						}
						case MouseEventType.MouseOff:{
						}
						default:null;
					}
				}
			}
			default:null;
		}
	}
}