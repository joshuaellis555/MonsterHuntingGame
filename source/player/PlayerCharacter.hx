package player;

import card.Card;
import card.CardFamily;
import player.playerCards.PlayerCard;
import character.Character;
import character.resources.Resources;
import flixel.util.FlxColor;
import player.Player;
import player.playerCards.unplayable.Redraw;
import character.damage.DamageTypes;
import library.Library;
import character.statusEffects.StatusTypes;

/**
 * ...
 * @author Joshua Ellis
 */
class PlayerCharacter extends Character 
{
	public var owner:Player;

	public function new(x:Int, y:Int, owner:Player, sprite:Int) 
	{
		this.owner = owner;
		owner.setCharacter(this);
		
		super(owner, x, y, sprite);
	}
	
	public function removeCardSlot(playerCard:PlayerCard)
	{
		var i:Int = activeCards.knownCards.indexOf(playerCard);
		if (i >= 0){
			discard.push(playerCard);
			activeCards.knownCards.remove(activeCards.knownCards[i]);
			owner.menu.buttons[i].card = null;
		}
	}
	override public function discardCard(card:Card)
	{
		if (activeCards.knownCards.remove(card)){
			discard.push(card);
			activeCards.push(new Redraw(this));
		}else{
			trace('CARD NOT FOUND!!!!!!!!!', card.name);
		}
	}
	override public function drawCard():Bool
	{
		return super.drawCard();
	}
	public function drawPlayerCard(redraw:Redraw):Bool
	{
		if (discard.length <= 0) return false;
		
		var i:Int = activeCards.knownCards.indexOf(redraw);
		if (i >= 0){
			activeCards.knownCards[i] = discard.pop();
			trace(i, owner.menu.buttons.length);
			owner.menu.buttons[i].card = cast activeCards.knownCards[i];
			activeCards.knownCards[i].enabled = true;
		}else{
			trace("REDRAW NOT FOUND!!!!!!!");
		}
		return true;
	}
	override public function addCard(card:Card)
	{
		super.addCard(card);
		if (activeCards.length <= handSize()){
			owner.menu.buttons[activeCards.length - 1].card = cast activeCards.knownCards[activeCards.length - 1];
			activeCards.knownCards[activeCards.length - 1].enabled = true;
		}
	}
	public function resetCardTimers(family:CardFamily)
	{
		for (b in owner.menu.buttons){
			if (b.card != null){
				switch (family){
					case CardFamily.Red:{
						if (b.card.family == CardFamily.Red) b.card.resetCharge();
						else if (b.card.family == CardFamily.RedBlue) b.card.resetCharge();
						else if (b.card.family == CardFamily.RedGreen) b.card.resetCharge();
						else if (b.card.family == CardFamily.RedYellow) b.card.resetCharge();
					}case CardFamily.Green:{
						if (b.card.family == CardFamily.Green) b.card.resetCharge();
						else if (b.card.family == CardFamily.BlueGreen) b.card.resetCharge();
						else if (b.card.family == CardFamily.GreenYellow) b.card.resetCharge();
						else if (b.card.family == CardFamily.RedGreen) b.card.resetCharge();
					}case CardFamily.Blue:{
						if (b.card.family == CardFamily.Blue) b.card.resetCharge();
						else if (b.card.family == CardFamily.BlueGreen) b.card.resetCharge();
						else if (b.card.family == CardFamily.RedBlue) b.card.resetCharge();
						else if (b.card.family == CardFamily.BlueYellow) b.card.resetCharge();
					}case CardFamily.Yellow:{
						if (b.card.family == CardFamily.Yellow) b.card.resetCharge();
						else if (b.card.family == CardFamily.BlueYellow) b.card.resetCharge();
						else if (b.card.family == CardFamily.GreenYellow) b.card.resetCharge();
						else if (b.card.family == CardFamily.RedYellow) b.card.resetCharge();
					
					}case CardFamily.RedBlue:{
						if (b.card.family == CardFamily.RedBlue) b.card.resetCharge();
						else if (b.card.family == CardFamily.Red) b.card.resetCharge();
						else if (b.card.family == CardFamily.Blue) b.card.resetCharge();
					}case CardFamily.RedGreen:{
						if (b.card.family == CardFamily.RedGreen) b.card.resetCharge();
						else if (b.card.family == CardFamily.Red) b.card.resetCharge();
						else if (b.card.family == CardFamily.Green) b.card.resetCharge();
					}case CardFamily.RedYellow:{
						if (b.card.family == CardFamily.RedYellow) b.card.resetCharge();
						else if (b.card.family == CardFamily.Red) b.card.resetCharge();
						else if (b.card.family == CardFamily.Yellow) b.card.resetCharge();
					}case CardFamily.BlueGreen:{
						if (b.card.family == CardFamily.BlueGreen) b.card.resetCharge();
						else if (b.card.family == CardFamily.Blue) b.card.resetCharge();
						else if (b.card.family == CardFamily.Green) b.card.resetCharge();
					}case CardFamily.BlueYellow:{
						if (b.card.family == CardFamily.BlueYellow) b.card.resetCharge();
						else if (b.card.family == CardFamily.Blue) b.card.resetCharge();
						else if (b.card.family == CardFamily.Yellow) b.card.resetCharge();
					}case CardFamily.GreenYellow:{
						if (b.card.family == CardFamily.GreenYellow) b.card.resetCharge();
						else if (b.card.family == CardFamily.Green) b.card.resetCharge();
						else if (b.card.family == CardFamily.Yellow) b.card.resetCharge();
					
					}case CardFamily.White:{
						if (b.card.family != CardFamily.Black && b.card.family != CardFamily.Equipment && b.card.family != CardFamily.Unplayable)
							b.card.resetCharge();
					}case CardFamily.Black:{
						if (b.card.family == CardFamily.Black) b.card.resetCharge();
					}default:null;
				}
				if (b.card.family == CardFamily.White){
					if (family != CardFamily.Black && family != CardFamily.Equipment && family != CardFamily.Unplayable){
						b.card.resetCharge();
					}
				}
			}
		}
	}
	
	override public function kill()
	{
		this.alive = false;
		this.color = FlxColor.BLACK;
	}
	override public function reviveCharacter(health:Int)
	{
		this.alive = true;
		this.color = FlxColor.WHITE;
		this.giveResources(new Resources([health, 0, 0]));
		this.damageNumbers.addNumber('Revive', Library.damageColors.get(DamageTypes.holy));
	}
	
	override public function update(elapsed:Float)
	{
		if (this.alive){
			if (statusEffects.get(StatusTypes.delayed) > 0){
				owner.setUpdate(false);
				owner.makeInvisible();
			}else{
				owner.setUpdate(true);
				owner.makeVisible();
			}
			
			if (owner.menu != null){
				for (i in 0...handSize()){
					//trace("i",i);
					if (i >= activeCards.length){
						//trace("null");
						var c:PlayerCard = new Redraw(this);
						activeCards.push(c);
						owner.menu.buttons[i].card = cast c;
					}
				}for (i in handSize()...8){
					//trace("J", i);
					if (owner.menu.buttons[i].card != null)
						removeCardSlot(owner.menu.buttons[i].card);
				}
			}
			if (distanced())
				this.y = positionY + 100;
			else
				this.y = positionY;
			this.x = positionX;
		}
		super.update(elapsed);
	}
	
	override public function updateStats()
	{
		super.updateStats();
		
		if (owner.menu != null)
			owner.menu.updateSelection();
	}
}