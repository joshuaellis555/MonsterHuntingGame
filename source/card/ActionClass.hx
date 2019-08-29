package card;
import library.Library;
import utilities.plusInterface.BasicPlus;

/**
 * ...
 * @author Joshua Ellis
 */
class ActionClass extends BasicPlus
{
	public var next:Null<ActionClass>;
	public var branch:Null<ActionClass>;
	public var boolBranch:Bool = false;
	public var card:Card;
	
	public function new(card:Card)
	{
		//trace("super");
		super(card);
		//trace("card");
		this.card = card;
		//trace("updateEnabled");
		updateEnabled = false;
		ID = Library.uniqueIDBot.get();
	}
	
	private function action():Void
	{
		card.currentAction = this;
		//trace("card.currentAction", card.currentAction);
	}
	
	public function trigger():Void 
	{
		boolBranch = false;
		updateEnabled = true;
		action();
	}
	
	public function triggerNext():Void 
	{
		updateEnabled = false;
		//trace("asdf");
		//trace("triggerNext",next,card.currentAction);
		if (card.currentAction == null || card.currentAction.ID != ID) return;
		
		if (boolBranch == true && branch != null) return branch.trigger();
		//trace('next');
		if (next != null) next.trigger();
	}
}