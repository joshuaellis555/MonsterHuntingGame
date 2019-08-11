package library;
import character.damage.DamageTypes;
import flixel.util.FlxColor;
import character.statusEffects.StatusTypes;

/**
 * ...
 * @author Joshua Ellis
 */
class StatusColors 
{
	private var statusColors:Map<StatusTypes,FlxColor>;
	public function new() 
	{
		statusColors = new Map<StatusTypes,FlxColor>();
		
		statusColors[StatusTypes.rage] = 0x00a00000;
		statusColors[StatusTypes.wet] = 0x000000bb;
		statusColors[StatusTypes.hot] = 0x00cc5500;
		statusColors[StatusTypes.cold] = 0x004455ff;
		statusColors[StatusTypes.drugged] = 0x007722aa;
		statusColors[StatusTypes.burn] = 0x00770000;
		statusColors[StatusTypes.slow] = 0x005500cc;
		statusColors[StatusTypes.delayed] = 0xffff9900;
	}
	public function get(type:StatusTypes):FlxColor
	{
		return statusColors[type];
	}
}