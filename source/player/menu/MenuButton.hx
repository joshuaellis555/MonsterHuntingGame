package player.menu;
import utilities.button.Button;
import card.Card;
import card.CardFamily;
import player.playerCards.PlayerCard;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.math.FlxPoint;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import haxe.Constraints.Function;
import utilities.event.Event;
import utilities.event.EventType;
import utilities.event.MouseEvent;
import utilities.event.MouseEventType;
import utilities.observer.Observer;
import utilities.observer.Subject;
import library.Library;

/**
 * ...
 * @author ...
 */
class MenuButton extends Button 
{
	private var number:Int;
	private var owner:BattleMenu;
	private var loadBar:Button;
	
	public var card:Null<PlayerCard> = null;
	private var fText:FlxText;
	private var tWidth:Int;
	
	public function new(number:Int,owner:BattleMenu,id:Int)
	{
		this.number = number;
		this.owner = owner;
		
		super(owner,Std.int(owner.menuImage.width - 12), 30, Std.int(owner.menuImage.x + 6), Std.int(owner.menuImage.y + 105 + number * 36), FlxColor.WHITE, id, owner.menuImage.cameras[0]);
		FlxG.state.add(this);
		//loadBar = new Button(Std.int(owner.width - 12), 34, Std.int(owner.x + 6), Std.int(owner.y + 56 + number * 38), FlxColor.WHITE, owner, id, owner.cameras[0]);
		//FlxG.state.add(loadBar);
		
		
		
		fText = new FlxText(this.x + 3*9, this.y-2, owner.menuImage.width - 6-12-3*9, "", 25, true);
		//fText = new FlxSprite(this.x + 2, this.y);
		//fText.makeGraphic(Std.int(owner.width - 16), 28, FlxColor.BLACK);
		fText.cameras = owner.menuImage.cameras;
		tWidth = Std.int(fText.size * .662857);
		fText.color = FlxColor.BLACK;
		//fText.setBorderStyle(FlxTextBorderStyle.SHADOW, 0xff222222, 1);
		FlxG.state.add(this.fText);
		
	}
	override public function update(elapsed:Float):Void
	{
		x = owner.menuImage.x + 6;
		//trace(card);
		if (card != null){
			fText.visible = true;
			this.visible = true;
			
			this.color = Library.cardColors.get(card.family);
			if (card.family == CardFamily.Black){
				fText.color = FlxColor.WHITE;
			}else{
				fText.color = FlxColor.BLACK;
			}
			if (!card.isCharged || card.family == CardFamily.Unplayable){
				var c:FlxColor = color;
				c.lightness *= .6;
				color = c;
				fText.text = card.name.substr(0, Std.int(fText.width / tWidth));
			}else{
				fText.text = (card.name+"+").substr(0, Std.int(fText.width / tWidth));
			}
		}else{
			fText.visible = false;
			this.visible = false;
		}
		super.update(elapsed);
	}
}