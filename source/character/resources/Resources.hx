package character.resources;
import utilities.event.Event;
import flixel.util.FlxColor;
import character.resources.ResourceTypes;
import utilities.plusInterface.BasicPlus;

/**
 * ...
 * @author ...
 */
class Resources //extends BasicPlus
{
	private var ResourceMap:Map<ResourceTypes, Null<Float>>;
	private var caps:Map<ResourceTypes, Null<Int>>;
	
	private var timers:Null<Map<ResourceTypes,Float>>=null;
	private var rates:Map<ResourceTypes,Float>;
	
	public function new(caps:Array<Null<Int>>, ?resources:Null<Array<Null<Float>>>=null, ?useTimers:Bool=false) 
	{
		if (resources == null){
			
			resources = [];
			for (i in 0...caps.length){
				if (caps[i]==null)
					resources.push(0);
				else
					resources.push(caps[i]);
			}
		}
		ResourceMap = new Map<ResourceTypes, Null<Float>>();
		this.caps = new Map<ResourceTypes, Null<Int>>();
		var i:Int = 0;
		for (key in Type.allEnums(ResourceTypes)){
			if (i < resources.length){
				if (resources[i] != null)
					ResourceMap[key] = resources[i];
				else
					ResourceMap[key] = null;
			}else{
				ResourceMap[key] = null;
			}
			if (i < caps.length){
				if (caps[i] != null)
					this.caps[key] = caps[i];
				else
					this.caps[key] = null;
			}else{
				this.caps[key] = null;
			}
			i++;
		}
		
		
		if (useTimers){
			timers = new Map<ResourceTypes,Float>();
			rates = new Map<ResourceTypes,Float>();
			for (key in Type.allEnums(ResourceTypes)){
				timers[key] = 0.0;
				rates[key] = 0.0;
			}
		}
	}
	
	public function getCap(type:ResourceTypes):Null<Int>
	{
		return caps[type];
	}
	public function setCap(type:ResourceTypes, value:Null<Int>)
	{
		//trace('setCap', ResourceMap[type], caps[type], value);
		
		if (ResourceMap[type] > value){
			ResourceMap[type] = value;
			caps[type] = value;
		}else if (value > caps[type]){
			var increase:Float = value - caps[type];
			caps[type] = value;
			addResource(type, increase);
		}
		//trace('setCap end', ResourceMap[type], caps[type], value);
	}
	
	public function get(type:ResourceTypes):Null<Float>
	{
		return ResourceMap[type];
	}
	public function getMap():Map<ResourceTypes, Null<Float>>
	{
		return ResourceMap;
	}
	
	public function setResources(resources:Resources)
	{
		ResourceMap = getMap();
	}
	public function set(type:ResourceTypes, value:Null<Float>)
	{
		ResourceMap[type] = value;
	}
	
	public function add(resources:Resources)
	{
		for (type in Type.allEnums(ResourceTypes))
		{
			if (ResourceMap[type] != null && resources.get(type) != null) ResourceMap[type] += resources.get(type);
			if (ResourceMap[type] > 9999) ResourceMap[type] = 9999;
			if (caps[type] != null) if (ResourceMap[type] > caps[type]) ResourceMap[type] = caps[type];
			if (ResourceMap[type] < 0) ResourceMap[type] = 0;
		}
	}
	public function addResource(type:ResourceTypes, value:Float)
	{
		if (ResourceMap[type] != null) ResourceMap[type] += value;
		if (ResourceMap[type] > 9999) ResourceMap[type] = 9999;
		if (caps[type] != null) if (ResourceMap[type] > caps[type]) ResourceMap[type] = caps[type];
		if (ResourceMap[type] < 0) ResourceMap[type] = 0;
	}
	
	public function multiply(multiplyer:Array<Float>)
	{
		var i:Int = 0;
		for (type in Type.allEnums(ResourceTypes))
		{
			if (ResourceMap[type] != null) ResourceMap[type] = ResourceMap[type] * multiplyer[i];
			if (ResourceMap[type] > 9999) ResourceMap[type] = 9999;
			if (caps[type] != null) if (ResourceMap[type] > caps[type]) ResourceMap[type] = caps[type];
			if (ResourceMap[type] < -9999) ResourceMap[type] = -9999;
			i++;
		}
	}
	public function retMultiply(multiplyer:Array<Null<Float>>):Resources
	{
		var c:Resources = this.copy();
		var i:Int = 0;
		for (type in Type.allEnums(ResourceTypes))
		{
			if (c.get(type) != null && multiplyer[i] != null) c.set(type, c.get(type) * multiplyer[i]);
			if (multiplyer[i] == null){
				c.set(type, null);
			}else{
				if (c.get(type) > 9999) c.set(type, 9999);
				if (caps[type] != null) if (c.get(type) > caps[type]) c.set(type, caps[type]);
				if (c.get(type) < -9999) c.set(type, -9999);
			}
			i++;
		}
		return c;
	}
	
	public function remove(resources:Resources,?check:Bool=false,?allowNeg:Bool=false):Null<Bool>
	{
		//trace('remove', check, allowNeg);
		if (allowNeg){
			for (type in Type.allEnums(ResourceTypes))
			{
				if (resources.get(type) == null || ResourceMap[type] == null) continue;
				ResourceMap[type] -= resources.get(type);
			}
		}else if (check){
			for (type in Type.allEnums(ResourceTypes))
			{
				//trace('remove check', resources.get(type), ResourceMap[type],type);
				if (resources.get(type) == null || ResourceMap[type] == null) continue;
				
				if (ResourceMap[type] < resources.get(type))
				{
					return false;
				} else 
					if (type == ResourceTypes.health && ResourceMap[type] == resources.get(type))
						return false; //Dont spend last health
			}
			for (type in Type.allEnums(ResourceTypes))
			{
				if (resources.get(type) == null) continue;
				if (ResourceMap[type] == null) continue;
				ResourceMap[type] -= resources.get(type);
			}
		}else{
			for (type in Type.allEnums(ResourceTypes))
			{
				if (resources.get(type) == null || ResourceMap[type] == null) continue;
				
				if (ResourceMap[type] < resources.get(type)){
					ResourceMap[type] = 0;
				}else{
					ResourceMap[type] -= resources.get(type);
				}
			}
		}
		return true;
	}
	public function removeResource(type:ResourceTypes, value:Float,?check:Bool=false,?allowNeg:Bool=false):Null<Bool>
	{
		if (ResourceMap[type] == null) return null;
		if (allowNeg){
			ResourceMap[type] -= value;
		}else if (check){
			if (ResourceMap[type] < value)
			{
				return false;
			}
			ResourceMap[type] -= value;
		}else{
			if (ResourceMap[type] < value){
				ResourceMap[type] = 0;
			}else{
				ResourceMap[type] -= value;
			}
		}
		return true;
	}
	
	public function check(resources:Resources):Null<Bool>
	{
		for (type in Type.allEnums(ResourceTypes))
		{
			if (resources.get(type) == null || ResourceMap[type] == null) continue;
			
			if (ResourceMap[type] < resources.get(type))
			{
				return false;
			} else
				if (type == ResourceTypes.health && ResourceMap[type] == resources.get(type))
						return false; //Dont spend last health
		}
		return true;
	}
	
	public function length():Int
	{
		var l = 0;
		for (key in ResourceMap.keys())
		{
			if (ResourceMap[key] != null) l += 1;
		}
		return l;
	}
	public function types():Array<ResourceTypes>
	{
		var a:Array<ResourceTypes>;
		a = [];
		for (type in Type.allEnums(ResourceTypes))
		{
			if (ResourceMap[type] != null) a.push(type);
		}
		return a;
	}
	public function copy():Resources
	{
		var c:Resources = new Resources([0, 0, 0, 0, 0]);
		for (type in Type.allEnums(ResourceTypes))
			c.set(type, ResourceMap[type]);
		return c;
	}
	
	public function setRate(type:ResourceTypes, value:Float)
	{
		if (timers == null) return;
		rates[type] = value;
	}
	public function update(elapsed:Float)
	{
		if (timers == null) return;
		
		for (type in Type.allEnums(ResourceTypes)){
			if (rates[type] <= 0.0 || ResourceMap[type] == null) continue;
			timers[type] += elapsed;
			if (caps[type] != null) if (ResourceMap[type] >= caps[type]) timers[type] = 0.0;
			if (timers[type] >= rates[type]){
				addResource(type, 1);
				timers[type] -= rates[type];
			}
		}
	}
}