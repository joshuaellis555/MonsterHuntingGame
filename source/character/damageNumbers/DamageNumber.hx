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
	private var text:FlxText; //text object
	private var color:FlxColor; //text color
	private var number:String; //the string displayed (can be text)
	private var timeThisTakes:Float = 1.0; //how long it lasts
	private var life:Float = 0; //time untill text disapears, also determins position
	private var x:Float;
	private var y:Float;
	private var size:Int = 20; //size of text
	
	public function new(source:PlusInterface, x:Float, y:Float, color:FlxColor, number:String, startIn:Float)
	{
		super(source);
		this.x = x;
		this.y = y;
		this.color = color;
		
		this.life = -startIn; //if startin is >0 then life = -startIn
		if (this.life > 0) this.life = 0;
		
		//create text object
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
		if (life <= 0) //if life < 0 then don't do anything yet (this is caused by startIn)
			return;
		else
			text.visible = true; //otherwise show text
		text.x = x - Math.cos(life / timeThisTakes * 1.57) * 30 + 10; //text position based on life value
		text.y = y - Math.sin(life / timeThisTakes * 1.57) * 30;
		if (life > timeThisTakes){ //distroy this when it is done
			super.destroy();
			text.destroy();
		}
	}
	override public function destroy() //if this would be destroyed, wait untill it is finished
	{
		for (i in trackedItems)
			i.destroy();
		if (tracker != null) tracker.removeItem(this);
	}
}