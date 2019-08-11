package character;
import utilities.button.Button;
import card.CardFamily;
import card.CardType;
import player.playerCards.unplayable.Redraw;
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
	
	public var statusEff:StatusEffects;
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
	public var windupCard:Null<Card> = null;
	public var resolvingCard:Null<Card> = null;
	
	public var positionY:Float = 0.0;
	public var positionX:Float = 0.0;
	
	public function new(source:PlusInterface, x:Int,y:Int,sprite:Int) 
	{
		var size:Int = 96;
		var scale:Float = 1;
		super(source,size, size, x, y, FlxColor.WHITE, 0, Library.cameras.mainCam.flxCam(), false, true, AssetPaths.pokemon_array__png, true, size, size);
		
		positionY = y;
		positionX = x;
		
		//loadGraphic(AssetPaths.pokemon_array__png, true, size, size);
		var scale:Float = 2;
		setGraphicSize(Std.int(size*scale), Std.int(size*scale));
		//offset.x = (size*scale-size)/2;
		//offset.y = offset.x;
		animation.add("base", [sprite]);
		animation.play("base");
		//width = size;
		//height = size;
		
		takesDamageCalls = [for (i in 0...2) []];
		doesDamageCalls = [for (i in 0...2) []];
		
		trace("char new");
		
		Library.characters.add(this);
		
		activeCards = new Deck();
		discard = new Deck(0);
		//trace("char deck");
		
		this.damageNumbers = new DamageNumbers(this);
		
		this.resources = new Resources([100, 15, 10],null,true);
		//trace("char resources");
		this.states = new States();
		
		this.levels = new Levels();
		this.levels.setDefault(LevelsEnum.intelligence, 3);// Math.round(Math.random() * 20));
		//trace("char newlevels");
		this.stats = new Stats();
		//trace("char newstats");
		this.statusEff = new StatusEffects(this, this);
		//trace("char statEffects");
		this.effects = new Effects(this);
		//trace("char effects");
		this.resistances = new Resistances();
		//trace("char resistances");
		this.damageBonus = new DamageBonus();
		//trace("char dmgBonus");
		
		updateStats();
		//trace("char updateStats");
		
		//trace([for (key in DamageTypes.types) resistances.get(key)]);
		trace("char Done");
	}
	
	public function giveResources(resources:Resources)
	{
		this.resources.add(resources);
		//trace(this.resources.get(ResourceTypes.Health));
		if (resources.get(ResourceTypes.health) > 0)
			damageNumbers.addNumber('+'+Std.string(Std.int(resources.get(ResourceTypes.health))), FlxColor.RED);
		if (resources.get(ResourceTypes.stamina) > 0)
			damageNumbers.addNumber('+'+Std.string(Std.int(resources.get(ResourceTypes.stamina))), FlxColor.GREEN);
		if (resources.get(ResourceTypes.mana) > 0)
			damageNumbers.addNumber('+'+Std.string(Std.int(resources.get(ResourceTypes.mana))), FlxColor.BLUE);
	}
	public function removeResources(resources:Resources)
	{
		this.resources.remove(resources);
		//trace(this.resources.get(ResourceTypes.Health));
		if (resources.get(ResourceTypes.health) > 0)
			damageNumbers.addNumber('-'+Std.string(Std.int(resources.get(ResourceTypes.health))), FlxColor.RED);
		if (resources.get(ResourceTypes.stamina) > 0)
			damageNumbers.addNumber('-'+Std.string(Std.int(resources.get(ResourceTypes.stamina))), FlxColor.GREEN);
		if (resources.get(ResourceTypes.mana) > 0)
			damageNumbers.addNumber('-'+Std.string(Std.int(resources.get(ResourceTypes.mana))), FlxColor.BLUE);
	}
	public function giveStatusEffect(type:StatusTypes,value:Float)
	{
		this.statusEff.addStatus(type, value);
	}
	
	public function takesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		if (cardType == null)
			cardType = new CardType();
		
		var f:Float = value;
		
		for (fun in takesDamageCalls[0]) f = fun(types, f, cardType, source);
		
		f = effects.takesDamage1(types, f, cardType, source);
		
		//trace('takeDmg','f', f, 'types', types);
		f = resistances.takesDamage(types, f, cardType, source);
		//trace('resistances',f);
		f = stats.takesDamage(types, f, cardType, source);
		//trace('stats',f);
		f = statusEff.takesDamage(types, f, cardType, source);
		//trace('statusEff',f);
		f = Math.max(f, 1);
		f = effects.takesDamage2(types, f, cardType, source);
		//trace('effects',f);
		
		for (fun in takesDamageCalls[1]) f = fun(types, f, cardType, source);
		
		trace("takeDamage", f);
		resources.removeResource(ResourceTypes.health, f);
		trace("health", resources.get(ResourceTypes.health));
		
		if (f < 1 && f>0) f = 1;
		if (f <= 0.0)
			damageNumbers.addNumber("Block", Library.damageColors.get(types[0]));
		else
			damageNumbers.addNumber(Std.string(Math.round(f)), Library.damageColors.get(types[0]));
		
		return f;
		
	}
	public function doesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		if (cardType == null)
			cardType = new CardType();
		
		var f:Float = value;
		
		for (fun in doesDamageCalls[0]) f = fun(types, f, cardType, source);
		
		//trace('DoDmg','f', f, 'types', types);
		f = statusEff.doesDamage(types, f, cardType, source);
		//trace('statusEff',f);
		f = stats.doesDamage(types, f, cardType, source);
		//trace('stats',f);
		f = damageBonus.doesDamage(types, f, cardType, source);
		//trace('damageBonus',f);
		f = effects.doesDamage(types, f, cardType, source);
		//trace('effects',f);
		
		for (fun in doesDamageCalls[1]) f = fun(types, f, cardType, source);
		
		trace('doesDamage', f);
		return f;
		
	}
	
	public function setTeam(team:Null<Team>)
	{
		if (this.team != null)
			this.team.remove(this);
		this.team = team;
		if (this.team != null)
			team.add(this);
	}
	public function getTeam():Null<Team>
	{
		return team;
	}
	
	public function targetThis(source:Card):Character
	{	
		var target:Character = effects.targetThis(source, this);
		
		return target;
	}
	public function canBeTargetedBy(source:Card):Bool
	{
		return canBeTargetedByType(source.cardType);
	}
	public function canBeTargetedByType(type:CardType):Bool
	{
		if (type.melee() && this.states.distanced && !type.charge()) return false;//&& !type.flying()
		
		return true;
	}
	
	public function discardCard(card:Card){}
	public function drawCard():Bool
	{
		if (discard.length <= 0) return false;
		else return true;
	}
	public function addCard(card:Card)
	{
		if (activeCards.length < handSize()){
			activeCards.push(card);
		}else{
			discard.push(card);
		}
	}
	public function cardsInHand():Array<Card>
	{
		//THESE CAN CHANGE. USE IMMEDIATELY. DO NOT TRACK
		return [for (card in activeCards.knownCards) if (card.family != CardFamily.Unplayable) card];
	}
	
	override public function update(elapsed:Float):Void
	{
		if (statusEff.get(StatusTypes.delayed) > 0){
			setUpdate(false);
		}else{
			setUpdate(true);
		}
		if (this.resources.get(ResourceTypes.health) <= 0 && this.alive){
			trace("kill",this.alive);
			this.kill();
		}
		super.update(elapsed);
	}
	override public function plusUpdate(elapsed:Float):Void
	{
		super.plusUpdate(elapsed);
		if (this.alive){
			
			resources.update(elapsed);
			
		}
	}
	
	
	public function updateStats()
	{
		//trace("bonusDmg");
		stats.setDefault(StatsEnum.bonusDmg, Library.statTables.bonusDmg[strength()]);
		//trace("speed");
		stats.setDefault(StatsEnum.speed, Library.statTables.speed[dexterity()]);
		//trace("maxHealth");
		stats.setDefault(StatsEnum.maxHealth, Library.statTables.maxHealth[constitution()]);
		//trace("dmgResistance");
		stats.setDefault(StatsEnum.dmgResistance, Library.statTables.dmgResistance[resilience()]);
		//trace("staminaRegen");
		stats.setDefault(StatsEnum.staminaRegen, Library.statTables.staminaRegen[endurace()]);
		//trace("stamina");
		stats.setDefault(StatsEnum.stamina, Library.statTables.stamina[endurace()]);
		//trace("magicRegen");
		stats.setDefault(StatsEnum.manaRegen, Library.statTables.manaRegen[wisdom()]);
		//trace("mana");
		stats.setDefault(StatsEnum.mana, Library.statTables.mana[wisdom()]);
		//trace("magicDmg");
		stats.setDefault(StatsEnum.magicDmg, Library.statTables.magicDmg[willpower()]);
		//trace("handSize");
		stats.setDefault(StatsEnum.handSize, Library.statTables.handSize[intelligence()]);
		//trace("drawSpeed");
		stats.setDefault(StatsEnum.drawSpeed, Library.statTables.drawSpeed[intelligence()]);
		//trace("insight");
		stats.setDefault(StatsEnum.perception, Library.statTables.perception[insight()]);
		//trace("updateStats");
		
		if (staminaRegen() > 0.0)
			resources.setRate(ResourceTypes.stamina, 9 / (1 + staminaRegen()));
		else
			resources.setRate(ResourceTypes.stamina, 9 * (1 - staminaRegen()));
		if (manaRegen() > 0.0)
			resources.setRate(ResourceTypes.mana, 6 / (1 + manaRegen()));
		else
			resources.setRate(ResourceTypes.mana, 6 * (1 - manaRegen()));
		
		resources.setCap(ResourceTypes.health, maxHealth());
		resources.setCap(ResourceTypes.stamina, stamina());
		resources.setCap(ResourceTypes.mana, mana());
	}
	
	public function handSize():Int{
		return Std.int(stats.get(StatsEnum.handSize));
	}public function speed():Float{
		return stats.get(StatsEnum.speed);
	}public function drawSpeed():Float{
		return stats.get(StatsEnum.drawSpeed);
	}public function bonusDmg():Float{
		return stats.get(StatsEnum.bonusDmg);
	}public function maxHealth():Int{
		return Std.int(stats.get(StatsEnum.maxHealth));
	}public function dmgResistance():Float{
		return stats.get(StatsEnum.dmgResistance);
	}public function staminaRegen():Float{
		return stats.get(StatsEnum.staminaRegen);
	}public function stamina():Int{
		return Std.int(stats.get(StatsEnum.stamina));
	}public function manaRegen():Float{
		return stats.get(StatsEnum.manaRegen);
	}public function mana():Int{
		return Std.int(stats.get(StatsEnum.mana));
	}public function magicDmg():Float{
		return stats.get(StatsEnum.magicDmg);
	}public function perception():Float{
		return stats.get(StatsEnum.perception);
	}
	
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