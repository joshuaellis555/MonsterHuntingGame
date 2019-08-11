package library;

/**
 * @author JoshuaEllis
 */

class StatTables
{
	public var handSize:Array<Int>;
	public var speed:Array<Float>;
	public var drawSpeed:Array<Float>;
	public var bonusDmg:Array<Float>;
	public var maxHealth:Array<Int>;
	public var dmgResistance:Array<Float>;
	public var staminaRegen:Array<Float>;
	public var stamina:Array<Int>;
	public var manaRegen:Array<Float>;
	public var mana:Array<Int>;
	public var magicDmg:Array<Float>;
	public var perception:Array<Float>;
	
	public function new()
	{
		handSize = [1, 2, 3, 4, 4, 4, 5, 5, 5, 5, 6, 6, 6, 6, 7, 7, 7, 7, 7, 8, 8];
		speed = [-.4, -.2, -.1, 0, 0.05, .1, .15, .2, .25, .3125, .375, .4375, .5, .5625, .625, .6875, .75, .8125, .875, .9375, 1.0];
		drawSpeed = [8.0, 7.0, 6.0, 5.0, 4.4, 4.25, 4.1, 3.95, 3.8, 3.65, 3.5, 3.35, 3.2, 3.05, 2.9, 2.75, 2.6, 2.45, 2.30, 2.15, 2.0];
		bonusDmg = [-.5, -.3, -.15, 0, .1, .2, .3, .4, .5, .625, .75, .875, 1.0, 1.125, 1.25, 1.375, 1.5, 1.625, 1.75, 1.875, 2.0];
		maxHealth = [30, 50, 75, 100, 150, 215, 300, 400, 520, 680, 850, 1050, 1300, 1600, 2000, 2500, 3200, 4000, 5000, 6000, 7000];
		dmgResistance = [-.5, -.3, -.15, 0, .1, .2, .3, .4, .45, .5, .55, .6, .65, .7, .75, .8, .84, .88, .92, .96, 1.0];
		staminaRegen = [-1, -.5, -.2, 0, 0.125, .25, .375, .5, .625, .75, .875, 1.0, 1.125, 1.25, 1.375, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0];
		stamina = [2, 3, 5, 7, 8, 10, 12, 14, 17, 20, 25, 30, 35, 40, 45, 50, 60, 70, 80, 90, 100];
		manaRegen = [-1, -.5, -.2, 0.0, 0.125, .25, .375, .5, .625, .75, .875, 1.0, 1.125, 1.25, 1.375, 1.5, 1.6, 1.7, 1.8, 1.9, 2.0];
		mana = [0, 5, 7, 10, 15, 20, 25, 30, 35, 40, 50, 60, 70, 80, 90, 100, 120, 140, 160, 180, 200];
		magicDmg = [ -1, -.5, -.25, 0, .2, .4, .6, .8, 1.0, 1.2, 1.4, 1.6, 1.8, 2.0, 2.2, 2.4, 2.6, 2.7, 2.8, 2.9, 3.0];
		perception = [ -100, -20, -5, 0, 2, 5, 8, 12, 16, 21, 27, 33, 39, 44, 50, 57, 65, 73, 81, 90, 100];
	}
	
}