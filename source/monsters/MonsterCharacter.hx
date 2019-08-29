package monsters;

import card.Card;
import card.CardState;
import character.statusEffects.StatusTypes;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import monsters.MonsterCard;
import character.Character;
import player.Player;
import flixel.FlxG;
import library.Cameras;
import utilities.plusInterface.PlusInterface;
import utilities.plusInterface.SpritePlus;
import library.Library;

/**
 * ...
 * @author Joshua Ellis
 */
class MonsterCharacter extends Character 
{
	public var target:Null<Character> = null;
	
	public var defaultAction:Null<MonsterCard> = null;
	
	public var delayCurrent:Float = 0.0;
	public var delayTime:Float;
	public var delayBaseTime:Float;
	public var delayRandomExtraTime:Float;
	
	public var highlight:SpritePlus;
	
	public function new(source:PlusInterface,x:Int, y:Int, sprite:Int) 
	{
		super(source, x, y, sprite);
		
		delayTime = delayBaseTime + Std.random(Std.int(delayRandomExtraTime * 10) + 1) / 10;
		
		addItem(highlight = new SpritePlus(this, this.x, this.y));
		highlight.scale = new FlxPoint(1, 1);
		highlight.loadGraphic(AssetPaths.Pointer__png, true,401,401);
		highlight.animation.add("self", [0]);
		highlight.animation.add("other", [1]);
		//trace('ADD OTHER');
		highlight.camera = Library.cameras.subCam.flxCam();
	}
	
	override public function chooseTarget(card:Card)
	{
		card.target = target;
	}
	private function chooseAction():Null<Card>
	{
		var choices:Array<Int> = [for (i in 0...activeCards.length) Std.random(activeCards.length)];
		for (i in choices){
			if (resources.check(activeCards.knownCards[i].cost)){
				var targets:Array<Character> = activeCards.knownCards[i].getTargets()[0];
				if (targets.length > 0){
					target = targets[Std.random(targets.length)];
					return activeCards.knownCards[i];
				}
			}
				
		}
		if (defaultAction!=null){
			var targets:Array<Character> = defaultAction.getTargets()[0];
			if (targets.length > 0){
				target = targets[Std.random(targets.length)];
			}
			discard.push(activeCards.knownCards[choices[0]]);
			activeCards.knownCards.remove(activeCards.knownCards[choices[0]]);
			activeCards.push(discard.pop());
		}
		return defaultAction;
	}
	
	override public function discardCard(card:Card)
	{
		if (card!= defaultAction){
			discard.push(card);
			activeCards.knownCards.remove(card);
			activeCards.push(discard.pop());
		}
		target = null;
		onDeckCard = null;
		delayCurrent = 0.0;
		delayTime = delayBaseTime + Std.random(Std.int(delayRandomExtraTime * 10) + 1) / 10;
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		
		if (distanced())
			this.y = positionY - 100;
		else
			this.y = positionY;
		this.x = positionX;
	}
	override public function plusUpdate(elapsed:Float)
	{
		//trace('update');
		
		super.plusUpdate(elapsed);
		//*
		
		delayCurrent += elapsed; //Additional monster delay
		if (delayCurrent >= delayTime){
			if (onDeckCard == null){
				onDeckCard = chooseAction();
			}
			if (target != null && onDeckCard != null){
				if (onDeckCard.cardState == CardState.Charged){
					onDeckCard.play();
				}
			}
		}
		if (target == null || onDeckCard == null){
			highlight.visible = false;
		}else{
			highlight.visible = true;
			highlight.x = target.x - highlight.width / 2 + target.width / 2;
			highlight.y = target.y - highlight.height / 2 + target.height / 2;
			if (onDeckCard != null) highlight.color = Library.cardColors.get(onDeckCard.family);
			
			if (target == this){
				highlight.animation.play("self");
			}else{
				highlight.animation.play("other");
				//trace('PLAY OTHER');
				highlight.angle = Math.atan2(this.y + this.height/2 - target.y - target.height/2, this.x + this.width/2  - target.x - target.width/2) / Math.PI * 180 + 135;
			}
		}
		//*/
		//trace('update end');
	}
	
	override public function reviveCharacter(health:Int)
	{
		//tracker.add(this);
		//...
	}
	
	override public function kill()
	{
		super.kill();
		//while (trackedItems.length > 0) trackedItems[0].destroy();
		//if (tracker != null) tracker.remove(this);
		//this.visible = false;
		//this.active = false;
		//this.destroy();
		this.alive = false;
		this.exists = false;
	}
	override public function destroy()
	{
		//Do Not Destroy a Monster Without Destroying its Group
		super.destroy();
	}
}