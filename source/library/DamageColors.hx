package library;
import character.damage.DamageTypes;
import flixel.util.FlxColor;

/**
 * ...
 * @author Joshua Ellis
 */
class DamageColors 
{
	private var damageColors:Map<DamageTypes,FlxColor>;
	public function new() 
	{
		damageColors = new Map<DamageTypes,FlxColor>();
		
		damageColors[DamageTypes.physical] = 0xffff0000;
		damageColors[DamageTypes.magic] = 0xff9999ff;
		damageColors[DamageTypes.fire] = 0xffff8811;
		damageColors[DamageTypes.cold] = 0xff4455ff;
		damageColors[DamageTypes.water] = 0xff0000ff;
		damageColors[DamageTypes.earth] = 0xff446611;
		damageColors[DamageTypes.nature] = 0xff44aa11;
		damageColors[DamageTypes.poison] = 0xff22cc00;
		damageColors[DamageTypes.lightning] = 0xffffff00;
		damageColors[DamageTypes.holy] = 0xffffffbb;
		damageColors[DamageTypes.dark] = 0xff222222;
		damageColors[DamageTypes.psychic] = 0xff442244;
	}
	public function get(type:DamageTypes):FlxColor
	{
		return damageColors[type];
	}
}