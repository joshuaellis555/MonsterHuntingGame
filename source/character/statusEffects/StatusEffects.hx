package character.statusEffects;
import card.CardType;
import character.Character;
import character.stats.Stats;
import character.stats.StatsEnum;
import utilities.event.Event;
import flixel.util.FlxColor;
import player.Player;
import character.resources.ResourceTypes;
import character.statusEffects.StatusTypes;
import character.damage.DamageTypes;
import utilities.plusInterface.BasicPlus;
import utilities.plusInterface.PlusInterface;
import library.Library;
//import Type;

/**
 * ...
 * @author ...
 */
class StatusEffects extends BasicPlus
{
	private var statusMap:Map<StatusTypes, Null<Float>>;
	
	private var statsMods:Stats;
	
	private var owner:Null<Character>;
	
	private var timers:Map<StatusTypes, Float>;
	
	public function new(source:PlusInterface, ?owner:Null<Character>=null,?statusEffects:Null<Array<Null<Float>>>=null)
	{
		super(source);
		
		ID = Library.uniqueIDBot.get();
		
		this.owner = owner;
		if (statusEffects == null){
			statusEffects = [];
			for (key in Type.allEnums(StatusTypes))
				statusEffects.push(0.0);
		}
		statusMap = new Map<StatusTypes, Null<Float>>();
		timers = new Map<StatusTypes, Float>();
		var i:Int = 0;
		for (key in Type.allEnums(StatusTypes)){
			if (i < statusEffects.length){
				if (statusEffects[i] != null){
					timers[key] = 0.0;
					statusMap[key] = statusEffects[i];
				}
			}else{
				statusMap[key] = null;
			}
			i++;
		}
		
		if (owner != null){
			statsMods = new Stats();
			owner.stats.add(ID, statsMods);
		}
		
		forceUpdate = true;
	}
	
	public function get(type:StatusTypes):Null<Float>
	{
		return statusMap[type];
	}
	public function getMap():Map<StatusTypes, Null<Float>>
	{
		return statusMap;
	}
	
	public function set(statusEffects:StatusEffects)
	{
		statusMap = statusEffects.getMap();
	}
	public function setStatus(type:StatusTypes, value:Null<Float>)
	{
		statusMap[type] = value;
	}
	
	public function add(statusEffects:StatusEffects)
	{
		for (type in Type.allEnums(StatusTypes))
		{
			if (statusEffects.get(type) != null) addStatus(type,statusEffects.get(type));
		}
	}
	public function addStatus(type:StatusTypes, value:Float)
	{
		//trace('addStatus');
		if (statusMap[type] == null) return;
		
		if (value > statusMap[type]) statusMap[type] = value;
		if (statusMap[type] > 9999) statusMap[type] = 9999;
		if (statusMap[type] < 0) statusMap[type] = 0;
	}
	override public function plusUpdate(elapsed:Float)
	{
		super.plusUpdate(elapsed);
		
		//trace('update');
		if (owner == null) return;
		
		if (statusMap[StatusTypes.hot] > 0.0 && statusMap[StatusTypes.cold] > 0.0){
			var hot:Float = statusMap[StatusTypes.hot];
			var cold:Float = statusMap[StatusTypes.cold];
			statusMap[StatusTypes.cold] -= hot;
			statusMap[StatusTypes.hot] -= cold;
			if (statusMap[StatusTypes.hot] <= 0.0) statusMap[StatusTypes.hot] = 0.1;
			if (statusMap[StatusTypes.cold] <= 0.0) statusMap[StatusTypes.cold] = 0.1;
		}
		if (statusMap[StatusTypes.wet] > 0.0 && statusMap[StatusTypes.hot] > 0.0){
			statusMap[StatusTypes.wet] -= elapsed;
			if (statusMap[StatusTypes.wet] <= 0.0) statusMap[StatusTypes.wet] = 0.1;
		}
		
		if (statusMap[StatusTypes.drugged] > 0.0)
			statsMods.setDefault(StatsEnum.drawSpeed, -1);
		else
			statsMods.setDefault(StatsEnum.drawSpeed, 0);
			
		if (statusMap[StatusTypes.slow] > 0.0)
			statsMods.setDefault(StatsEnum.speed, -1);
		else
			statsMods.setDefault(StatsEnum.speed, 0);
			
		if (statusMap[StatusTypes.rage] > 0.0){
			statsMods.setDefault(StatsEnum.bonusDmg, 0.5);
			statsMods.setDefault(StatsEnum.dmgResistance, -0.5);
		}else{
			statsMods.setDefault(StatsEnum.bonusDmg, 0);
			statsMods.setDefault(StatsEnum.dmgResistance, 0);
		}
		
		for (key in Type.allEnums(StatusTypes)){
			if (statusMap[key]  > 0.0){
				//trace('start',key);
				timers[key] += elapsed;
				
				//trigger status effect timers
				if (timers[key] >= 1.0){
					switch(key)
					{
						case StatusTypes.burn:{
							owner.takesDamage([DamageTypes.fire], owner.resources.get(ResourceTypes.health) / 20);
						}
						default:null;
					}
					timers[key] -= 1.0;
				}
				if (statusMap[key] > 0.0) statusMap[key] -= elapsed;
				if (statusMap[key] < 0.0) statusMap[key] = 0.0;	
				if (statusMap[key] == 0.0) timers[key] == 0.0;
				//trace('end',key);
			}		
		}
		//trace('asdf');
		owner.stats.update(ID, statsMods);
		//trace('statsMods');
	}
	public function takesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		//trace(value);
		if (owner == null) return 0;
		
		for (type in types){
			if (statusMap[StatusTypes.wet] > 0.0){
				if (type == DamageTypes.fire){
					statusMap[StatusTypes.wet] = 0.1;
					value /= 1 + 1 / types.length;
				}
				if (type == DamageTypes.lightning) value *= 1 + 1 / types.length;	
			}
			if (statusMap[StatusTypes.cold] > 0.0){
				if (type == DamageTypes.fire){
					statusMap[StatusTypes.cold] = 0.1;
					value /= 1 + 1 / types.length;
				}
				if (type == DamageTypes.cold) value *= 1 + 1 / types.length;	
			}
			if (statusMap[StatusTypes.hot] > 0.0){
				if (type == DamageTypes.cold){
					statusMap[StatusTypes.hot] = 0.1;
					value /= 1 + 1 / types.length;
				}
				if (type == DamageTypes.fire) value *= 1 + 1 / types.length;	
			}
			if (statusMap[StatusTypes.rage] > 0.0){
				if (type == DamageTypes.physical)
					value /= 1 + 0.5 / types.length;
				if (type == DamageTypes.psychic)
					value *= 1 + 1 / types.length;
			}
		}
		return value;
	}
	public function doesDamage(types:Array<DamageTypes>, value:Float, ?cardType:Null<CardType> = null, ?source:Null<Character> = null):Float
	{
		//trace(value);
		if (owner == null) return 0;
		
		for (type in types){
			if (statusMap[StatusTypes.wet] > 0.0){
				if (type == DamageTypes.fire){
					value /= 1 + 1 / types.length;
				}
				if (type == DamageTypes.lightning){
					owner.takesDamage([DamageTypes.lightning], value / types.length / 2);
				}
			}
			if (statusMap[StatusTypes.cold] > 0.0){
				if (type == DamageTypes.fire){
					value /= 1 + 1 / 3 / types.length;
				}
			}
			if (statusMap[StatusTypes.hot] > 0.0){
				if (type == DamageTypes.cold){
					value /= 1 + 1 / 3 / types.length;
				}
			}
			if (statusMap[StatusTypes.rage] > 0.0){
				if (type == DamageTypes.physical && cardType != null){
					if (cardType.melee() == true)
						value *= 1 + (1.2 - owner.resources.get(ResourceTypes.health) / owner.maxHealth()) / types.length;
				}
			}
		}
		return value;
	}
}