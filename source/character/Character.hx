package character;

import utilities.button.Button;
import card.CardFamily;
import card.CardType;
import character.damage.DamageTypes;
import character.damageBonus.DamageBonus;
import character.damageNumbers.DamageNumbers;
import character.effects.Effects;
import character.resistances.Resistances;
import character.states.States;
import character.stats.Levels;
import character.stats.LevelsEnum;
import character.stats.Stats;
import character.stats.StatsEnum;
import character.deck.Deck;
import flixel.util.FlxColor;
import library.StatTables;
import player.Player;
import character.resources.ResourceTypes;
import character.resources.Resources;
import library.Cameras;
import card.Card;
import character.statusEffects.StatusEffects;
import character.statusEffects.StatusTypes;
import team.Team;
import utilities.plusInterface.PlusInterface;
import library.Library;

/**
 * ...
 * @author ...
 */
class Character extends Button
{	
	public var resources:Resources;
	
	private var team:Null<Team> = null;
	
	public var discard:Deck;
	public var activeCards:Deck;
	
	public var statusEffects:StatusEffects;
	public var effects:Effects;
	public var states:States;
	
	public var resistances:Resistances;
	public var damageBonus:DamageBonus;
	public var takesDamageCalls:Array<Array<Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float>> = [];
	public var doesDamageCalls:Array<Array<Array<DamageTypes>->Float->Null<CardType>->Null<Character>->Float>> = [];
	public var damageNumbers:DamageNumbers;
	
	public var stats:Stats;
	public var levels:Levels;
	
	public var onDeckCard:Null<Card> = null;
	
	public var positionY:Float = 0.0;
	public var positionX:Float = 0.0;
	
	public function new(source:PlusInterface, x:Int,y:Int,sprite:Int) 
	{
		var size:Int = 96;
		var scale:Float = 1;
		super(source,size, size, x, y, FlxColor.WHITE, 0, Library.cameras.mainCam.flxCam(), false, true, AssetPaths.pokemon_array__png, true, size, size);
		
		positionY = y; //base position of character. Position on screen can be different (for example distanced)
		positionX = x;
		
		var scale:Float = 2;
		setGraphicSize(Std.int(size*scale), Std.int(size*scale));
		animation.add("base", [sprite]);
		animation.play("base");
		
		takesDamageCalls = [for (i in 0...2) []];
		doesDamageCalls = [for (i in 0...2) []];
		
		//trace("char new");
		
		Library.characters.add(this);
		
		activeCards = new Deck(); //character's hand of cards
		discard = new Deck(0); //character's discard. These cards are in an undeterminded order (drawn at random)
		//trace("char deck");
		
		this.damageNumbers = new DamageNumbers(this); //damage numbers displayed above character
		
		this.resources = new Resources([100, 15, 10],null,true); //base values. These are changed when updateStats() is called
		//trace("char resources");
		this.states = new States(); // character states (distanced, flying, etc...)
		
		this.levels = new Levels(); //ability levels (strength, dex, int, etc...)
		//trace("char newlevels");
		this.stats = new Stats(); //character stats (hand size, damage resistance, etc...)
		//trace("char newstats");
		this.statusEffects = new StatusEffects(this, this); //status effects (hot, cold, wet, rage, ect...)
		//trace("char statEffects");
		this.effects = new Effects(this); //effects (like status effects but for more complicated effects) (guard, barrier, blessing, curse, defender, etc...)
		//trace("char effects");
		this.resistances = new Resistances(); //elemental damage resistances
		//trace("char resistances");
		this.damageBonus = new DamageBonus(); //elemental damage bonuses
		//trace("char dmgBonus");
		
		updateStats();
		//trace("char updateStats");
		
		//trace([for (key in DamageTypes.types) resistances.get(key)]);
		trace("char Done");
	}
	
	public function giveResources(resources:Resources) //shortcut to add resources to character and display damageNumbers
	{
		this.resources.add(resources);
		if (resources.get(ResourceTypes.health) > 0)
			damageNumbers.addNumber('+'+Std.string(Std.int(resources.get(ResourceTypes.health))), FlxColor.RED);
		if (resources.get(ResourceTypes.stamina) > 0)
			damageNumbers.addNumber('+'+Std.string(Std.int(resources.get(ResourceTypes.stamina))), FlxColor.GREEN);
		if (resources.get(ResourceTypes.mana) > 0)
			damageNumbers.addNumber('+'+Std.string(Std.int(resources.get(ResourceTypes.mana))), FlxColor.BLUE);
	}
	public function removeResources(resources:Resources) //shortcut to remove resources from character and display damageNumbers
	{
		this.resources.remove(resources);
		if (resources.get(ResourceTypes.health) > 0)
			damageNumbers.addNumber('-'+Std.string(Std.int(resources.get(ResourceTypes.health))), FlxColor.RED);
		if (resources.get(ResourceTypes.stamina) > 0)
			damageNumbers.addNumber('-'+Std.string(Std.int(resources.get(ResourceTypes.stamina))), FlxColor.GREEN);
		if (resources.get(ResourceTypes.mana) > 0)
			damageNumbers.addNumber('-'+Std.string(Std.int(resources.get(ResourceTypes.mana))), FlxColor.BLUE);
	}
	public function giveStatusEffect(type:StatusTypes,value:Float)
	{
		this.statusEffects.addStatus(type, value);
	}
	
	public function takesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	//                         array of damage types   , damage value, cardType (can be blank)       , source of damage (sould be blank if you dont want it to trigger additional effects)
	{
		if (types.length == 0) types = [DamageTypes.physical];
		
		if (cardType == null)
			cardType = new CardType();
		
		var f:Float = value;
		
		for (fun in takesDamageCalls[0]) f = fun(types, f, cardType, source); //start of function damage calls
		
		f = effects.takesDamage1(types, f, cardType, source); //defender, barrier
		
		//trace('takeDmg','f', f, 'types', types);
		f = resistances.takesDamage(types, f, cardType, source); //damage reduction from resistances
		//trace('resistances',f);
		f = stats.takesDamage(types, f, cardType, source); //dmgResistance
		//trace('stats',f);
		f = statusEffects.takesDamage(types, f, cardType, source); //wet, cold, hot, rage
		//trace('statusEffects',f);
		f = effects.takesDamage2(types, f, cardType, source); //guard
		//trace('effects',f);
		
		for (fun in takesDamageCalls[1]) f = fun(types, f, cardType, source); //end of function damage calls
		
		f = Math.round(Math.max(f + 0.499999, 0)); //round up and make sure it isn't negative
		
		//trace("takeDamage", f);
		resources.removeResource(ResourceTypes.health, f);
		//trace("health", resources.get(ResourceTypes.health));
		
		if (f <= 0.0) //display damage has been blocked if damage reduced <= 0
			damageNumbers.addNumber("Block", Library.damageColors.get(types[0]));
		else //else display damage
			damageNumbers.addNumber(Std.string(Math.round(f)), Library.damageColors.get(types[0]));
		
		return f;
		
	}
	public function doesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	//                         array of damage types   , damage value, cardType (can be blank)       , source of damage (sould be blank if you dont want it to trigger additional effects)
	{
		if (types.length == 0) types = [DamageTypes.physical];
		
		if (cardType == null)
			cardType = new CardType();
		
		var f:Float = value;
		
		for (fun in doesDamageCalls[0]) f = fun(types, f, cardType, source); //start of function damage calls
		
		//trace('DoDmg','f', f, 'types', types);
		f = statusEffects.doesDamage(types, f, cardType, source); //wet, cold, hot, rage
		//trace('statusEffects',f);
		f = stats.doesDamage(types, f, cardType, source); //meleeDmg, magicDmg
		//trace('stats',f);
		f = damageBonus.doesDamage(types, f, cardType, source); //elemental damage bonuses
		//trace('damageBonus',f);
		f = effects.doesDamage(types, f, cardType, source); //none yet
		//trace('effects',f);
		
		for (fun in doesDamageCalls[1]) f = fun(types, f, cardType, source);  //end of function damage calls
		
		if (cardType != null && cardType.melee() && distanced()) distanced(false);
		
		if (combos() && types.indexOf(DamageTypes.physical) >= 0)
			if (f >= 1)
				effects.addCombo();
		
		//trace('doesDamage', f);
		return f;
		
	}
	
	public function setTeam(team:Null<Team>) //set team. Can only be on one team or on no team (null = no team)
	{
		if (this.team != null)
			this.team.remove(this);
		this.team = team;
		if (this.team != null)
			team.add(this);
	}
	public function getTeam():Null<Team> //get team
	{
		return team;
	}
	
	public function targetThis(source:Card):Character //allows effects to trigger on being targeted
	{	
		var target:Character = effects.targetThis(source, this);
		
		return target;
	}
	public function canBeTargetedBy(source:Card):Bool //check if this carn be targeted by a card
	{
		return canBeTargetedByType(source.cardType);
	}
	public function canBeTargetedByType(type:CardType):Bool //check if this carn be targeted by a CardType
	{
		if (type.melee() && this.states.distanced && !type.charge()) return false;//&& !type.flying()
		
		return true;
	}
	
	public function chooseTarget(card:Card){}
	
	public function discardCard(card:Card){} //emplemented by PlayerCharacter and MonsterCharacter
	public function drawCard():Bool //
	{
		if (discard.length <= 0) return false;
		else return true;
	}
	public function addCard(card:Card) //give the character a card
	{
		if (activeCards.length < handSize()){
			activeCards.push(card);
		}else{
			discard.push(card);
		}
	}
	public function cardsInHand():Array<Card> //cards currently in characters hand
	{
		//THESE CAN CHANGE. USE IMMEDIATELY. DO NOT TRACK
		return [for (card in activeCards.knownCards) if (card.family != CardFamily.Unplayable) card];
	}
	
	override public function update(elapsed:Float):Void
	{
		if (statusEffects.get(StatusTypes.delayed) > 0){ //skip plusUpdate if this is delayed
			setUpdate(false);
		}else{
			setUpdate(true);
		}
		if (this.resources.get(ResourceTypes.health) <= 0 && this.alive){ //losing too much health kills
			trace("kill",this.alive);
			this.kill();
		}
		super.update(elapsed);
	}
	override public function plusUpdate(elapsed:Float):Void
	{
		super.plusUpdate(elapsed);
		if (this.alive){
			resources.update(elapsed); //resources are not plusInterface enabled, so they must be updated manually
		}
	}
	
	
	public function updateStats()
	{
		//update individual stats based on levels
		stats.setDefault(StatsEnum.meleeDmg, Library.statTables.meleeDmg[strength()]);
		stats.setDefault(StatsEnum.speed, Library.statTables.speed[dexterity()]);
		stats.setDefault(StatsEnum.maxHealth, Library.statTables.maxHealth[constitution()]);
		stats.setDefault(StatsEnum.dmgResistance, Library.statTables.dmgResistance[resilience()]);
		stats.setDefault(StatsEnum.staminaRegen, Library.statTables.staminaRegen[endurace()]);
		stats.setDefault(StatsEnum.maxStamina, Library.statTables.maxStamina[endurace()]);
		stats.setDefault(StatsEnum.manaRegen, Library.statTables.manaRegen[wisdom()]);
		stats.setDefault(StatsEnum.maxMana, Library.statTables.maxMana[wisdom()]);
		stats.setDefault(StatsEnum.magicDmg, Library.statTables.magicDmg[willpower()]);
		stats.setDefault(StatsEnum.handSize, Library.statTables.handSize[intelligence()]);
		stats.setDefault(StatsEnum.drawSpeed, Library.statTables.drawSpeed[intelligence()]);
		stats.setDefault(StatsEnum.perception, Library.statTables.perception[insight()]);
		
		//update staminaRegen and manaRegen in resources
		if (staminaRegen() > 0.0)
			resources.setRate(ResourceTypes.stamina, 9 / (1 + staminaRegen()));
		else
			resources.setRate(ResourceTypes.stamina, 9 * (1 - staminaRegen()));
		if (manaRegen() > 0.0)
			resources.setRate(ResourceTypes.mana, 6 / (1 + manaRegen()));
		else
			resources.setRate(ResourceTypes.mana, 6 * (1 - manaRegen()));
		
		//update resource caps
		resources.setCap(ResourceTypes.health, maxHealth());
		resources.setCap(ResourceTypes.stamina, maxStamina());
		resources.setCap(ResourceTypes.mana, maxMana());
	}
	
	//shortcuts to return each of the players stats
	public function handSize():Int{
		return Std.int(stats.get(StatsEnum.handSize));
	}public function speed():Float{
		return stats.get(StatsEnum.speed);
	}public function drawSpeed():Float{
		return stats.get(StatsEnum.drawSpeed);
	}public function meleeDmg():Float{
		return stats.get(StatsEnum.meleeDmg);
	}public function maxHealth():Int{
		return Std.int(stats.get(StatsEnum.maxHealth));
	}public function dmgResistance():Float{
		return stats.get(StatsEnum.dmgResistance);
	}public function staminaRegen():Float{
		return stats.get(StatsEnum.staminaRegen);
	}public function maxStamina():Int{
		return Std.int(stats.get(StatsEnum.maxStamina));
	}public function manaRegen():Float{
		return stats.get(StatsEnum.manaRegen);
	}public function maxMana():Int{
		return Std.int(stats.get(StatsEnum.maxMana));
	}public function magicDmg():Float{
		return stats.get(StatsEnum.magicDmg);
	}public function perception():Float{
		return stats.get(StatsEnum.perception);
	}
	
	//shortcuts to return each of the players levels
	public function strength(?value:Null<Int>):Int{
		if (value != null) levels.setDefault(LevelsEnum.strength, value);
		return levels.get(LevelsEnum.strength);
	}public function dexterity(?value:Null<Int>):Int{
		if (value != null) levels.setDefault(LevelsEnum.dexterity, value);
		return levels.get(LevelsEnum.dexterity);
	}public function endurace(?value:Null<Int>):Int{
		if (value != null) levels.setDefault(LevelsEnum.endurace, value);
		return levels.get(LevelsEnum.endurace);
	}public function constitution(?value:Null<Int>):Int{
		if (value != null) levels.setDefault(LevelsEnum.constitution, value);
		return levels.get(LevelsEnum.constitution);
	}public function resilience(?value:Null<Int>):Int{
		if (value != null) levels.setDefault(LevelsEnum.resilience, value);
		return levels.get(LevelsEnum.resilience);
	}public function intelligence(?value:Null<Int>):Int{
		if (value != null) levels.setDefault(LevelsEnum.intelligence, value);
		return levels.get(LevelsEnum.intelligence);
	}public function wisdom(?value:Null<Int>):Int{
		if (value != null) levels.setDefault(LevelsEnum.wisdom, value);
		return levels.get(LevelsEnum.wisdom);
	}public function willpower(?value:Null<Int>):Int{
		if (value != null) levels.setDefault(LevelsEnum.willpower, value);
		return levels.get(LevelsEnum.willpower);
	}public function insight(?value:Null<Int>):Int{
		if (value != null) levels.setDefault(LevelsEnum.insight, value);
		return levels.get(LevelsEnum.insight);
	}
	
	//shortcut to return each of the players states
	public function distanced(?setTo:Null<Bool>):Bool{
		if (setTo != null) states.distanced = setTo;
		return states.distanced;
	}public function flying(?setTo:Null<Bool>):Bool{
		if (setTo != null) states.flying = setTo;
		return states.flying;
	}public function combos(?setTo:Null<Bool>):Bool{
		if (setTo != null) states.combos = setTo;
		return states.combos;
	}
	
	override public function kill(){}
	public function reviveCharacter(health:Int) {}
	
	override public function destroy()
	{
		Library.characters.remove(this);
		super.destroy();
	}
}