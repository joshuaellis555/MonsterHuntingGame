package character.damageNumbers;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.FlxG;
import utilities.plusInterface.BasicPlus;
import utilities.plusInterface.PlusInterface;
import library.Library;

/**
 * ...
 * @author Joshua Ellis
 */
class DamageNumber extends BasicPlus
{
	private var text:FlxText;
	private var color:FlxColor;
	private var number:String;
	private var timeThisTakes:Float = 1.0;
	private var life:Float = 0;
	private var x:Float;
	private var y:Float;
	private var size:Int = 20;
	//private var tWidth:Float;
	
	public function new(source:PlusInterface, x:Float, y:Float, color:FlxColor, number:String, startIn:Float)
	{
		super(source);
		this.x = x;
		this.y = y;
		this.color = color;
		this.life = -startIn;
		if (this.life > 0) this.life = 0;
		
		//tWidth = size * .662857;
		text = new FlxText(x, y, -1, number);
		text.setFormat(null, size, color, FlxTextAlign.CENTER);
		text.setBorderStyle(FlxTextBorderStyle.SHADOW, FlxColor.BLACK, 2);
		text.cameras = [Library.cameras.mainCam.flxCam()];
		text.visible = false;
		FlxG.state.add(text);
	}
	override public function update(elapsed:Float)
	{
		life += elapsed;
		if (life <= 0)
			return;
		else
			text.visible = true;
		text.x = x - Math.cos(life / timeThisTakes * 1.57) * 30 + 10;
		text.y = y - Math.sin(life / timeThisTakes * 1.57) * 30;
		if (life > timeThisTakes){
			super.destroy();
			text.destroy();
		}
	}
	override public function destroy()
	{
		for (i in trackedItems)
			i.destroy();
		if (tracker != null) tracker.removeItem(this);
	}
}