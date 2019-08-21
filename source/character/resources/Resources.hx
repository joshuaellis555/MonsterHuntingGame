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
	private var ResourceMap:Map<ResourceTypes, Null<Float>>; //map of resources. Null values indicate the character can't gain/lose the resource.
	private var caps:Map<ResourceTypes, Null<Int>>; //map of resource caps. Null values indicate there is no limit.
	
	private var timers:Null<Map<ResourceTypes,Float>>=null; //map of timer. Null = timers not used
	private var rates:Map<ResourceTypes,Float>; // rate that resources are gained (seconds per 1 unit)
	
	public function new(caps:Array<Null<Int>>, ?resources:Null<Array<Null<Float>>>=null, ?useTimers:Bool=false) 
	{
		if (resources == null){ //if no resources array supplied use caps for initial value
			
			resources = [];
			for (i in 0...caps.length){
				if (caps[i]==null)
					resources.push(0); //if cap is also null set initial resource to 0
				else
					resources.push(caps[i]);
			}
		}
		ResourceMap = new Map<ResourceTypes, Null<Float>>();
		this.caps = new Map<ResourceTypes, Null<Int>>();
		var i:Int = 0;
		for (key in Type.allEnums(ResourceTypes)){ //Otherwise copy resources and caps. Set unspecified values to null
			if (i < resources.length && resources[i] != null){
				ResourceMap[key] = resources[i];
			}else{
				ResourceMap[key] = null;
			}
			if (i < caps.length && caps[i] != null){
				this.caps[key] = caps[i];
			}else{
				this.caps[key] = null;
			}
			i++;
		}
		
		
		if (useTimers){ //setup timers. Rates has to be set manually using setRate()
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
	public function setCap(type:ResourceTypes, newCap:Null<Int>)
	{	
		if (ResourceMap[type] > newCap){ //if character has more of resource than newCap set resource to newCap
			ResourceMap[type] = newCap;
			caps[type] = newCap;
		}else if (newCap > caps[type]){ // if newCap is greater than old cap, then give character the difference
			var increase:Float = newCap - caps[type];
			caps[type] = newCap;
			addResource(type, increase);
		}
	}
	
	public function get(type:ResourceTypes):Null<Float> //get a specific resource
	{
		return ResourceMap[type];
	}
	public function getMap():Map<ResourceTypes, Null<Float>> //get the entire map
	{
		return ResourceMap;
	}
	
	public function setResources(resources:Resources) //set the entire resource map
	{
		ResourceMap = resources.getMap();
	}
	public function set(type:ResourceTypes, value:Null<Float>) // set a specific resource
	{
		ResourceMap[type] = value;
	}
	
	public function add(resources:Resources) //add a full set of resources to this
	{
		for (type in Type.allEnums(ResourceTypes))
		{
			if (ResourceMap[type] != null && resources.get(type) != null) ResourceMap[type] += resources.get(type);
			if (ResourceMap[type] > 9999) ResourceMap[type] = 9999;
			if (caps[type] != null) if (ResourceMap[type] > caps[type]) ResourceMap[type] = caps[type];
			if (ResourceMap[type] < 0) ResourceMap[type] = 0;
		}
	}
	public function addResource(type:ResourceTypes, value:Float) //add a specific resource
	{
		if (ResourceMap[type] != null) ResourceMap[type] += value;
		if (ResourceMap[type] > 9999) ResourceMap[type] = 9999;
		if (caps[type] != null) if (ResourceMap[type] > caps[type]) ResourceMap[type] = caps[type];
		if (ResourceMap[type] < 0) ResourceMap[type] = 0;
	}
	
	public function multiply(multiplyer:Array<Float>) //multiply values by array of floats
	{												 //not sure if this is needed. May remove
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
	public function retMultiply(multiplyer:Array<Null<Float>>):Resources //multiply this by array of values and return the results
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
	
	public function remove(resources:Resources,?check:Bool=false,?allowNegative:Bool=false):Null<Bool> //remove set of resources
	{
		if (allowNegative){ //if allowNegative then dont wory about checking if this has the nessisary resources
			for (type in Type.allEnums(ResourceTypes))
			{
				if (resources.get(type) == null || ResourceMap[type] == null) continue;
				ResourceMap[type] -= resources.get(type);
			}
		}else if (check){ //if checking for the resources is required
			for (type in Type.allEnums(ResourceTypes)) //check each resource type to make sure this has the required amounts
			{
				if (resources.get(type) == null || ResourceMap[type] == null) continue;
				
				if (ResourceMap[type] < resources.get(type))
				{
					return false;
				} else 
					if (type == ResourceTypes.health && ResourceMap[type] == resources.get(type)) //Dont spend last health
						return false;
			}
			for (type in Type.allEnums(ResourceTypes)) //spend the resources
			{
				if (resources.get(type) == null) continue;
				if (ResourceMap[type] == null) continue;
				ResourceMap[type] -= resources.get(type);
			}
		}else{ //if check and allowNegative are false then remove resources down to a min of 0
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
	public function removeResource(type:ResourceTypes, value:Float,?check:Bool=false,?allowNegative:Bool=false):Null<Bool>
	{
		if (ResourceMap[type] == null) return null;
		if (allowNegative){ //if allowNegative then dont wory about checking if this has the nessisary resources
			ResourceMap[type] -= value;
		}else if (check){ //if checking for the resources is required
			if (ResourceMap[type] < value){ //check each resource type to make sure this has the required amounts
				return false;
			}else if (type == ResourceTypes.health && value == ResourceMap[type]) //Dont spend last health
				return false;
			ResourceMap[type] -= value;
		}else{ //if check and allowNegative are false then remove resources down to a min of 0
			if (ResourceMap[type] < value){
				ResourceMap[type] = 0;
			}else{
				ResourceMap[type] -= value;
			}
		}
		return true;
	}
	
	public function check(resources:Resources):Null<Bool> //check if resources are available but don't spend
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
	
	public function length():Int //number of resources in map
	{
		var l = 0;
		for (key in ResourceMap.keys())
		{
			if (ResourceMap[key] != null) l += 1;
		}
		return l;
	}
	public function types():Array<ResourceTypes> //types in map
	{
		var a:Array<ResourceTypes>;
		a = [];
		for (type in Type.allEnums(ResourceTypes))
		{
			if (ResourceMap[type] != null) a.push(type);
		}
		return a;
	}
	public function copy():Resources //copy resources from this (resources only)
	{
		var c:Resources = new Resources([0, 0, 0, 0, 0]);
		for (type in Type.allEnums(ResourceTypes))
			c.set(type, ResourceMap[type]);
		return c;
	}
	
	public function setRate(type:ResourceTypes, value:Float) //set a 
	{
		if (timers == null) return;
		rates[type] = value;
	}
	public function update(elapsed:Float)
	{
		if (timers == null) return; //skip if not using timers
		
		for (type in Type.allEnums(ResourceTypes)){
			if (rates[type] <= 0.0 || ResourceMap[type] == null) continue; //skip if resource uses invalid or null rate
			timers[type] += elapsed;
			if (caps[type] != null) if (ResourceMap[type] >= caps[type]) timers[type] = 0.0;
			if (timers[type] >= rates[type]){
				addResource(type, 1); //add one of the resource
				timers[type] -= rates[type];
			}
		}
	}
}